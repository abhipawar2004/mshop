import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hyper_local/config/global.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/screens/address_list_page/bloc/get_address_list_bloc/get_address_list_bloc.dart';
import 'package:hyper_local/utils/widgets/animated_button.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_shimmer.dart';
import 'package:hyper_local/utils/widgets/custom_textfield.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hyper_local/model/user_location/user_location_model.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/address_list_page/bloc/check_delivery_zone_bloc/check_delivery_zone_bloc.dart';
import '../services/location/location_service.dart';
import '../l10n/app_localizations.dart';
import 'constant.dart';

class LocationPickerWidget extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialAddress;
  final bool isFromAddressPage;
  final bool isEdit;
  final int? addressId;
  final String? addressType;
  final bool? isFromCartPage;
  final int? deliveryZoneId;

  const LocationPickerWidget(
      {super.key,
      this.initialLatitude,
      this.initialLongitude,
      this.initialAddress,
      required this.isFromAddressPage,
      required this.isEdit,
      this.addressId,
      this.addressType, this.isFromCartPage, this.deliveryZoneId});

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget>
    with TickerProviderStateMixin {
  GoogleMapController? mapController;
  LatLng? _currentUserLocation;
  LatLng _centerLocation = const LatLng(23.242847378221832, 69.6675021347692);
  bool _isLoading = true;
  bool _isMoving = false;
  String _currentAddress = "Fetching address..."; // Will be replaced by localized string
  bool _showForm = false;
  String selectedAddressType = 'home';
  List<bool> isSelected = [true, false, false];
  List<String> addressTypes = ['home', 'office', 'other'];

  // Add delivery zone check variables
  bool _isCheckingDelivery = false;
  bool _isDeliveryAvailable = false;
  String _deliveryMessage = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _pinAnimationController;
  late CheckDeliveryZoneBloc _checkDeliveryZoneBloc;

  final TextEditingController _searchController = TextEditingController();

  // Form controllers
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  String countryCode = 'IN';

  /// Flags
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize BLoC
    _checkDeliveryZoneBloc = CheckDeliveryZoneBloc();
    selectedAddressType = widget.addressType ?? 'home';
    // Initialize pin animation
    _pinAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _initializeLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _zipcodeController.dispose();
    _landmarkController.dispose();
    _pinAnimationController.dispose();
    _checkDeliveryZoneBloc.close();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    // Set initial location if provided
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _centerLocation =
          LatLng(widget.initialLatitude!, widget.initialLongitude!);
      _currentAddress = widget.initialAddress ?? "Selected location"; // Will use l10n
    }
    if (Global.userData?.mobile != null) {
      _mobileController.text = Global.userData!.mobile;
    }
    await _getCurrentUserLocation();

    setState(() {
      _isLoading = false;
    });

    _updateAddressFromCenter();
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentUserLocation =
              const LatLng(23.242847378221832, 69.6675021347692);
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          _currentUserLocation =
              const LatLng(23.242847378221832, 69.6675021347692);
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          timeLimit: Duration(seconds: 15)
        ),
      );

      setState(() {
        _currentUserLocation = LatLng(position.latitude, position.longitude);
        // If no initial location provided, use current location
        if (widget.initialLatitude == null || widget.initialLongitude == null) {
          _centerLocation = _currentUserLocation!;
        }
      });
    } catch (e) {
      log('Error getting location: $e');
      setState(() {
        _currentUserLocation =
            const LatLng(23.242847378221832, 69.6675021347692);
      });
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _isMoving = true;
      _centerLocation = position.target;
    });

    // Animate pin when moving
    _pinAnimationController.forward();
  }

  Future<void> _updateAddressFromCenter() async {
    setState(() {
      _currentAddress = "Getting address...";
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _centerLocation.latitude,
        _centerLocation.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ].where((element) => element != null && element.isNotEmpty).join(', ');

        if (mounted) {
          setState(() {
            _currentAddress = address.isNotEmpty ? address : "Unknown location"; // Will use l10n
          });
          _prefillFormFields(place);
        }
      } else {
        if (mounted) {
          setState(() {
            _currentAddress = "Unknown location"; // Will use l10n
          });
        }
      }
    } catch (e) {
      log('Error getting address: $e');
      if (mounted) {
        setState(() {
          _currentAddress =
              "Sample Address, ${_centerLocation.latitude.toStringAsFixed(4)}, ${_centerLocation.longitude.toStringAsFixed(4)}";
        });
      }
    }
  }

  void _prefillFormFields(Placemark place) {
    _addressLine1Controller.text = _currentAddress;
    _stateController.text = place.administrativeArea ?? '';
    _cityController.text = place.locality ?? '';
    _zipcodeController.text = place.postalCode ?? '';
    _landmarkController.text = place.name ?? '';
    _countryController.text = place.country ?? '';
    _areaController.text = place.subLocality ?? '';
    countryCode = place.isoCountryCode ?? '';
  }

  Future<void> _searchLocation() async {
    if (_searchController.text.isEmpty) return;

    try {
      List<Location> locations =
          await locationFromAddress(_searchController.text);

      if (locations.isNotEmpty && mapController != null) {
        LatLng searchLocation = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );

        setState(() {
          _centerLocation = searchLocation;
        });

        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(searchLocation, 15.0),
        );
      }
    } catch (e) {
      log('Error searching location: $e');
    }
  }

  void _toggleForm() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  void _onCameraIdle() {
    setState(() {
      _isMoving = false;
    });

    // Reset pin animation and update address
    _pinAnimationController.reverse();
    _updateAddressFromCenter();

    // Check delivery zone when camera stops moving
    _checkDeliveryZone();
  }

  // New method to check delivery zone
  void _checkDeliveryZone() {
    setState(() {
      _isCheckingDelivery = true;
      _isDeliveryAvailable = false;
      _deliveryMessage = '';
    });

    _checkDeliveryZoneBloc.add(CheckDeliveryZoneRequest(
      latitude: _centerLocation.latitude.toString(),
      longitude: _centerLocation.longitude.toString(),
    ));
  }

  void _confirmLocation() async {
    if (!_isDeliveryAvailable && !_showForm) {
      // Show error message if delivery is not available
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_deliveryMessage.isEmpty
              ? l10n.deliveryNotAvailableAtThisLocation
              : _deliveryMessage),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!widget.isFromAddressPage) {
      // Create UserLocation with form data
      UserLocation userLocation = UserLocation(
        latitude: _centerLocation.latitude,
        longitude: _centerLocation.longitude,
        fullAddress: _addressLine1Controller.text.trim(),
        area: _areaController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        country: _countryController.text.trim(),
        pincode: _zipcodeController.text.trim(),
        landmark: _landmarkController.text.trim(),
      );

      await LocationService.storeLocation(userLocation);

      if(mounted) {
        GoRouter.of(context).pop({
          'location': _centerLocation,
          'address': _addressLine1Controller.text,
        });
      }
    } else {
      // Show form only if delivery is available
      if (_isDeliveryAvailable) {
        _toggleForm();
      }
    }
  }

  // Updated method to build delivery status indicator
  Widget _buildDeliveryStatusIndicator() {

    if (!_isDeliveryAvailable && _deliveryMessage.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 30.h,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_rounded,
                size: isTablet(context) ? 18.r : 20.sp,
                color: Colors.red,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      return Text(
                        l10n.sorryWeDontDeliverHereYet,
                        style: TextStyle(
                          fontSize: isTablet(context) ? 20 : 14.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 4.h),
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      return Text(
                        l10n.thisLocationIsOutsideOurDeliveryZone,
                        style: TextStyle(
                          fontSize: isTablet(context) ? 18 : 12.sp,
                          color: Colors.red.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox.shrink();
  }

  Widget _buildFormFields() {
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Header Label
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return Text(
                    l10n.addressDetails,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: isTablet(context) ? 20 : 14.sp, fontWeight: FontWeight.w500),
                  );
                },
              ),
              SizedBox(height: 12.h),

              // Full Address Field
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return CustomTextFormField(
                    controller: _addressLine1Controller,
                    labelText: l10n.addressLine1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return l10n.pleaseEnterAddressLine1;
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 10.h),

              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return CustomTextFormField(
                    controller: _addressLine2Controller,
                    labelText: l10n.addressLine2Optional,
                  );
                },
              ),
              SizedBox(height: 10.h),

              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return CustomTextFormField(
                    controller: _countryController,
                    labelText: l10n.country,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return l10n.pleaseEnterCountry;
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 10.h),

              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return CustomTextFormField(
                    controller: _stateController,
                    labelText: l10n.state,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return l10n.pleaseEnterState;
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 10.h),

              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return CustomTextFormField(
                    controller: _cityController,
                    labelText: l10n.city,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return l10n.pleaseEnterCity;
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 10.h),

              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return CustomTextFormField(
                    controller: _zipcodeController,
                    labelText: l10n.zipcode,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return l10n.pleaseEnterZipcode;
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 10.h),

              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return CustomTextFormField(
                    controller: _landmarkController,
                    labelText: l10n.landmark,
                  );
                },
              ),
              SizedBox(height: 16.h),

              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return Text(
                    l10n.contactDetails,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: isTablet(context) ? 20 : 14.sp, fontWeight: FontWeight.w500),
                  );
                },
              ),
              SizedBox(height: 12.h),

              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return CustomTextFormField(
                    controller: _mobileController,
                    labelText: l10n.mobileNumber,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return l10n.pleaseEnterMobileNumber;
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 10.h),

              // Address Type
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return Text(
                    l10n.saveAddressAs,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: isTablet(context) ? 20 : 14.sp, fontWeight: FontWeight.w500),
                  );
                },
              ),
              SizedBox(height: 12.h),

              // Address type toggle buttons
              Row(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return _buildAddressTypeButton(
                          l10n.home,
                          TablerIcons.home,
                          selectedAddressType == 'home',
                          () {
                            setState(() {
                              selectedAddressType = 'home';
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return _buildAddressTypeButton(
                          l10n.work,
                          TablerIcons.building_skyscraper,
                          selectedAddressType == 'work',
                          () {
                            setState(() {
                              selectedAddressType = 'work';
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return _buildAddressTypeButton(
                          l10n.other,
                          TablerIcons.map_pin,
                          selectedAddressType == 'other',
                          () {
                            setState(() {
                              selectedAddressType = 'other';
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 16.h),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeButton(String label, IconData icon, bool isSelected, VoidCallback onTap,) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor.withValues(alpha: 0.8)
                : Colors.grey[300]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : null,
              size: isTablet(context) ? 25 : 20.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet(context) ? 18 : 12.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppTheme.primaryColor : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addAddressApi() {
    context.read<GetAddressListBloc>().add(AddAddressRequest(
        addressLine1: _addressLine1Controller.text,
        addressLine2: _addressLine2Controller.text,
        city: _cityController.text,
        landmark: _landmarkController.text,
        state: _stateController.text,
        zipcode: _zipcodeController.text,
        mobile: _mobileController.text,
        addressType: selectedAddressType,
        country: _countryController.text,
        countryCode: countryCode,
        latitude: _centerLocation.latitude.toString(),
        longitude: _centerLocation.longitude.toString(),
      deliveryZoneId: widget.deliveryZoneId
    ));
  }

  void updateAddressApi() {
    context.read<GetAddressListBloc>().add(UpdateAddressRequest(
        addressId: widget.addressId!,
        addressLine1: _addressLine1Controller.text,
        addressLine2: _addressLine2Controller.text,
        city: _cityController.text,
        landmark: _landmarkController.text,
        state: _stateController.text,
        zipcode: _zipcodeController.text,
        mobile: _mobileController.text,
        addressType: selectedAddressType,
        country: _countryController.text,
        countryCode: countryCode,
        latitude: _centerLocation.latitude.toString(),
        longitude: _centerLocation.longitude.toString()));
  }

  void _moveToCurrentLocation() async {
    if (_currentUserLocation == null) return;

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        _currentUserLocation!,
        16,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CustomCircularProgressIndicator(),
        ),
      );
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double mapHeight =
        _showForm ? MediaQuery.of(context).size.height * 0.35 : screenHeight;

    return MultiBlocListener(
      listeners: [
        BlocListener<GetAddressListBloc, GetAddressListState>(
          listener: (BuildContext context, GetAddressListState state) {
            if (state is GetAddressListLoaded) {
              if (state.isRemoved || state.isUpdated || state.isAdded) {
                setState(() {
                  isLoading = false;
                });
                GoRouter.of(context).pop();
              } else if (state.isRemoving ||
                  state.isUpdating ||
                  state.isAdding) {
                setState(() {
                  isLoading = true;
                });
              }
            }
          },
        ),
      ],
      child: BlocProvider<CheckDeliveryZoneBloc>(
        create: (context) => _checkDeliveryZoneBloc,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: BlocListener<CheckDeliveryZoneBloc, CheckDeliveryZoneState>(
            listener: (context, state) {
              if (state is CheckDeliveryZoneSuccess) {
                setState(() {
                  _isDeliveryAvailable = true;
                  _deliveryMessage = state.message;
                  _isCheckingDelivery = false;
                });
              } else if (state is CheckDeliveryZoneFailure) {
                setState(() {
                  _isDeliveryAvailable = false;
                  _deliveryMessage = state.error;
                  _isCheckingDelivery = false;
                });
              } else if (state is CheckDeliveryZoneFailure) {
                setState(() {
                  _isCheckingDelivery = false;
                });
              }
            },
            child: Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                ),
                // Google Map with animated height
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  height: mapHeight,
                  child: Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: _centerLocation,
                          zoom: 17.0,
                        ),
                        onCameraMove: _onCameraMove,
                        onCameraIdle: _onCameraIdle,
                        scrollGesturesEnabled: _showForm ? false : true,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        rotateGesturesEnabled: _showForm ? false : false,
                        zoomGesturesEnabled: _showForm ? false : true,
                        zoomControlsEnabled: _showForm ? false : true,
                        tiltGesturesEnabled: false,
                        mapToolbarEnabled: false,
                        markers: {},
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.bottomCenter,
                              child: Icon(
                                Remix.map_pin_range_fill,
                                color: AppTheme.primaryColor,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating app bar
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      // Circular back button
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon:
                              const Icon(Icons.arrow_back,),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Search bar integrated into app bar
                      if (!_showForm)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: _searchController,
                              onChanged: (value) => _searchLocation(),
                              textAlignVertical: TextAlignVertical.bottom,
                              cursorColor: Theme.of(context).colorScheme.tertiary,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.searchAnAreaOrAddress,
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                suffixIcon: Icon(TablerIcons.search,
                                    color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Bottom address card/form with animation
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      if(!_showForm)...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedButton(
                              onTap: (){
                                _moveToCurrentLocation();
                              },
                              child: Container(
                                margin: EdgeInsets.all(_showForm ? 0 : 16),
                                height: 60,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  TablerIcons.current_location,
                                  size: isTablet(context) ? 20.r : 24.r,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      Container(
                        margin: EdgeInsets.all(_showForm ? 0 : 16),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(_showForm ? 0 : 20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Content wrapper
                                SizedBox(
                                  height: _showForm
                                      ? MediaQuery.of(context).size.height * 0.65
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 18),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Header with back button for form
                                          if (_showForm)
                                            Builder(
                                              builder: (context) {
                                                final l10n = AppLocalizations.of(context)!;
                                                return Row(
                                                  children: [
                                                    Text(
                                                      l10n.enterCompleteAddress,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),

                                        if (_showForm) const SizedBox(height: 20),

                                        // Form fields or address display
                                        if (_showForm)
                                          Expanded(
                                            child: Column(
                                              children: [
                                                _buildFormFields(),
                                                SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: isTablet(context) ? 40.h : 48,
                                                        child: OutlinedButton(
                                                          onPressed: _toggleForm,
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                            side: BorderSide(
                                                                color: AppTheme.primaryColor),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(8),
                                                            ),
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                vertical: 14),
                                                          ),
                                                          child: Builder(
                                                            builder: (context) {
                                                              final l10n = AppLocalizations.of(context)!;
                                                              return Text(
                                                                l10n.cancel,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight.w600,
                                                                  color: AppTheme.primaryColor,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: CustomButton(
                                                        onPressed: () {
                                                          if (_formKey.currentState!
                                                              .validate()) {
                                                            if (widget.isEdit) {
                                                              updateAddressApi();
                                                            } else {
                                                              addAddressApi();
                                                            }
                                                          }
                                                        },

                                                        child: isLoading
                                                            ? SizedBox(
                                                                width: 20,
                                                                height: 20,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  strokeWidth: 2,
                                                                  valueColor:
                                                                      AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          Colors
                                                                              .white),
                                                                ),
                                                              )
                                                            : Builder(
                                                                builder: (context) {
                                                                  final l10n = AppLocalizations.of(context)!;
                                                                  return Text(
                                                                    widget.isEdit
                                                                        ? l10n.update
                                                                        : l10n.confirm,
                                                                    style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        else
                                          Column(
                                            children: [
                                              // Delivery status indicator
                                              _buildDeliveryStatusIndicator(),
                                              if (_isCheckingDelivery ||
                                                  _deliveryMessage.isNotEmpty)
                                                const SizedBox(height: 12),

                                              // Address section
                                              if (!_isMoving)
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      TablerIcons.map_pin_filled,
                                                      color: AppTheme.primaryColor,
                                                      size: 35,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            _currentAddress
                                                                .split(',')
                                                                .first,
                                                            style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            _currentAddress,
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey,
                                                            ),
                                                            maxLines: 3,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              else
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ShimmerWidget.rectangular(
                                                      isBorder: true,
                                                      height: 15,
                                                      width: 150,
                                                    ),
                                                    SizedBox(height: 5),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 50),
                                                      child:
                                                          ShimmerWidget.rectangular(
                                                        isBorder: true,
                                                        height: 15,
                                                      ),
                                                    )
                                                  ],
                                                ),

                                              const SizedBox(height: 20),

                                              // Proceed button
                                              SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: (_isMoving ||
                                                          _isCheckingDelivery ||
                                                          (!_isDeliveryAvailable &&
                                                              _deliveryMessage
                                                                  .isNotEmpty))
                                                      ? null
                                                      : _confirmLocation,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        _isDeliveryAvailable
                                                            ? AppTheme.primaryColor
                                                            : Colors.red,
                                                    foregroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(12),
                                                    ),
                                                    elevation: 2,
                                                  ),
                                                  child: _isCheckingDelivery
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Builder(
                                                              builder: (context) {
                                                                final l10n = AppLocalizations.of(context)!;
                                                                return Text(
                                                                  l10n.checkingDelivery,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                        FontWeight.w600,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      : Builder(
                                                          builder: (context) {
                                                            final l10n = AppLocalizations.of(context)!;
                                                            return Text(
                                                              !widget.isFromAddressPage
                                                                  ? l10n.confirmLocation
                                                                  : (_isDeliveryAvailable
                                                                      ? widget.isEdit
                                                                          ? l10n.confirmAddressToProceed
                                                                          : l10n.addAddressToProceed
                                                                      : l10n.deliveryNotAvailable),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
