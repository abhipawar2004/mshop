import 'dart:io' as io;
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hyper_local/firebase_options.dart';
import 'package:hyper_local/bloc/settings_bloc/settings_bloc.dart';
import 'package:hyper_local/bloc/theme_bloc/theme_bloc.dart';
import 'package:hyper_local/bloc/language_bloc/language_bloc.dart';
import 'package:hyper_local/bloc/cart_state_bloc/cart_state_bloc.dart';
import 'package:hyper_local/model/user_cart_model/user_cart.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/address_list_page/bloc/check_delivery_zone_bloc/check_delivery_zone_bloc.dart';
import 'package:hyper_local/screens/address_list_page/bloc/get_address_list_bloc/get_address_list_bloc.dart';
import 'package:hyper_local/screens/auth/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:hyper_local/screens/auth/bloc/user_verification/user_verification_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/attachment/attachment_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/cart_ui_bloc/cart_ui_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/clear_cart/clear_cart_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/get_user_cart/get_user_cart_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/promo_code/promo_code_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/remove_item_from_cart/remove_item_from_cart_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/update_item_quantity/update_item_quantity_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/validate_promo_code/validate_promo_code_bloc.dart';
import 'package:hyper_local/screens/category_list_page/bloc/all_category_bloc/all_category_bloc.dart';
import 'package:hyper_local/screens/my_orders/bloc/create_order/create_order_bloc.dart';
import 'package:hyper_local/screens/my_orders/bloc/delivery_boy_feedback/delivery_boy_feedback_bloc.dart';
import 'package:hyper_local/screens/my_orders/bloc/delivery_tracking/delivery_tracking_bloc.dart';
import 'package:hyper_local/screens/my_orders/bloc/download_invoice/download_invoice_bloc.dart';
import 'package:hyper_local/screens/my_orders/bloc/get_my_order/get_my_order_bloc.dart';
import 'package:hyper_local/screens/my_orders/bloc/order_detail/order_detail_bloc.dart';
import 'package:hyper_local/screens/my_orders/bloc/return_order_item/return_order_item_bloc.dart';
import 'package:hyper_local/screens/near_by_stores/bloc/near_by_store/near_by_store_bloc.dart';
import 'package:hyper_local/screens/near_by_stores/bloc/store_detail/store_detail_bloc.dart';
import 'package:hyper_local/screens/payment_options/bloc/payment_bloc.dart';
import 'package:hyper_local/screens/payment_options/repo/payment_repository.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/product_faq_bloc/product_faq_bloc.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/product_feedback/product_feedback_bloc.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/product_review_bloc/product_review_bloc.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/similar_product_bloc/similar_product_bloc.dart';
import 'package:hyper_local/screens/product_listing_page/bloc/nested_category/nested_category_bloc.dart';
import 'package:hyper_local/screens/product_listing_page/bloc/product_listing/product_listing_bloc.dart';
import 'package:hyper_local/screens/save_for_later_page/bloc/save_for_later_bloc/save_for_later_bloc.dart';
import 'package:hyper_local/screens/seller_page/bloc/seller_feedback/seller_feedback_bloc.dart';
import 'package:hyper_local/screens/shopping_list_page/bloc/shopping_list_bloc/shopping_list_bloc.dart';
import 'package:hyper_local/screens/user_profile/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:hyper_local/screens/wallet_page/bloc/prepare_wallet_recharge/prepare_recharge_bloc.dart';
import 'package:hyper_local/screens/wallet_page/bloc/user_wallet/user_wallet_bloc.dart';
import 'package:hyper_local/screens/wallet_page/bloc/wallect_transactions/wallet_transactions_bloc.dart';
import 'package:hyper_local/screens/wishlist_page/bloc/get_user_wishlist_bloc/get_user_wishlist_bloc.dart';
import 'package:hyper_local/screens/wishlist_page/bloc/wishlist_product_bloc/wishlist_product_bloc.dart';
import 'package:hyper_local/services/address/selected_address_hive.dart';
import 'package:hyper_local/services/location/user_location_hive.dart';
import 'package:hyper_local/services/shopping_list_hive.dart';
import 'package:hyper_local/services/user_cart/user_cart_local.dart';
import 'package:hyper_local/services/user_cart/user_cart_remote.dart';
import 'package:hyper_local/widgets/cart_state_listener.dart';
import 'package:hyper_local/screens/auth/bloc/auth/auth_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/banner/banner_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/banner/banner_event.dart';
import 'package:hyper_local/screens/home_page/bloc/brands/brands_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/category/category_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/category/category_event.dart';
import 'package:hyper_local/screens/home_page/bloc/feature_section_product/feature_section_product_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/feature_section_product/feature_section_product_event.dart';
import 'package:hyper_local/screens/home_page/bloc/sub_category/sub_category_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/sub_category/sub_category_event.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'bloc/user_cart_bloc/user_cart_bloc.dart';
import 'bloc/user_details_bloc/user_details_bloc.dart';
import 'config/global.dart';
import 'config/notification_service.dart';
import 'config/theme.dart';
import 'l10n/app_localizations.dart';
import 'model/user_cart_model/cart_sync_action.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  await FastCachedImageConfig.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  Hive.registerAdapter(CartSyncActionAdapter());
  Hive.registerAdapter(UserCartAdapter());
  await Hive.openBox<UserCart>('cartBox');

  await HiveLocationHelper.init();
  await HiveSelectedAddressHelper.init();
  await ShoppingListHiveHelper.init();
  await Global.initialize();
  await Global.initializePrefs();
  await Hive.openBox('themebox');

  if (kDebugMode) {
    io.HttpClient.enableTimelineLogging = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _initializeNotification();
    _getFcmToken();

    super.initState();
  }

  Future<void> _getFcmToken() async {
    try {
      await NotificationService().getFcmToken();
    } catch (e) {
      // Silent catch - FCM token is optional for app to work
    }
  }

  Future<void> _initializeNotification() async {
    await NotificationService(context: context).initFirebaseMessaging(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(UserDataBloc())),
        BlocProvider(
          create: (context) => CartBloc(
            CartLocalRepository(Hive.box<UserCart>('cartBox')),
            CartRemoteRepository(),
          ),
        ),
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(
            create: (context) =>
                CategoryBloc()..add(FetchCategory(context: context))),
        BlocProvider(
            create: (context) =>
                BannerBloc()..add(FetchBanner(categorySlug: ''))),
        BlocProvider(
            create: (context) => LanguageBloc()..add(const LoadLanguage())),
        BlocProvider(
            create: (context) => FeatureSectionProductBloc()
              ..add(FetchFeatureSectionProducts(slug: ''))),
        BlocProvider(
            create: (context) => SubCategoryBloc()
              ..add(FetchSubCategory(slug: '', isForAllCategory: true))),
        BlocProvider(create: (context) => UserDataBloc()),
        BlocProvider(create: (context) => BrandsBloc()..add(FetchBrands(categorySlug: ''))),
        BlocProvider(create: (context) => ProductDetailBloc()),
        BlocProvider(create: (context) => ProductListingBloc()),
        BlocProvider(create: (context) => NestedCategoryBloc()),
        BlocProvider(create: (context) => AddToCartBloc()),
        BlocProvider(create: (context) => GetUserCartBloc(context.read<CartBloc>(),)..add(FetchUserCart())),
        BlocProvider(create: (context) => CartStateBloc()),
        BlocProvider(create: (context) => ProductReviewBloc()),
        BlocProvider(create: (context) => ProductFAQBloc()),
        BlocProvider(create: (context) => RemoveItemFromCartBloc()),
        BlocProvider(create: (context) => ClearCartBloc()),
        BlocProvider(create: (context) => UpdateItemQuantityBloc()),
        BlocProvider(create: (context) => SimilarProductBloc()),
        BlocProvider(create: (context) => CheckDeliveryZoneBloc()),
        BlocProvider(create: (context) => GetAddressListBloc()),
        BlocProvider(create: (context) => SettingsBloc()..add(FetchSettingsData(context: context))),
        BlocProvider(create: (context) => CreateOrderBloc()),
        BlocProvider(create: (context) => UserProfileBloc()..add(FetchUserProfile())),
        BlocProvider(create: (context) => PromoCodeBloc()),
        BlocProvider(create: (context) => GetMyOrderBloc()),
        BlocProvider(create: (context) => OrderDetailBloc()),
        BlocProvider(create: (context) => DeliveryBoyFeedbackBloc()),
        BlocProvider(create: (context) => PaymentBloc( paymentRepository: PaymentRepository(), context: context)),
        BlocProvider(create: (context) => DownloadInvoiceBloc()),
        BlocProvider(create: (context) => PrepareRechargeBloc()),
        BlocProvider(create: (context) => UserWalletBloc()),
        BlocProvider(create: (context) => WalletTransactionsBloc()),
        BlocProvider(create: (context) => UserVerificationBloc()),
        BlocProvider(create: (context) => ShoppingListBloc()),
        BlocProvider(create: (context) => UserWishlistBloc()),
        BlocProvider(create: (context) => WishlistProductBloc()),
        BlocProvider(create: (context) => SaveForLaterBloc()),
        BlocProvider(create: (context) => NearByStoreBloc()),
        BlocProvider(create: (context) => ProductFeedbackBloc()),
        BlocProvider(create: (context) => SellerFeedbackBloc()),
        BlocProvider(create: (context) => ReturnOrderItemBloc()),
        BlocProvider(create: (context) => DeliveryTrackingBloc()),
        BlocProvider(create: (context) => StoreDetailBloc()),
        BlocProvider(create: (context) => ForgotPasswordBloc()),
        BlocProvider(create: (context) => CartUIBloc()),
        BlocProvider(create: (context) => AllCategoriesBloc()),
        BlocProvider(create: (context) => ValidatePromoCodeBloc()),
        BlocProvider(create: (context) => AttachmentBloc()),
      ],
      child: CartStateListener(
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (BuildContext context, themeMode) {
            return BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, languageState) {
                return GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: ScreenUtilInit(
                    child: SafeArea(
                      top: false,
                      bottom: Platform.isIOS ? false : true,
                      left: false,
                      right: false,
                      child: MaterialApp.router(
                        debugShowCheckedModeBanner: false,
                        theme: AppTheme.lightTheme,
                        darkTheme: AppTheme.darkTheme,
                        themeMode: themeMode,
                        builder: FToastBuilder(),
                        routerConfig: MyAppRoute.router,
                        localizationsDelegates:
                            AppLocalizations.localizationsDelegates,
                        supportedLocales: AppLocalizations.supportedLocales,
                        locale: languageState is LanguageLoaded
                            ? languageState.locale
                            : const Locale('en'),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
