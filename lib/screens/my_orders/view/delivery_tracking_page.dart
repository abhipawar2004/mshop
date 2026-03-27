import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/screens/my_orders/bloc/delivery_tracking/delivery_tracking_bloc.dart';
import 'package:hyper_local/config/global.dart';
import 'package:hyper_local/screens/my_orders/model/delivery_tracking_model.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:latlong2/latlong.dart';
import '../../../config/constant.dart';
import '../../../utils/widgets/custom_scaffold.dart';
import '../widgets/road_route.dart';

class DeliveryTrackingPage extends StatefulWidget {
  final String orderSlug;
  const DeliveryTrackingPage({super.key, required this.orderSlug});

  @override
  State<DeliveryTrackingPage> createState() => _DeliveryTrackingPageState();
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  late final MapController mapController;
  final DraggableScrollableController _sheetController =
  DraggableScrollableController();
  Timer? _refreshTimer;

  final latlng.LatLng _initialPosition = const latlng.LatLng(28.6139, 77.2090);
  LatLng? _currentLocation;
  LatLng? _deliveryPartnerLocation;
  LatLng? _destinationLocation;

  // Custom icons as raw bytes
  Uint8List? _meIconBytes;
  Uint8List? _deliveryBoyIconBytes;

  // Markers & Polylines
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  DeliveryBoyTrackingModel? _currentTracking;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _loadDeliveryBoyIcon();
    _ensureMeMarkerIcon();
    _setMarkersAndPolyline();

    context.read<DeliveryTrackingBloc>().add(
      FetchDeliveryTracking(orderSlug: widget.orderSlug),
    );

