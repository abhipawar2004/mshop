import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hyper_local/bloc/settings_bloc/settings_bloc.dart';
import 'package:hyper_local/config/settings_data_instance.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:hyper_local/model/settings_model/settings_model.dart';
import 'package:hyper_local/screens/address_list_page/bloc/get_address_list_bloc/get_address_list_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/get_user_cart/get_user_cart_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/banner/banner_event.dart';
import 'package:hyper_local/screens/home_page/bloc/category/category_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/category/category_event.dart';
import 'package:hyper_local/screens/home_page/bloc/feature_section_product/feature_section_product_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/feature_section_product/feature_section_product_event.dart';
import 'package:hyper_local/screens/home_page/bloc/feature_section_product/feature_section_product_state.dart';
import 'package:hyper_local/screens/home_page/bloc/sub_category/sub_category_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/sub_category/sub_category_event.dart';
import 'package:hyper_local/screens/home_page/widgets/brands_widget.dart';
import 'package:hyper_local/screens/near_by_stores/bloc/near_by_store/near_by_store_bloc.dart';
import 'package:hyper_local/screens/user_profile/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import 'package:hyper_local/utils/widgets/custom_shimmer.dart';
import '../../../config/constant.dart';
import '../../../utils/widgets/custom_circular_progress_indicator.dart';
import '../../../utils/widgets/custom_refresh_indicator.dart';
import '../../../utils/widgets/custom_scaffold.dart';
import '../bloc/banner/banner_bloc.dart';
import '../bloc/banner/banner_state.dart';
import '../bloc/brands/brands_bloc.dart';
import '../model/category_model.dart';
import '../model/featured_section_product_model.dart';
import '../widgets/animated_text_field.dart';
import '../widgets/banner_slider.dart';
import '../bloc/category/category_state.dart';
import '../widgets/location_bottom_sheet.dart';
import '../widgets/product_feature_section_widget.dart';
import '../widgets/sub_category_feature_section_widget.dart';
import '../../../utils/widgets/empty_states_page.dart';
import '../bloc/sub_category/sub_category_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  final ScrollController nestedScrollController = ScrollController();
  late String backgroundImagePath = '';
  String? backgroundColor;
  bool _isImageEmpty = false;
  Color? textColor;
  List<CategoryData> _categories = [];
  bool _isTabControllerInitialized = false;
  bool _isFlexibleSpaceHidden = false;
  bool _isRecreatingTabController = false;
  Color? _originalTextColor;
  Color? _collapsedTextColor;
  String? _lastLocationIdentifier;
  final Map<int, bool> _isLoadingMoreForTab = {};
  int localCategoryLength = 0;
  String _tabBarViewKey = 'initial';
  int _previousCategoryLength = 0;
  bool _isRedirecting = false;
  double _appBarOpacity = 1.0;
  bool _showScrollToTop = false;
  double _lastScrollPixels = 0.0;
  static const double _scrollThreshold = 100.0;
  double _latestScrollPixels = 0.0;
  bool isRetry = false;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _isImageEmpty = backgroundImagePath.isEmpty;
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    nestedScrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _applyHomeGeneralSettingsToAppBar();
        context.read<UserProfileBloc>().add(FetchUserProfile());
      }
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initialiseColors();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _tabController.index == 0) {
        _applyHomeGeneralSettingsToAppBar();
      }
      if (!_isImageEmpty && backgroundImagePath.isNotEmpty) {
        // Precache into memory using the same provider
        final provider = CachedNetworkImageProvider(backgroundImagePath);
        precacheImage(provider, context);
      }
    });
  }

  void initialiseColors() {
    _originalTextColor = Theme
        .of(context)
        .brightness == Brightness.light ? AppTheme.lightFontColor : AppTheme
        .darkFontColor;
    _collapsedTextColor = Theme
        .of(context)
        .brightness == Brightness.light ? AppTheme.lightFontColor : AppTheme
        .darkFontColor;
    textColor = _originalTextColor;
  }

  void updateAppBarBackground(
      {String? image, String? bgColor, Color? fontColor}) {
    setState(() {
      backgroundImagePath = image ?? '';
      backgroundColor = bgColor;
      _isImageEmpty = backgroundImagePath.isEmpty;
      _originalTextColor = fontColor ?? (Theme
          .of(context)
          .brightness == Brightness.light
          ? AppTheme.lightFontColor
          : AppTheme.darkFontColor);
      if (_isFlexibleSpaceHidden) {
        textColor = _collapsedTextColor;
      } else {
        textColor = _originalTextColor;
      }
    });
  }

  Color? _getColorFromHex(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return null;
    try {
      if (hexColor.startsWith('0x') || hexColor.startsWith('0X')) {
        return Color(int.parse(hexColor));
      }
      String cleanHex = hexColor.replaceAll('#', '');
      if (cleanHex.length == 6) {
        cleanHex = 'FF$cleanHex';
      }
      return Color(int.parse('0x$cleanHex'));
    } catch (e) {
      return null;
    }
  }

  void _onTabChanged() {
    if (!_canUseTabController || _isRedirecting) return;

    final int index = _tabController.index;
    final int totalTabs = _categories.length + 1;

    if (index >= totalTabs) {
      _ensureValidTabIndex();
      return;
    }

    context.read<FeatureSectionProductBloc>().add(
        ClearFeatureSectionProducts());

    if (index == 0) {
      apiCalls('');
      _applyHomeGeneralSettingsToAppBar();
    } else if (index > 0 && index - 1 < _categories.length) {
      final category = _categories[index - 1];
      apiCalls(category.slug ?? '');
      updateAppBarBackground(
        image: category.banner,
        bgColor: category.backgroundColor,
        fontColor: hexStringToColor(category.fontColor),
      );
    }

    scrollToTop(animated: true);
  }

  void _ensureValidTabIndex() {
    log('Ensure Valid Tab Index ${(!mounted || !_canUseTabController ||
        _isRedirecting)}');
    if (!mounted || !_canUseTabController || _isRedirecting) return;

    final int totalTabs = _categories.length + 1;
    final int currentIndex = _tabController.index;
    if (currentIndex >= totalTabs || currentIndex < 0) {
      _isRedirecting = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_canUseTabController) {
          _isRedirecting = false;
          return;
        }

        // 1. First, switch to "All" tab
        _tabController.animateTo(0);

        // 2. Apply "All" tab settings IMMEDIATELY
        _applyHomeGeneralSettingsToAppBar();

        // 3. Clear feature section products to prevent showing old data
        context.read<FeatureSectionProductBloc>().add(
            ClearFeatureSectionProducts());

        // 4. Make API calls with empty slug (for "All" tab)
        apiCalls('');

        // 5. Force TabBarView rebuild to reset scroll
        setState(() {
          _tabBarViewKey = 'reset_${DateTime
              .now()
              .millisecondsSinceEpoch}';
        });

        // 6. Scroll NestedScrollView to top
        if (nestedScrollController.hasClients) {
          nestedScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }

        // Reset flag after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _isRedirecting = false;
          }
        });
      });
    }
  }

  bool get _canUseTabController =>
      _isTabControllerInitialized && !_isRecreatingTabController && mounted;

  void _initializeTabController(int categoriesLength) {
    if (_tabController.length != categoriesLength + 1 &&
        !_isRecreatingTabController) {
      _isRecreatingTabController = true;

      // Defer controller recreation to next frame to avoid using disposed controller during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          _isRecreatingTabController = false;
          return;
        }

        try {
          if (_isTabControllerInitialized) {
            _tabController.removeListener(_onTabChanged);
            _tabController.dispose();
          }

          _tabController = TabController(
            length: categoriesLength + 1,
            vsync: this,
          );

          _isTabControllerInitialized = true;
          _tabController.addListener(_onTabChanged);
          _isRecreatingTabController = false;

          // Trigger rebuild after controller is recreated
          if (mounted) {
            setState(() {});
          }
        } catch (e) {
          _isRecreatingTabController = false;
          log('Error recreating TabController: $e');
        }
      });
    }
  }

  void apiCalls(String slug) async {
    // Don't use controller if it's being recreated
    if (!_canUseTabController) {
      return;
    }

    if (_tabController.index == 0) {
      context.read<FeatureSectionProductBloc>().add(
          FetchFeatureSectionProducts(slug: ''));
      context.read<SubCategoryBloc>().add(FetchSubCategory(slug: '', isForAllCategory: true));
      context.read<BrandsBloc>().add(FetchBrands(categorySlug: ''));
      context.read<BannerBloc>().add(FetchBanner(categorySlug: ''));
      context.read<GetUserCartBloc>().add(FetchUserCart());
      context.read<GetAddressListBloc>().add(FetchUserAddressList());
    }
    else {
      context.read<SubCategoryBloc>().add(FetchSubCategory(slug: slug, isForAllCategory: false));
      context.read<BannerBloc>().add(FetchBanner(categorySlug: slug));
      context.read<BrandsBloc>().add(FetchBrands(categorySlug: slug));
      context.read<FeatureSectionProductBloc>().add(
          FetchFeatureSectionProducts(slug: slug));
      context.read<GetUserCartBloc>().add(FetchUserCart());
      context.read<GetAddressListBloc>().add(FetchUserAddressList());
    }
    await Future.delayed(Duration(seconds: 1),(){
      if(mounted) {
        context.read<SettingsBloc>().add(FetchSettingsData(context: context));
      }
    });
  }

  void _refreshDataForCurrentTab() {
    if (_tabController.index == 0) {
      apiCalls('');
    } else if (_categories.isNotEmpty &&
        (_tabController.index - 1) < _categories.length) {
      final selectedCategory = _categories[_tabController.index - 1];
      apiCalls(selectedCategory.slug ?? '');
    } else {
      apiCalls('');
    }
  }

  void _refreshApiOnLocationChange() {
    context.read<CategoryBloc>().add(FetchCategory(context: context));
    context.read<NearByStoreBloc>().add(FetchNearByStores(perPage: 15, searchQuery: ''));
  }

  void _scrollListener() {
    double expandedHeight = 100.0.h;
    const double toolbarHeight = kToolbarHeight;
    final double flexibleSpaceHeight = expandedHeight - toolbarHeight;
    final double currentOffset = nestedScrollController.offset;
    final bool isHidden = currentOffset >= (flexibleSpaceHeight - 10);
    _appBarOpacity = (1 - (currentOffset / expandedHeight)).clamp(0.0, 1.0);

    if (_isFlexibleSpaceHidden != isHidden) {
      setState(() {
        _isFlexibleSpaceHidden = isHidden;
        if (_isFlexibleSpaceHidden) {
          textColor = _collapsedTextColor ?? (Theme
              .of(context)
              .brightness == Brightness.light
              ? AppTheme.lightFontColor
              : AppTheme.darkFontColor);
        } else {
          textColor = _originalTextColor ?? (Theme
              .of(context)
              .brightness == Brightness.light
              ? AppTheme.lightFontColor
              : AppTheme.darkFontColor);
        }
      });
    }
  }

  @override
  void dispose() {
    nestedScrollController.removeListener(_scrollListener);
    nestedScrollController.dispose();
    if (_isTabControllerInitialized) {
      _tabController.removeListener(_onTabChanged);
      _tabController.dispose();
    }
    super.dispose();
  }

  Widget _buildFlexibleSpaceBackground() {
    if (!_isImageEmpty && backgroundImagePath.isNotEmpty) {
      return CustomImageContainer(
        imagePath: backgroundImagePath,
        fit: BoxFit.cover,
      );
    } else {
      return _buildGradientBackground();
    }
  }

  Widget _buildGradientBackground() {
    Color primaryColor = AppTheme.primaryColor;
    if (backgroundColor != null) {
      Color? categoryColor = _getColorFromHex(backgroundColor);
      if (categoryColor != null) {
        primaryColor = categoryColor;
      }
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor,
            primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
    );
  }

  Widget _buildTabIcon(dynamic category, bool isSelected) {
    String? imageUrl;
    if (category.icon != null && category.icon!.isNotEmpty) {
      imageUrl = isSelected && category.activeIcon != null
          ? category.activeIcon
          : category.icon;
    } else if (category.image != null && category.image!.isNotEmpty) {
      imageUrl = category.image;
    }
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CustomImageContainer(
        imagePath: imageUrl,
        fit: BoxFit.contain,
      );
    } else {
      return const Icon(
        Icons.category_outlined,
        size: 28,
      );
    }
  }

  bool _isValidHomeGeneralSettings(HomeGeneralSettings settings) {
    return settings.title
        .trim()
        .isNotEmpty ||
        settings.icon
            .trim()
            .isNotEmpty ||
        settings.activeIcon
            .trim()
            .isNotEmpty;
  }

  void _applyHomeGeneralSettingsToAppBar() {
    final settings = SettingsData.instance.homeGeneralSettings;
    if (settings == null || !_isValidHomeGeneralSettings(settings)) {
      _collapsedTextColor = Theme
          .of(context)
          .brightness == Brightness.light
          ? AppTheme.lightFontColor
          : AppTheme.darkFontColor;
      updateAppBarBackground(
        image: '',
        bgColor: null,
        fontColor: Theme
            .of(context)
            .brightness == Brightness.light
            ? AppTheme.lightFontColor
            : AppTheme.darkFontColor,
      );
      return;
    }

    final String image = settings.backgroundImage.isNotEmpty ? settings
        .backgroundImage : '';
    final String? bgColor = settings.backgroundColor.isNotEmpty ? settings
        .backgroundColor : null;
    final Color? fontColor = settings.fontColor.isNotEmpty ? _getColorFromHex(
        settings.fontColor) : null;
    // if (fontColor != null) {
    //   _collapsedTextColor = fontColor;
    // }

    updateAppBarBackground(
      image: image,
      bgColor: bgColor,
      fontColor: fontColor,
    );
  }

  Widget _buildAllTabStatic() {
    return Tab(
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 50,
            child: Icon(HeroiconsOutline.squares2x2, size: 28),
          ),
          SizedBox(height: 0,),
          Text(
            AppLocalizations.of(context)!.all,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(height: 3,),
        ],
      ),
    );
  }

  Widget _buildAllTabDynamic(HomeGeneralSettings settings) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        final bool isSelected = _tabController.index == 0;
        final String iconUrl = isSelected
            ? (settings.activeIcon.isNotEmpty ? settings.activeIcon : settings
            .icon)
            : settings.icon;
        Widget iconWidget;
        if (iconUrl.isNotEmpty) {
          iconWidget = CachedNetworkImage(
            imageUrl: iconUrl,
            fit: BoxFit.contain,
          );
        } else {
          iconWidget = const Icon(
            HeroiconsOutline.squares2x2,
            size: 28,
          );
        }

        return Tab(
          height: 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 50,
                child: iconWidget,
              ),
              SizedBox(height: 0),
              Text(
                settings.title.isNotEmpty ? settings.title : AppLocalizations.of(context)!.all,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
              SizedBox(height: 3,),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopAddress() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<dynamic>('userLocationBox').listenable(),
      builder: (context, Box<dynamic> box, _) {
        final storedLocation = box.get('user_location');
        final locationIdentifier = storedLocation == null
            ? null
            : '${storedLocation.latitude}_${storedLocation
            .longitude}_${storedLocation.fullAddress}_${storedLocation
            .area}_${storedLocation.city}_${storedLocation.pincode}';

        if (_lastLocationIdentifier != locationIdentifier) {
          _lastLocationIdentifier = locationIdentifier;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _refreshDataForCurrentTab();
            _refreshApiOnLocationChange();
          });
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    useRootNavigator: true,
                    builder: (context) =>
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 50),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                              alpha: 0.1),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: LocationBottomSheet()),
                          ],
                        ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(TablerIcons.map_pin_filled, size: 22,
                              color: textColor),
                          SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              storedLocation?.area.isNotEmpty == true
                                  ? storedLocation!.area
                                  : '',
                              style: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,  // Add overflow handling
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(TablerIcons.chevron_down, size: 20,
                              color: textColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: 230.w,
                      child: Text(
                        storedLocation?.fullAddress.isNotEmpty == true
                            ? storedLocation!.fullAddress
                            : '',
                        style: TextStyle(
                          fontSize: 13,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget productFeaturedSectionEmptyState() {
    return SizedBox(
      height: isTablet(context) ? 240.h : 350.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15.0, vertical: 10.0),
            child: ShimmerWidget.rectangular(
              isBorder: true,
              height: 18,
              width: 200,
              borderRadius: 15,
            ),
          ),
          SizedBox(
            height: 210.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20, right: 20),
              itemCount: 8,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      ShimmerWidget.rectangular(
                        isBorder: true,
                        height: 105,
                        width: 100,
                        borderRadius: 15,
                      ),
                      const SizedBox(height: 10.0),
                      ShimmerWidget.rectangular(
                        isBorder: true,
                        height: 15,
                        width: 100,
                        borderRadius: 15,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<GetUserCartBloc, GetUserCartState>(
      listener: (BuildContext context, GetUserCartState state) {},
      child: CustomScaffold(
        showViewCart: true,
        onConnectivityRestored: (context) async {
          if (_tabController.index == 0) {
            apiCalls('');
          } else {
            final selectedCategory = _categories[_tabController.index - 1];
            apiCalls(selectedCategory.slug ?? '');
          }
        },
        body: Stack(
          children: [
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (BuildContext context, CategoryState state) {
                final homeGeneralSettings = SettingsData.instance
                    .homeGeneralSettings;
                List<Widget> tabBarTabs = [
                  if (homeGeneralSettings != null &&
                      _isValidHomeGeneralSettings(homeGeneralSettings))
                    _buildAllTabDynamic(homeGeneralSettings)
                  else
                    _buildAllTabStatic(),
                ];
                List<Widget> tabBarViewChildren = [
                  CustomRefreshIndicator(
                    onRefresh: () async {
                      apiCalls('');
                      _applyHomeGeneralSettingsToAppBar();
                      context.read<CategoryBloc>().add(
                          FetchCategory(context: context));
                    },
                    child: BlocBuilder<BannerBloc, BannerState>(
                      builder: (context, bannerState) {
                        return BlocBuilder<SubCategoryBloc, SubCategoryState>(
                          builder: (context, subCategoryState) {
                            return BlocBuilder<
                                FeatureSectionProductBloc,
                                FeatureSectionProductState>(
                              builder: (context, featureSectionState) {
                                return BlocBuilder<BrandsBloc, BrandsState>(
                                  builder: (context, brandsState) {
                                    final hasFailed = (bannerState is BannerFailed &&
                                        subCategoryState is SubCategoryFailed &&
                                        featureSectionState is FeatureSectionProductFailed &&
                                        brandsState is BrandsFailed);



                                    if (hasFailed) {
                                      return NoDeliveryLocationPage(
                                        onRetry: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) => Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 30),
                                                  child: Center(
                                                    child: GestureDetector(
                                                      onTap: () => Navigator.of(context).pop(),
                                                      child: Container(
                                                        padding: const EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape: BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black.withValues(alpha: 0.1),
                                                              blurRadius: 8,
                                                              offset: Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: const Icon(
                                                          Icons.close,
                                                          size: 20,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(child: LocationBottomSheet()),
                                              ],
                                            ),
                                          );

                                          /*setState(() {
                                            isRetry = true;
                                          });
                                          if (_tabController.index > 0) {
                                            final selectedCategory = _categories[_tabController
                                                .index - 1];
                                            apiCalls(selectedCategory.slug ?? '');
                                          } else {
                                            apiCalls('');
                                          }
                                          context.read<CategoryBloc>().add(
                                              FetchCategory(context: context));*/
                                        },
                                      );
                                    }

                                    return CustomScrollView(
                                      clipBehavior: Clip.antiAlias,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      slivers: [
                                        SliverToBoxAdapter(
                                          child: BlocBuilder<BannerBloc,
                                              BannerState>(
                                            builder: (BuildContext context,
                                                BannerState state) {
                                              if (state is BannerLoaded) {
                                                return AutoPlayCarouselSlider(
                                                    banners: state.topBannerData);
                                              } else if (state is BannerLoading) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: ShimmerWidget.rectangular(
                                                      isBorder: true, height: 220),
                                                );
                                              }
                                              return SizedBox.shrink();
                                            },
                                          ),
                                        ),
                                        SliverToBoxAdapter(
                                            child: SubCategoryFeatureSectionWidget()),
                                        SliverToBoxAdapter(child: BrandsSection(
                                            brandsSectionTitle: AppLocalizations.of(context)?.topBrands ?? 'Top Brands',
                                          categorySlug: '',
                                        ),
                                        ),
                                        SliverToBoxAdapter(
                                          child: BlocBuilder<
                                              FeatureSectionProductBloc,
                                              FeatureSectionProductState>(
                                            builder: (context, state) {
                                              if (state is FeatureSectionProductLoaded) {

                                                return ListView(
                                                  padding: EdgeInsets.only(top: 5.h),
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  children: [
                                                    // Global check
                                                    if (state.featureSectionProductData.any((s) => (s.products ?? []).isNotEmpty)) ...[
                                                      if (state.featureSectionProductData.isNotEmpty)
                                                        _buildFeatureSection(state.featureSectionProductData[0]),

                                                      middleBannersWidget(),

                                                      ...state.featureSectionProductData.skip(1).map((section) {
                                                        if ((section.products ?? []).isEmpty) return const SizedBox.shrink();
                                                        return _buildFeatureSection(section);
                                                      }),

                                                      if (!state.hasReachedMax)
                                                        const Padding(
                                                          padding: EdgeInsets.all(16.0),
                                                          child: Center(child: CustomCircularProgressIndicator()),
                                                        ),
                                                    ]
                                                  ],
                                                );

                                                /*return ListView.builder(
                                                  padding: EdgeInsets.only(
                                                      top: 5.h),
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: state.hasReachedMax
                                                      ? state
                                                      .featureSectionProductData
                                                      .length : state
                                                      .featureSectionProductData
                                                      .length + 2,
                                                  itemBuilder: (context, index) {
                                                    final bool hasAnyProducts = state
                                                        .featureSectionProductData
                                                        .any((section) {
                                                      final productList = section
                                                          .products ?? [];
                                                      return productList.isNotEmpty;
                                                    });
                                                    if (!hasAnyProducts) {
                                                      return SizedBox.shrink();
                                                    }
                                                    if (index >= state
                                                        .featureSectionProductData
                                                        .length) {
                                                      return const Padding(
                                                        padding: EdgeInsets.all(
                                                            16.0),
                                                        child: Center(
                                                          child: CustomCircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }

                                                    if (index == 1) {
                                                      return Column(
                                                        children: [
                                                          middleBannersWidget(),
                                                        ],
                                                      );
                                                    }

                                                    return hasAnyProducts
                                                        ? ProductFeatureSectionWidget(
                                                      featureSectionData: state
                                                          .featureSectionProductData[index],
                                                      featureSectionTitle: '',
                                                      backgroundImage: state
                                                          .featureSectionProductData[index]
                                                          .mobileBackgroundImage ?? '',
                                                      backgroundImageTablet: state
                                                          .featureSectionProductData[index]
                                                          .tabletBackgroundImage ?? '',
                                                      featureSectionSlug: state
                                                          .featureSectionProductData[index]
                                                          .slug ?? '',
                                                      featureSectionStyle: state
                                                          .featureSectionProductData[index]
                                                          .style!,
                                                      backgroundColor: state
                                                          .featureSectionProductData[index]
                                                          .backgroundColor,
                                                      backgroundType: state
                                                          .featureSectionProductData[index]
                                                          .backgroundType,
                                                    )
                                                        : SizedBox.shrink();
                                                  },
                                                );*/
                                              } else
                                              if (state is FeatureSectionProductLoading) {
                                                return productFeaturedSectionEmptyState();
                                              }
                                              return SizedBox.shrink();
                                            },
                                          ),
                                        ),
                                        SliverToBoxAdapter(
                                          child: SizedBox(height: 70,),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ];

                if (state is CategoryLoaded) {
                  if (isRetry) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Future.delayed(Duration(seconds: 1), () {
                        if (mounted) {
                          setState(() {
                            isRetry = false;
                          });
                        }
                      });
                    });
                  }
                  final newCategories = state.categoryData;
                  final int totalTabs = newCategories.length + 1;
                  final bool categoriesChanged = _previousCategoryLength !=
                      newCategories.length;
                  final int oldLength = _previousCategoryLength;
                  _previousCategoryLength = newCategories.length;

                  _categories = newCategories;

                  if (_tabController.length != totalTabs) {
                    _initializeTabController(newCategories.length);

                    if (oldLength == 0) {
                      apiCalls('');
                    }
                  }

                  // Critical: Handle invalid tab index when category is removed
                  if (_tabController.index >= totalTabs) {
                    _ensureValidTabIndex();
                  } else if (categoriesChanged && _tabController.index > 0 &&
                      !_isRedirecting) {
                    // Verify current category still exists by slug
                    final currentIndex = _tabController.index - 1;
                    if (currentIndex >= 0 && currentIndex <
                        oldLength - (oldLength - newCategories.length)) {
                      // Check if we need to redirect
                      if (currentIndex >= newCategories.length) {
                        _ensureValidTabIndex();
                      } else {
                        Future.delayed(Duration(milliseconds: 600), () {
                          apiCalls('');
                          _applyHomeGeneralSettingsToAppBar();
                        });
                      }
                    }
                  }

                  tabBarTabs.addAll(_categories
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final category = entry.value;
                    return AnimatedBuilder(
                      animation: _tabController,
                      builder: (context, child) {
                        bool isSelected = _tabController.index == index + 1;
                        return Tab(
                          height: 75,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 50,
                                child: _buildTabIcon(category, isSelected),
                              ),
                              SizedBox(height: 0,),
                              Text(
                                category.title ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 3,),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList());

                  // Build TabBarView children for categories
                  tabBarViewChildren.addAll(_categories
                      .asMap()
                      .entries
                      .map((entry) {
                    final category = entry.value;

                    return CustomRefreshIndicator(
                      onRefresh: () async {
                        apiCalls(category.slug ?? '');
                        updateAppBarBackground(
                          image: category.banner,
                          bgColor: category.backgroundColor,
                          fontColor: hexStringToColor(category.fontColor),
                        );
                        context.read<CategoryBloc>().add(
                            FetchCategory(context: context));
                      },
                      child: BlocBuilder<BannerBloc, BannerState>(
                        builder: (context, bannerState) {
                          return BlocBuilder<SubCategoryBloc, SubCategoryState>(
                            builder: (context, subCategoryState) {
                              return BlocBuilder<
                                  FeatureSectionProductBloc,
                                  FeatureSectionProductState>(
                                builder: (context, featureSectionState) {
                                  return BlocBuilder<BrandsBloc, BrandsState>(
                                    builder: (context, brandsState) {
                                      final hasFailed = bannerState is BannerFailed &&
                                          subCategoryState is SubCategoryFailed &&
                                          featureSectionState is FeatureSectionProductFailed &&
                                          brandsState is BrandsFailed;

                                      if (hasFailed) {
                                        return NoDeliveryLocationPage(
                                          onRetry: () {
                                            if (_categories.isNotEmpty &&
                                                (_tabController.index - 1) <
                                                    _categories.length) {
                                              final selectedCategory = _categories[_tabController
                                                  .index - 1];
                                              apiCalls(selectedCategory.slug ?? '');
                                            } else {
                                              apiCalls('');
                                            }
                                          },
                                        );
                                      }

                                      return CustomScrollView(
                                        physics: AlwaysScrollableScrollPhysics(),
                                        slivers: [
                                          SliverToBoxAdapter(
                                            child: BlocBuilder<
                                                BannerBloc,
                                                BannerState>(
                                              builder: (BuildContext context,
                                                  BannerState state) {
                                                if (state is BannerLoaded) {
                                                  return AutoPlayCarouselSlider(
                                                      banners: state.topBannerData);
                                                } else if (state is BannerLoading) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(
                                                        20.0),
                                                    child: ShimmerWidget
                                                        .rectangular(isBorder: true,
                                                        height: 220),
                                                  );
                                                }
                                                return SizedBox.shrink();
                                              },
                                            ),
                                          ),
                                          SliverToBoxAdapter(
                                              child: SubCategoryFeatureSectionWidget()),
                                          SliverToBoxAdapter(child: BrandsSection(
                                              brandsSectionTitle: AppLocalizations.of(context)?.topBrands ?? 'Top Brands',
                                            categorySlug: category.slug ?? '',
                                          )),
                                          SliverToBoxAdapter(
                                            child: BlocBuilder<
                                                FeatureSectionProductBloc,
                                                FeatureSectionProductState>(
                                              builder: (context, state) {
                                                if (state is FeatureSectionProductLoaded) {
                                                  /*return ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: state.featureSectionProductData.length + 1 + (state.hasReachedMax ? 0 : 1),
                                                    itemBuilder: (context, index) {
                                                      final items = state.featureSectionProductData;

                                                      // Loading at the very end
                                                      if (index == items.length + 1) {
                                                        return const Padding(
                                                          padding: EdgeInsets.all(16.0),
                                                          child: Center(child: CustomCircularProgressIndicator()),
                                                        );
                                                      }

                                                      if (index == 1) {
                                                        return middleBannersWidget();
                                                      }

                                                      // Map logical item index → real data index
                                                      final dataIndex = index > 1 ? index - 1 : index;

                                                      if (dataIndex >= items.length) {
                                                        return const SizedBox.shrink();
                                                      }

                                                      final section = items[dataIndex];
                                                      final products = section.products ?? [];

                                                      if (products.isEmpty) {
                                                        return const SizedBox.shrink();
                                                      }

                                                      return ProductFeatureSectionWidget(
                                                        featureSectionData: section,
                                                        featureSectionTitle: '',
                                                        backgroundImage: section.mobileBackgroundImage ?? '',
                                                        backgroundImageTablet: section.tabletBackgroundImage ?? '',
                                                        featureSectionSlug: section.slug ?? '',
                                                        featureSectionStyle: section.style!,
                                                        backgroundColor: section.backgroundColor,
                                                        backgroundType: section.backgroundType,
                                                      );
                                                    },
                                                  );*/

                                                  return ListView(
                                                    padding: EdgeInsets.only(top: 5.h),
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    children: [
                                                      // Global check
                                                      if (state.featureSectionProductData.any((s) => (s.products ?? []).isNotEmpty)) ...[
                                                        if (state.featureSectionProductData.isNotEmpty)
                                                          _buildFeatureSection(state.featureSectionProductData[0]),

                                                        middleBannersWidget(),

                                                        ...state.featureSectionProductData.skip(1).map((section) {
                                                          if ((section.products ?? []).isEmpty) return const SizedBox.shrink();
                                                          return _buildFeatureSection(section);
                                                        }),

                                                        if (!state.hasReachedMax)
                                                          const Padding(
                                                            padding: EdgeInsets.all(16.0),
                                                            child: Center(child: CustomCircularProgressIndicator()),
                                                          ),
                                                      ]
                                                    ],
                                                  );
                                                } else
                                                if (state is FeatureSectionProductLoading) {
                                                  return productFeaturedSectionEmptyState();
                                                }
                                                return SizedBox.shrink();
                                              },
                                            ),
                                          ),
                                          SliverToBoxAdapter(
                                            child: SizedBox(height: 70,),
                                          ),

                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  }).toList());
                }

                if (state is CategoryFailed && isRetry) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Future.delayed(Duration(seconds: 1), () {
                      if (mounted) {
                        setState(() {
                          isRetry = false;
                        });
                      }
                    });
                  });
                }

                return NestedScrollView(
                  controller: nestedScrollController,
                  physics: _canUseTabController ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  headerSliverBuilder: (BuildContext context,
                      bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: _canUseTabController ? 195.0 : 120,
                        floating: false,
                        pinned: true,
                        elevation: 3,
                        shadowColor: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.2),
                        backgroundColor: Color.lerp(
                          Colors.transparent,
                          Color(0xFFBDDCFB),
                          1 - _appBarOpacity,
                        ),
                        automaticallyImplyLeading: false,
                        title: _buildTopAddress(),
                        flexibleSpace: Container(
                          decoration: BoxDecoration(
                            gradient: isDarkMode(context) ? null : LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF89C4F4),
                                Color(0xFF89C4F4),
                                Color(0xFF89C4F4),
                                Color(0xFFb5d9f7),
                                Colors.white,
                              ],
                            ),
                            color: isDarkMode(context)
                                ? AppTheme.darkProductCardColor
                                : null,
                          ),
                          child: FlexibleSpaceBar(
                              background: _buildFlexibleSpaceBackground()),
                        ),
                        bottom: _canUseTabController
                            ? PreferredSize(
                          preferredSize: const Size.fromHeight(70),
                          child: Column(
                            children: [
                              CustomAnimatedTextField(),
                              const SizedBox(height: 5),
                              // Only show TabBar if controller is initialized and not being recreated
                              _canUseTabController
                                  ? TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                enableFeedback: true,
                                labelColor: textColor,
                                automaticIndicatorColorAdjustment: true,
                                unselectedLabelColor: textColor,
                                labelStyle: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold,
                                ),
                                unselectedLabelStyle: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w500),
                                indicatorColor: textColor,
                                indicatorWeight: 3,
                                indicatorSize: TabBarIndicatorSize.label,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0),
                                tabs: tabBarTabs,
                              )
                                  : const SizedBox(height: 50),
                            ],
                          ),
                        )
                            : PreferredSize(
                          preferredSize: const Size.fromHeight(30),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CustomAnimatedTextField(),
                          ),
                        ),
                      ),
                      if(isRetry)
                        SliverToBoxAdapter()
                    ];
                  },
                  body: _canUseTabController
                      ? NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      _handleScrollNotification(notification);
                      if (notification is ScrollUpdateNotification) {
                        final metrics = notification.metrics;
                        if (metrics.pixels >= metrics.maxScrollExtent * 0.85) {
                          _loadMoreForCurrentTab(_tabController.index);
                        }
                      }
                      return false;
                    },
                    child: TabBarView(
                      key: ValueKey(_tabBarViewKey),
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: tabBarViewChildren,
                    ),
                  )
                      : !isRetry ? NoDeliveryLocationPage(
                    onRetry: (){
                      setState(() {
                        isRetry = true;
                      });
                      if (_tabController.index > 0) {
                        final selectedCategory = _categories[_tabController
                            .index - 1];
                        apiCalls(selectedCategory.slug ?? '');
                      } else {
                        apiCalls('');
                      }
                      context.read<CategoryBloc>().add(
                          FetchCategory(context: context));
                    },
                  ) : SizedBox.shrink(),
                );
              },
            ),
            if (isRetry)
              Positioned.fill(
                top: 120,
                child: const Center(
                  child: CustomCircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget middleBannersWidget() {
    return BlocBuilder<
        BannerBloc,
        BannerState>(
      builder: (BuildContext context,
          BannerState state) {
        if (state is BannerLoaded) {
          return AutoPlayCarouselSlider(
              banners: state.middleBannerData);
        } else if (state is BannerLoading) {
          return Padding(
            padding: const EdgeInsets.all(
                20.0),
            child: ShimmerWidget
                .rectangular(isBorder: true,
                height: 220),
          );
        }
        return SizedBox.shrink();
      },
    );
  }


  Widget _buildFeatureSection(FeatureSectionData section) {
    return ProductFeatureSectionWidget(
      featureSectionData: section,
      featureSectionTitle: '',
      backgroundImage: section.mobileBackgroundImage ?? '',
      backgroundImageTablet: section.tabletBackgroundImage ?? '',
      featureSectionSlug: section.slug ?? '',
      featureSectionStyle: section.style!,
      backgroundColor: section.backgroundColor,
      backgroundType: section.backgroundType,
    );
  }

  void _loadMoreForCurrentTab(int tabIndex) {
    if (_isLoadingMoreForTab[tabIndex] == true) return;

    final featureSectionState = context
        .read<FeatureSectionProductBloc>()
        .state;
    if (featureSectionState is FeatureSectionProductLoaded &&
        !featureSectionState.hasReachedMax) {
      final slug = tabIndex == 0
          ? ''
          : (tabIndex - 1 < _categories.length)
          ? _categories[tabIndex - 1].slug ?? ''
          : '';

      _isLoadingMoreForTab[tabIndex] = true;
      context.read<FeatureSectionProductBloc>()
          .add(FetchMoreFeatureSectionProducts(slug: slug));

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _isLoadingMoreForTab[tabIndex] = false;
        }
      });
    }
  }

  EdgeInsets _getPadding(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final horizontalPadding = screenWidth * 0.04; // 4% of screen width
    return EdgeInsets.symmetric(horizontal: horizontalPadding);
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    if (screenWidth >= 1200) return 6;
    if (screenWidth >= 800) return 5;
    if (screenWidth >= 600) return 4;
    if (screenWidth >= 400) return 4;
    return 3;
  }

  double _getSpacing(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return screenWidth * 0.04;
  }

  Widget subCategoryLoading() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: _getPadding(context).copyWith(
              top: 12.0,
              bottom: 12.0,
            ),
            child: ShimmerWidget.rectangular(
              isBorder: true,
              height: 18,
              width: 200,
              borderRadius: 15,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: _getPadding(context),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              crossAxisSpacing: _getSpacing(context),
              mainAxisSpacing: _getSpacing(context),
              childAspectRatio: 0.65,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return const ResponsiveSubCategoryCardShimmer();
            },
          ),
        ],
      ),
    );
  }

  void scrollToTop({bool animated = true}) {
    if (!nestedScrollController.hasClients) return;

    if (animated) {
      nestedScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      nestedScrollController.jumpTo(0.0);
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    _latestScrollPixels = notification.metrics.pixels;

    final bool isScrollingUp = _latestScrollPixels < _lastScrollPixels;
    final bool shouldShowButton =
        isScrollingUp && _latestScrollPixels > _scrollThreshold;
    if (shouldShowButton != _showScrollToTop) {
      setState(() {
        _showScrollToTop = shouldShowButton;
      });
    }

    _lastScrollPixels = _latestScrollPixels;
    return false;
  }

}