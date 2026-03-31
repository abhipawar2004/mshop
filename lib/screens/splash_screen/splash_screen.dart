import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/bloc/settings_bloc/settings_bloc.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/home_page/bloc/brands/brands_bloc.dart';
import 'package:hyper_local/screens/user_profile/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/user_details_bloc/user_details_bloc.dart';
import '../../bloc/user_details_bloc/user_details_state.dart';
import '../../config/constant.dart';
import '../../config/global.dart';
import '../../config/notification_service.dart';
import '../../config/settings_data_instance.dart';
import '../../config/theme.dart';
import '../../services/location/location_service.dart';
import '../home_page/bloc/banner/banner_bloc.dart';
import '../home_page/bloc/banner/banner_event.dart';
import '../home_page/bloc/category/category_bloc.dart';
import '../home_page/bloc/category/category_event.dart';
import '../home_page/bloc/feature_section_product/feature_section_product_bloc.dart';
import '../home_page/bloc/feature_section_product/feature_section_product_event.dart';
import '../home_page/bloc/sub_category/sub_category_bloc.dart';
import '../home_page/bloc/sub_category/sub_category_event.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasInitialized = false;
  bool _hasNavigated = false;
  bool _lastKnownConnectivity = false;
  late AppLocalizations _l10n;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _l10n = AppLocalizations.of(context)!;
  }

  @override
  void initState() {
    super.initState();
    getFcm();
    // Dispatch initial settings fetch immediately
    context.read<SettingsBloc>().add(FetchSettingsData(context: context));
  }

  Future<String?> getFcm() async {
    String? fcmToken = await getFCMToken();
    return fcmToken.toString();
  }

  // Helper method to show the location access dialog
  Future<bool?> _showLocationAccessDialog() async {
    if (!mounted) return null;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(_l10n.locationAccessNeeded),
        content: Text(_l10n.locationAccessDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_l10n.later),
          ),
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
              if (mounted) {
                Navigator.pop(context, true);
              }
            },
            child: Text(_l10n.openSettings),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
              if (mounted) {
                Navigator.pop(context, true);
              }
            },
            child: Text(_l10n.appPermissions),
          ),
        ],
      ),
    );
  }

  // Modified to use SettingsData.instance directly
  Future<void> _checkAndSetLocation() async {
    // Check if we can skip all location logic based on current stored state
    // Skip this check if we are in Demo Mode, as Demo Mode forces a default location.
    if (!AppConstant.isDemo && LocationService.hasStoredLocation()) {
      // Location already set and we are NOT in demo mode, so we are done.
      return;
    }

    String? lat, lng;

    // --- 1. Try getting location from SettingsData singleton (Web Settings) ---
    // Note: You specified SettingsData.instance.web instead of .system
    final webSettings = SettingsData.instance.web;
    if (webSettings != null) {
      lat = webSettings.defaultLatitude;
      lng = webSettings.defaultLongitude;
    }

    // Check if we got a valid location from settings
    if (lat != null && lng != null && lat.isNotEmpty && lng.isNotEmpty) {
      // Use the new function to store location with geocoding
      await LocationService.storeLocationFromCoordinates(
        latitude: lat,
        longitude: lng,
      );
      return;
    }

    // --- 2. Fallback to Demo Location (if isDemo is true) ---
    if (AppConstant.isDemo) {
      lat = AppConstant.defaultLat;
      lng = AppConstant.defaultLng;

      if (lat.isNotEmpty && lng.isNotEmpty) {
        // Since we skipped the initial hasStoredLocation check for isDemo == true,
        // this location will be stored regardless of what was previously in Hive.
        await LocationService.storeLocationFromCoordinates(
          latitude: lat,
          longitude: lng,
        );
        return;
      }
      // If AppConstant.isDemo is true but defaultLat/Lng are empty, we fall through to step 3.
    }

    // --- 3. Get Current Location (Default behavior for non-demo mode or if all fallbacks failed) ---
    // This step runs only if:
    // a) AppConstant.isDemo is false AND no location is stored.
    // b) AppConstant.isDemo is true but neither settings nor AppConstant provided valid coordinates.
    if (!LocationService.hasStoredLocation()) {
      final currentLoc =
          await LocationService.requestAndStoreLocationWithRetry();

      // If we still couldn't fetch/store location, guide user once via dialog.
      if (currentLoc == null) {
        final bool? granted = await _showLocationAccessDialog();

        if (granted == true) {
          await LocationService.requestAndStoreLocationWithRetry();
        }
      }
    }
  }

  Future<void> navigate() async {
    _dispatchInitialDataFetches();
    if (_hasNavigated) {
      return;
    }
    _hasNavigated = true;
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted || !_lastKnownConnectivity) {
      _hasNavigated = false;
      return;
    }

    // If first launch -> show intro slider
    if (Global.isFirstTime) {
      GoRouter.of(context).go(AppRoutes.introSlider);
      return;
    }

    // Not first launch: if logged in, go to home
    if (Global.userData?.token.isNotEmpty ?? false) {
      if (mounted) {
        GoRouter.of(context).go(AppRoutes.home);
      }
    } else {
      // Not logged in -> go to login
      GoRouter.of(context).go(AppRoutes.login);
    }
  }

  void _handleConnectivityChanged(bool isConnected) {
    if (!mounted) return;

    _lastKnownConnectivity = isConnected;

    if (!isConnected) {
      _hasNavigated = false;
      // You might want to show an offline UI here
      return;
    }

    // Hide offline UI here

    if (!_hasInitialized) {
      _hasInitialized = true;
      navigate();
      return;
    }

    if (!_hasNavigated) {
      navigate();
    }
  }

  Future<void> _initLocationNonBlocking() async {
    try {
      await _checkAndSetLocation().timeout(const Duration(seconds: 12));
    } on TimeoutException {
      // Allow navigation to continue even if location retrieval stalls
    }
  }

  void _dispatchInitialDataFetches() {
    // Settings data is already being fetched in initState.
    context.read<CategoryBloc>().add(FetchCategory(context: context));
    // context.read<CartBloc>().add(LoadCart());
    // context.read<GetUserCartBloc>().add(FetchUserCart());
    context.read<BannerBloc>().add(FetchBanner(categorySlug: ""));
    context.read<BrandsBloc>().add(const FetchBrands(categorySlug: ""));
    context
        .read<SubCategoryBloc>()
        .add(FetchSubCategory(slug: "", isForAllCategory: true));
    context
        .read<FeatureSectionProductBloc>()
        .add(FetchFeatureSectionProducts(slug: ""));
    context.read<UserProfileBloc>().add(FetchUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      // Listen for the settings data to be loaded
      listener: (context, state) async {
        if (state is SettingsLoaded) {
          // Kick off location setup without blocking navigation; timeout guards against long GPS waits
          _initLocationNonBlocking();

          // If connectivity status isn't known yet, assume online once to avoid getting stuck.
          if (!_lastKnownConnectivity) {
            _handleConnectivityChanged(true);
          } else {
            // If connectivity check already ran (before settings loaded), trigger navigation now
            _handleConnectivityChanged(true);
          }
        } else if (state is SettingsFailure) {
          // Allow app startup to continue even if settings API fails.
          if (_lastKnownConnectivity) {
            _handleConnectivityChanged(true);
          }
        }
      },
      child: BlocListener<UserDataBloc, UserDataState>(
        listener: (BuildContext context, UserDataState state) {
          // Your existing UserDataBloc listener logic if needed
        },
        child: CustomScaffold(
          showViewCart: false,
          notifyConnectivityStatusOnInit: true,
          onConnectivityChanged: (isConnected, _) {
            _lastKnownConnectivity = isConnected;
            // Only proceed with navigation if settings have already been loaded,
            // or if the settings bloc listener hasn't run yet (it will handle navigation then).
            final settingsState = context.read<SettingsBloc>().state;
            if (settingsState is SettingsLoaded ||
                settingsState is SettingsFailure) {
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  _handleConnectivityChanged(isConnected);
                }
              });
            }
          },
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: AppTheme.mainLightContainerBgColor,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.asset(
                      'assets/animations/splash.json',
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
