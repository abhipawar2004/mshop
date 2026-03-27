import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/bloc/settings_bloc/settings_bloc.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/home_page/bloc/brands/brands_bloc.dart';
import 'package:hyper_local/screens/user_profile/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
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
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.locationAccessNeeded),
        content: Text(
          AppLocalizations.of(context)!.locationAccessDescription,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.later),
          ),
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
              if (mounted) {
                Navigator.pop(context, true);
              }
            },
            child: Text(AppLocalizations.of(context)!.openSettings),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
              if (mounted) {
                Navigator.pop(context, true);
              }
            },
            child: Text(AppLocalizations.of(context)!.appPermissions),
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
      final bool? granted = await _showLocationAccessDialog();

      if (granted == true) {
        final currentLoc =
            await LocationService.requestAndStoreLocationWithRetry();
        if (currentLoc == null) {
          // Handle case where location services are off or permission is denied after prompt
        }
      } else {
        // User pressed 'Later'
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
          // 1. Check/Set location using SettingsData.instance
          await _checkAndSetLocation();

          // 2. Now that settings and initial location logic is done, proceed with navigation logic
          if (_lastKnownConnectivity) {
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
                  color: AppTheme.primaryColor,
                  image: DecorationImage(
                    image: AssetImage('assets/images/doodle.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CustomImageContainer(
                      imagePath: getAppLogoUrl(context),
                      height: 180,
                      width: 250,
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

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/bloc/settings_bloc/settings_bloc.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/home_page/bloc/brands/brands_bloc.dart';
import 'package:hyper_local/screens/user_profile/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:hyper_local/model/user_location/user_location_model.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/empty_states_page.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/user_details_bloc/user_details_bloc.dart';
import '../../bloc/user_details_bloc/user_details_state.dart';
import '../../config/constant.dart';
import '../../config/global.dart';
import '../../services/location/location_service.dart';
import '../home_page/bloc/banner/banner_bloc.dart';
import '../home_page/bloc/banner/banner_event.dart';
import '../home_page/bloc/category/category_bloc.dart';
import '../home_page/bloc/category/category_event.dart';
import '../home_page/bloc/feature_section_product/feature_section_product_bloc.dart';
import '../home_page/bloc/feature_section_product/feature_section_product_event.dart';
import '../home_page/bloc/sub_category/sub_category_bloc.dart';
import '../home_page/bloc/sub_category/sub_category_event.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasInitialized = false;
  bool _hasNavigated = false;
  bool _lastKnownConnectivity = false;
  bool _settingsLoaded = false;
  bool _minSplashTimeElapsed = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> navigate() async {
    UserLocation? location = await LocationService.requestAndStoreLocationWithRetry();

    if (location == null) {
      // Optional: show guidance if still not ready
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.enableLocation),
          content: Text(
              AppLocalizations.of(context)!.turnOnLocationServices),
          actions: [
            TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
              },
              child: Text(
                AppLocalizations.of(context)!.locationServices,
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
            TextButton(
              onPressed: () async {
                await openAppSettings();
              },
              child: Text(
                AppLocalizations.of(context)!.appPermissions,
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context)!.close,
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          ],
        ),
      );
      // Try once more
      location = await LocationService.requestAndStoreLocationWithRetry();
    }

    // Dispatch all initial data fetches
    _dispatchInitialDataFetches();

    // Wait for minimum splash screen duration (3 seconds)
    await Future.delayed(Duration(seconds: 3));

    if (!mounted || !_lastKnownConnectivity) {
      return;
    }

    _minSplashTimeElapsed = true;

    // Check if settings are already loaded and navigate if ready
    _checkAndNavigate();
  }

  void _handleConnectivityChanged(bool isConnected) {
    _lastKnownConnectivity = isConnected;

    if (!isConnected) {
      _hasNavigated = false;
      // _showOfflinePage();
      return;
    }

    // _hideOfflinePage();

    if (!_hasInitialized) {
      _hasInitialized = true;
      navigate();
      return;
    }

    if (!_hasNavigated) {
      navigate();
    }
  }

  void _dispatchInitialDataFetches() {
    context.read<SettingsBloc>().add(FetchSettingsData(context: context));
    context.read<CategoryBloc>().add(FetchCategory(context: context));
    context.read<BannerBloc>().add(FetchBanner(categorySlug: ""));
    context.read<BrandsBloc>().add(FetchBrands(categorySlug: ""));
    context.read<SubCategoryBloc>().add(FetchSubCategory(slug: "", isForAllCategory: true));
    context
        .read<FeatureSectionProductBloc>()
        .add(FetchFeatureSectionProducts(slug: ""));
    context.read<UserProfileBloc>().add(FetchUserProfile());
  }

  void _handleSettingsSuccess() {
    _settingsLoaded = true;
    _checkAndNavigate();
  }

  void _checkAndNavigate() {
    // Only navigate if both conditions are met:
    // 1. Settings are loaded
    // 2. Minimum splash time has elapsed
    if (_hasNavigated || !_settingsLoaded || !_minSplashTimeElapsed) {
      return;
    }

    if (!mounted || !_lastKnownConnectivity) {
      return;
    }

    _performNavigation();
  }

  void _performNavigation() {
    if (_hasNavigated) {
      return;
    }

    _hasNavigated = true;

    // If first launch -> show intro slider
    if (Global.isFirstTime) {
      GoRouter.of(context).go(AppRoutes.introSlider);
      return;
    } else {
      if (mounted) {
        GoRouter.of(context).go(AppRoutes.home);
      }
    }

    // Alternative: Check if user is logged in
    // if (Global.userData?.token.isNotEmpty ?? false) {
    //   GoRouter.of(context).go(AppRoutes.home);
    // } else {
    //   GoRouter.of(context).go(AppRoutes.login);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserDataBloc, UserDataState>(
          listener: (BuildContext context, UserDataState state) {
            // Handle user data state if needed
          },
        ),
      ],
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (BuildContext context, SettingsState state) {
          if (state is SettingsLoaded) {
            _handleSettingsSuccess();
          } else if (state is SettingsFailure) {
            // Handle settings failure if needed
            // You might want to show an error dialog or retry
            if (!_hasNavigated && mounted) {
              GoRouter.of(context).push(AppRoutes.maintenancePage);
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text('Failed to load settings. Please try again.'),
              //     action: SnackBarAction(
              //       label: 'Retry',
              //       onPressed: () {
              //         context.read<SettingsBloc>().add(
              //           FetchSettingsData(context: context),
              //         );
              //       },
              //     ),
              //   ),
              // );
            }
          }
        },
        builder: (BuildContext context, SettingsState state) {
          if(state is SettingsFailure) {
            return MaintenancePage(
              onRetry: (){
                GoRouter.of(context).pushReplacement(AppRoutes.maintenancePage);
              },
            );
          }
          return Stack(
            children: [
              CustomScaffold(
                showViewCart: false,
                backgroundColor: Theme.of(context).colorScheme.surface,
                notifyConnectivityStatusOnInit: true,
                onConnectivityChanged: (isConnected, _) {
                  _handleConnectivityChanged(isConnected);
                },
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CustomImageContainer(
                        imagePath: getAppLogoUrl(context),
                        height: 180,
                        width: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 24),
                    // Optional: Add a loading indicator
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}*/