    _startPeriodicRefresh();
  }

  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (!mounted) return;
      context.read<DeliveryTrackingBloc>().add(
        FetchDeliveryTracking(orderSlug: widget.orderSlug),
      );
    });
  }

  Future<void> _loadDeliveryBoyIcon() async {
    try {
      final ByteData data =
      await rootBundle.load('assets/images/delivery-boy.png');
      final Uint8List bytes = data.buffer.asUint8List();
      final resized = await _resizeImage(bytes, 100, 100);
      if (mounted) {
        setState(() => _deliveryBoyIconBytes = resized);
        _setMarkersAndPolyline();
      }
    } catch (e) {
      debugPrint("Failed to load delivery boy icon: $e");
    }
  }

  Future<void> _ensureMeMarkerIcon() async {
    if (_meIconBytes != null) return;

    final profileUrl = Global.userData?.profileImage;
    final bytes = await buildPinLocationMarkerBytes(
      profileUrl,
      size: 70,
      pinColor: Colors.blue,
    );

    if (mounted) {
      setState(() {
        _meIconBytes = bytes;
        _setMarkersAndPolyline();
      });
    }
  }

  void _setMarkersAndPolyline() async {
    _markers.clear();
    _polylines.clear();

    // User (Me)
    if (_currentLocation != null && _meIconBytes != null) {
      _markers.add(
        Marker(
          point: _currentLocation!.toLatLng2(),
          width: 50,
          height: 50,
          alignment: Alignment.topCenter,
          child: Icon(
            TablerIcons.map_pin_filled,
            color: AppTheme.primaryColor,
            size: 40,
          ),
        ),
      );
    }

    // Delivery Partner
    if (_deliveryPartnerLocation != null && _deliveryBoyIconBytes != null) {
      _markers.add(
        Marker(
          point: _deliveryPartnerLocation!.toLatLng2(),
          width: 100,
          height: 100,
          child: Image.memory(_deliveryBoyIconBytes!),
        ),
      );
    }

    // Destination (optional)
    if (_destinationLocation != null) {
      _markers.add(
        Marker(
          point: _destinationLocation!.toLatLng2(),
          width: 50,
          height: 50,
          child: const Icon(Icons.location_pin, color: Colors.red, size: 50),
        ),
      );
    }

    // Road route between current and delivery partner
    if (_currentLocation != null && _deliveryPartnerLocation != null) {
      final roadPoints = await getRoadRoute(_currentLocation!, _deliveryPartnerLocation!);
      _polylines.add(
        Polyline(
          points: roadPoints.map((e) => e.toLatLng2()).toList(),
          color: AppTheme.primaryColor,
          strokeWidth: 4.0,
        ),
      );
    }

    setState(() {});
  }

  Future<Uint8List> _resizeImage(Uint8List data, int width, int height) async {
    final codec = await ui.instantiateImageCodec(data,
        targetWidth: width, targetHeight: height);
    final frame = await codec.getNextFrame();
    final byteData =
    await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }


  Future<Uint8List> buildPinLocationMarkerBytes(
      String? imageUrl, {
        int size = 50,
        Color pinColor = Colors.blue,
        Color borderColor = Colors.white,
        double borderWidth = 4,
      }) async {
    ui.Image? networkImage;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final data = await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
        final codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
            targetWidth: size - 20, targetHeight: size - 20);
        final frame = await codec.getNextFrame();
        networkImage = frame.image;
      } catch (e) {
        log("Failed to load profile image: $e");
      }
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final double radius = size / 2;
    final double centerX = size / 2;
    final double centerY = radius;

    // Shadow
    canvas.drawCircle(
      Offset(centerX, centerY + 6),
      radius,
      Paint()
        ..color = Colors.black26
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Pin background (teardrop)
    final path = ui.Path()
      ..addOval(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius))
      ..moveTo(centerX - 20, centerY + radius - 10)
      ..lineTo(centerX, size * 1.4)
      ..lineTo(centerX + 20, centerY + radius - 10)
      ..close();

    canvas.drawPath(path, Paint()..color = pinColor);

    // White circle border
    canvas.drawCircle(
        Offset(centerX, centerY), radius - 2, Paint()..color = borderColor);

    // Clip for profile photo
    canvas.save();
    canvas.clipPath(ui.Path()
      ..addOval(ui.Rect.fromCircle(
          center: Offset(centerX, centerY), radius: radius - borderWidth)));

    if (networkImage != null) {
      paintImage(
        canvas: canvas,
        rect: Rect.fromCircle(center: Offset(centerX, centerY), radius: radius - borderWidth),
        image: networkImage,
        fit: BoxFit.cover,
      );
    } else {
      // Default person icon
      final iconPaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(centerX, centerY - 12), 16, iconPaint);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(centerX - 18, centerY + 4, 36, 48),
          const Radius.circular(18),
        ),
        iconPaint,
      );
    }
    canvas.restore();

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), (size * 1.5).toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
  }

  Future<void> _onTrackingLoaded(DeliveryTrackingLoaded state) async {
    setState(() {
      _currentTracking = state.tracking;
    });

    final latStr = state.tracking.data?.deliveryBoy?.data?.latitude;
    final lngStr = state.tracking.data?.deliveryBoy?.data?.longitude;
    final lat = latStr != null ? double.tryParse(latStr) : null;
    final lng = lngStr != null ? double.tryParse(lngStr) : null;

    if (lat != null && lng != null) {
      _deliveryPartnerLocation = LatLng(lat, lng);

      // Use customer location from route
      final stops = _currentTracking?.data?.route?.routeDetails ?? [];
      final customerStop = stops.firstWhere(
            (s) =>
        (s.storeName ?? '').toLowerCase().contains('customer') ||
            (s.storeName ?? '').toLowerCase().contains('custom'),
        orElse: () => RouteDetails(),
      );

      if (customerStop.latitude != null && customerStop.longitude != null) {
        _currentLocation =
            LatLng(customerStop.latitude!, customerStop.longitude!);
      }

      await _ensureMeMarkerIcon();
      _setMarkersAndPolyline();

      // Smooth camera move to delivery partner
      if (mounted) {
        mapController.move(_deliveryPartnerLocation!.toLatLng2(), 15.5);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showViewCart: false,
      backgroundColor: Theme.of(context).colorScheme.outline,
      body: BlocConsumer<DeliveryTrackingBloc, DeliveryTrackingState>(
        listener: (context, state) {
          if (state is DeliveryTrackingLoaded) {
            _onTrackingLoaded(state);
          }
        },
        builder: (context, state) {
          final isFirstLoad = _currentTracking == null && state is DeliveryTrackingLoading;

          if (isFirstLoad) return _buildLoadingScreen();
          if (state is DeliveryTrackingFailed && _currentTracking == null) {
            return _buildErrorScreen(context);
          }

          return _buildMainUI(context, state);
        },
      ),
    );
  }

  Widget _buildLoadingScreen() => Stack(
    children: [
      _buildMap(),
      const Center(child: CustomCircularProgressIndicator()),
      _buildBackButton(),
    ],
  );

  Widget _buildErrorScreen(BuildContext context) => Stack(
    children: [
      _buildMap(),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.failedToLoadTrackingData,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<DeliveryTrackingBloc>().add(
                FetchDeliveryTracking(orderSlug: widget.orderSlug),
              ),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
      _buildBackButton(),
    ],
  );

  Widget _buildMainUI(BuildContext context, DeliveryTrackingState state) {
    final order = _currentTracking?.data?.order;
    final routeDetails = _currentTracking?.data?.route?.routeDetails ?? [];
    final partnerName =
        order?.deliveryBoyName ?? _currentTracking?.data?.deliveryBoy?.data?.deliveryBoy?.fullName ?? 'Delivery Partner';
    final partnerPhone = order?.deliveryBoyPhone?.toString();
    final deliveryPartnerProfile = order?.deliveryBoyProfile ?? '';

    final destTitle = order?.shippingAddressType ?? 'Destination';
    final destSubtitle = [order?.shippingAddress1, order?.shippingLandmark, order?.shippingCity]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .join(', ');

    final orderIdText = order?.id?.toString() ?? '';
    final paymentText = (order?.paymentStatus?.toLowerCase() == 'paid')
        ? 'Paid ${order?.paymentMethod ?? ''}'.trim()
        : (order?.paymentMethod ?? '');
    final placedAtText = order?.createdAt ?? '';

    return Stack(
      children: [
        _buildMap(),

        _buildBackButton(),

        // Manual refresh button
        PositionedDirectional(
          top: MediaQuery.of(context).padding.top + 10,
          end: 20,
          child: Container(
            decoration: BoxDecoration(
                color: isDarkMode(context) ? Theme.of(context).colorScheme.surface : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 8)
                ]),
            child: state is DeliveryTrackingLoading
                ? const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                  width: 20, height: 20, child: CustomCircularProgressIndicator()),
            )
                : IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<DeliveryTrackingBloc>().add(
                FetchDeliveryTracking(orderSlug: widget.orderSlug),
              ),
            ),
          ),
        ),

        // Bottom Sheet
        DraggableScrollableSheet(
          controller: _sheetController,
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          builder: (_, scrollController) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        order?.status == 'delivered' ? AppLocalizations.of(context)!.delivered : AppLocalizations.of(context)!.onTheWay,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        order?.estimatedDeliveryTime != null
                            ? AppLocalizations.of(context)!.trackingLiveLocation
                            : '${AppLocalizations.of(context)!.arrivingIn} ${order!.estimatedDeliveryTime} ${AppLocalizations.of(context)!.mins}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        _buildDeliveryPartnerSection(
                          name: partnerName,
                          phone: partnerPhone,
                          deliveryBoyProfile: deliveryPartnerProfile,
                        ),
                        _buildDeliveryDetailsSection(
                          stops: routeDetails,
                          destTitle: destTitle,
                          destSubtitle: destSubtitle,
                        ),
                        _buildOrderDetailsSection(
                          orderId: orderIdText,
                          payment: paymentText,
                          orderPlaced: paymentText,
                          placedAt: placedAtText,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: _initialPosition,
        initialZoom: 15.0,
        minZoom: 3,
        maxZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}",
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.hyperlocal.app',
        ),
        PolylineLayer(polylines: _polylines.toList()),
        MarkerLayer(markers: _markers.toList()),
      ],
    );
  }

  Widget _buildBackButton() => PositionedDirectional(
    top: MediaQuery.of(context).padding.top + 10,
    start: 20,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)]),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    ),
  );


  Widget _buildDeliveryPartnerSection({
    required String name,
    String? phone,
    String? deliveryBoyProfile
  }) {
    final bool hasPhone = phone != null && phone.trim().isNotEmpty && phone != 'null';
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
              radius: 25,
              backgroundImage: deliveryBoyProfile!.isNotEmpty ? NetworkImage(deliveryBoyProfile) : null,
              backgroundColor: Colors.grey[200],
              child: deliveryBoyProfile.isEmpty
                  ? Icon(Icons.person, size: 30, color: Colors.grey[600])
                  : SizedBox.shrink()
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.deliveryPartner,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (hasPhone)
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.phone, color: Colors.white),
                onPressed: () {
                  makePhoneCall(phoneNumber: phone, context: context);
                },
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.phone_disabled, color: Colors.grey[400]),
            ),
        ],
      ),
    );
  }

  Widget _buildDeliveryDetailsSection({required List<RouteDetails> stops, required String destTitle, required String destSubtitle,}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 12.0
          ),
          child: Text(
            AppLocalizations.of(context)!.deliveryDetails,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
            color: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // ---- for-loop that builds every stop ----
                for (final stop in stops) ...[
                  _buildDeliveryLocation(
                    icon: Icons.store,
                    title: stop.storeName ?? 'Store',
                    subtitle: [
                      stop.address,
                      stop.landmark,
                      stop.city,
                    ]
                        .whereType<String>()
                        .where((s) => s.trim().isNotEmpty)
                        .join(', '),
                    iconColor: AppTheme.primaryColor,
                    isUser: stop.storeName == 'Customer Location',
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            )
        ),

      ],
    );
  }

  Widget _buildDeliveryLocation({required IconData icon, required String title, required String subtitle, required Color iconColor, required bool isUser,}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetailsSection({
    required String orderId,
    required String payment,
    required String orderPlaced,
    required String placedAt,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Text(
            AppLocalizations.of(context)!.orderDetails,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          color: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              _buildOrderDetailRow(AppLocalizations.of(context)!.orderId, orderId),
              _buildOrderDetailRow(AppLocalizations.of(context)!.payment, payment),
              _buildOrderDetailRow(AppLocalizations.of(context)!.orderPlaced, placedAt),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _sheetController.dispose();
    super.dispose();
  }
}

extension on LatLng {
  latlng.LatLng toLatLng2() => latlng.LatLng(latitude, longitude);
}
