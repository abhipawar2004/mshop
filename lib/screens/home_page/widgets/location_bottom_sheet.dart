import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/home_page/widgets/saved_address_list_widget.dart';
import 'package:remixicon/remixicon.dart';
import '../../../utils/widgets/custom_toast.dart';
import '../../address_list_page/bloc/get_address_list_bloc/get_address_list_bloc.dart';

class LocationBottomSheet extends StatefulWidget {
  const LocationBottomSheet({super.key});

  @override
  State<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<LocationSuggestion> _locationSuggestions = [];
  bool _isSearching = false;
  bool _isLoadingCurrentLocation = false;
  String? _currentLocationAddress;
  LatLng? _currentLocation;

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure latest addresses are available for quick access section
      context.read<GetAddressListBloc>().add(FetchUserAddressList());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingCurrentLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingCurrentLocation = false;
        });
        if(mounted) {
          _showErrorSnackBar(AppLocalizations.of(context)!.enableLocation);
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          _isLoadingCurrentLocation = false;
        });
        if(mounted) {
          _showErrorSnackBar(AppLocalizations.of(context)!.permissionDenied);
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          timeLimit: Duration(seconds: 15)
        ),
      );

      _currentLocation = LatLng(position.latitude, position.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _currentLocationAddress = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ].where((element) => element != null && element.isNotEmpty).join(', ');
      } else {
        _currentLocationAddress = "Current Location";
      }

      setState(() {
        _isLoadingCurrentLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCurrentLocation = false;
      });
      _showErrorSnackBar('Failed to get current location');
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _locationSuggestions.clear();
    });

    try {
      final dio = Dio();

      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': Platform.isAndroid ? AppConstant.androidMapKey : AppConstant.iosMapKey,
          'types': 'geocode',
        },
        options: Options(
          headers: {
            'Referer': 'com.hyperLocal.customer',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'OK') {
          List<LocationSuggestion> suggestions = [];

          for (var prediction in data['predictions']) {
            suggestions.add(LocationSuggestion(
              placeId: prediction['place_id'],
              displayName: prediction['structured_formatting']['main_text'] ?? '',
              address: prediction['description'] ?? '',
              latLng: const LatLng(0, 0),
            ));
          }

          setState(() {
            _locationSuggestions = suggestions;
            _isSearching = false;
          });
        } else {
          setState(() {
            _isSearching = false;
          });
          _showErrorSnackBar('No results found');
        }
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      _showErrorSnackBar('Search failed');
    }
  }

  Future<void> _getPlaceDetails(String placeId, String address) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry,formatted_address',
          'key': Platform.isAndroid ? AppConstant.androidMapKey : AppConstant.iosMapKey,
        },
        options: Options(
          headers: {
            'Referer': 'com.hyperLocal.customer',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        

        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];
          final double latitude = location['lat'].toDouble();
          final double longitude = location['lng'].toDouble();
          final String formattedAddress = data['result']['formatted_address'] ?? address;

          setState(() {
            _isSearching = false;
          });

          _selectLocation(latitude, longitude, formattedAddress);
        } else {
          setState(() {
            _isSearching = false;
          });
          _showErrorSnackBar('Unable to get location details');
        }
      } else {
        setState(() {
          _isSearching = false;
        });
        _showErrorSnackBar('Failed to fetch location details');
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      _showErrorSnackBar('Error: $e');
    }
  }

  void _selectLocation(double latitude, double longitude, String address) {
    Navigator.of(context).pop();

    GoRouter.of(context).push(
      AppRoutes.locationPicker,
      extra: {
        'lat': latitude,
        'lng': longitude,
        'address': address,
        'isFromAddressPage': false,
        'isEdit': false
      },
    );
  }

  void _useCurrentLocation() {
    if (_currentLocation != null && _currentLocationAddress != null) {
      _selectLocation(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        _currentLocationAddress!,
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ToastManager.show(
        context: context,
        message: message,
        type: ToastType.error
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _slideAnimation.value) * 300),
          child: Container(
            decoration: BoxDecoration(
              // color: Color(0XFFedf4fa),
              color: isDarkMode(context) ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchSection(),
                SizedBox(height: 12,),

                if(AppConstant.isDemo)
                  demoModeLocationNote(),
                SizedBox(height: 12,),

                // Scrollable content:
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_searchController.text.isNotEmpty && _locationSuggestions.isNotEmpty)
                          _buildSearchResults()
                        else
                          _buildCurrentLocationSection(),

                        SizedBox(height: 12),
                        SavedAddressListWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        alignment: Alignment.centerLeft,
        child: Text(
          AppLocalizations.of(context)!.selectDeliveryLocation,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDarkMode(context) ? Theme.of(context).colorScheme.onSecondary : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06), // Shadow color
                spreadRadius: 2, // How much the shadow spreads
                blurRadius: 7, // How blurry the shadow is
                offset: Offset(0, 3), // Offset of the shadow (x, y)
              ),
            ],
          ),
          child: TextFormField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            cursorColor: Theme.of(context).colorScheme.tertiary,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchForAreaStreet,
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
              fillColor: Colors.white,
              prefixIcon: Container(
                padding: const EdgeInsets.all(14),
                child: Icon(
                  RemixIcons.search_line,
                  size: 22,
                ),
              ),
              suffixIcon: _isSearching
                  ? const Padding(
                padding: EdgeInsets.all(14.0),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              )
                  : _searchController.text.isNotEmpty
                  ? IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[700],
                    size: 16,
                  ),
                ),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _locationSuggestions.clear();
                  });
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none
              ),
            ),
            onChanged: (value) {
              if (value.length > 2) {
                _searchPlaces(value);
              } else {
                setState(() {
                  _locationSuggestions.clear();
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget demoModeLocationNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      child: Container(
        width: double.infinity,
        color: Colors.red.shade100,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
        child: Text(
          AppConstant.demoModeLocationMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.red
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 15
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 400),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDarkMode(context) ? Theme.of(context).colorScheme.onSecondary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _locationSuggestions.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Colors.grey[100],
          ),
          itemBuilder: (context, index) {
            final suggestion = _locationSuggestions[index];
            return InkWell(
              onTap: () {
                if (suggestion.placeId != null) {
                  _getPlaceDetails(suggestion.placeId!, suggestion.address);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        TablerIcons.map_pin,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            suggestion.address,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentLocationSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 2
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _currentLocation != null && !_isLoadingCurrentLocation
                  ? _useCurrentLocation
                  : null,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  color: isDarkMode(context) ? Theme.of(context).colorScheme.onSecondary : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      TablerIcons.focus_2,
                      color: AppTheme.primaryColor,
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.useCurrentLocation,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      TablerIcons.chevron_right,
                      size: 22,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 2,
            ),
            InkWell(
              onTap: (){
                GoRouter.of(context).push(
                  AppRoutes.locationPicker,
                  extra: {
                    'isFromAddressPage': true,
                    'isEdit': false
                  },
                );
              },
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  color: isDarkMode(context) ? Theme.of(context).colorScheme.onSecondary : Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      TablerIcons.plus,
                      color: AppTheme.primaryColor,
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.addNewAddress,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      TablerIcons.chevron_right,
                      size: 22,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationSuggestion {
  final LatLng latLng;
  final String address;
  final String displayName;
  final String? placeId;

  LocationSuggestion({
    required this.latLng,
    required this.address,
    required this.displayName,
    this.placeId,
  });
}