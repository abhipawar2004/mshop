import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/global_keys.dart';
import 'package:hyper_local/screens/auth/bloc/auth/auth_bloc.dart';
import 'package:hyper_local/screens/auth/bloc/auth/auth_state.dart';
import 'package:hyper_local/screens/auth/view/forgot_password.dart';
import 'package:hyper_local/screens/auth/view/login_page.dart';
import 'package:hyper_local/screens/auth/view/otp_verification_page.dart';
import 'package:hyper_local/screens/auth/view/register_page.dart';
import 'package:hyper_local/screens/cart_page/view/cart_page.dart';
import 'package:hyper_local/screens/cart_page/view/promo_code_page.dart';
import 'package:hyper_local/screens/category_list_page/view/category_list_page.dart';
import 'package:hyper_local/screens/home_page/view/home_page.dart';
import 'package:hyper_local/screens/introduction_pages/view/introduction_page.dart';
import 'package:hyper_local/screens/my_orders/view/delivery_tracking_page.dart';
import 'package:hyper_local/screens/my_orders/view/order_detail_page.dart';
import 'package:hyper_local/screens/my_orders/view/rate_your_exp_comments.dart';
import 'package:hyper_local/screens/my_orders/view/rate_your_exp_page.dart';
import 'package:hyper_local/screens/near_by_stores/view/nearby_store_details.dart';
import 'package:hyper_local/screens/near_by_stores/view/nearyby_stores_page.dart';
import 'package:hyper_local/screens/product_detail_page/view/faq_list_page/faq_list_page.dart';
import 'package:hyper_local/screens/product_detail_page/view/review_rating_list_page/review_rating_list_page.dart';
import 'package:hyper_local/screens/shopping_list_page/view/shopping_list_result_page.dart';
import 'package:hyper_local/screens/splash_screen/splash_screen.dart';
import 'package:hyper_local/screens/support_page/view/support_page.dart';
import 'package:hyper_local/screens/user_profile/view/user_profile_page.dart';
import 'package:hyper_local/screens/wallet_page/view/transaction_page.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:hyper_local/utils/widgets/empty_states_page.dart';
import 'package:hyper_local/utils/widgets/no_internet_connection.dart';
import '../config/map_code.dart';
import '../screens/account_page/view/account_page.dart';
import '../screens/brand_list_page/view/brands_list_page.dart';
import '../screens/dashboard/view/dashboard.dart';
import '../screens/my_orders/view/my_orders_page.dart';
import '../screens/my_orders/view/order_success_page.dart';
import '../screens/policies/view/app_policies_page.dart';
import '../screens/product_detail_page/view/product_detail_page.dart';
import '../screens/address_list_page/view/address_list_page.dart';
import '../screens/payment_options/view/payment_options_page.dart';
import '../screens/product_listing_page/model/product_listing_type.dart';
import '../screens/product_listing_page/view/product_listing_page.dart';
import '../screens/save_for_later_page/view/save_for_later_page.dart';
import '../screens/search_page/view/search_page.dart';
import '../screens/shopping_list_page/view/shopping_list_page.dart';
import '../screens/wallet_page/view/add_money_page.dart';
import '../screens/wallet_page/view/wallet_page.dart';
import '../screens/wishlist_page/view/wishlist_page.dart';
import '../screens/wishlist_page/view/wishlist_product_listing_page.dart';

Page platformPage(Widget child) {
  if (Platform.isIOS) {
    return CupertinoPage(child: child);
  } else {
    return MaterialPage(child: child);
  }
}

class AppRoutes {
  static const String splashScreen = '/';
  static const String introSlider = '/intro-slider';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String home = '/home';
  static const String orderAgain = '/order-again';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String locationPicker = '/location-picker';
  static const String account = '/account';
  static const String productListing = '/product-listing';
  static const String productDetailPage = '/product-detail';
  static const String reviewRatingPage = '/review-rating';
  static const String faqPage = '/faq';
  static const String addressList = '/address-list';
  static const String paymentOptions = '/payment-options';
  static const String orderSuccess = '/order-success';
  static const String userProfile = '/user-profile';
  static const String promoCode = '/promo-code';
  static const String myOrders = '/my-orders';
  static const String orderDetail = '/order-detail';
  static const String shoppingList = '/shopping-list';
  static const String wallet = '/wallet';
  static const String addMoney = '/add-money';
  static const String transactions = '/transactions';
  static const String deliveryTracking = '/delivery-tracking';
  static const String shoppingListResult = '/shopping-list-result';
  static const String wishlistPage = '/wishlist';
  static const String noInternet = '/no-internet';
  static const String search = '/search';
  static const String wishlistProduct = '/wishlist-product';
  static const String saveForLater = '/save-for-later';
  static const String policyPage = '/policy-page';
  static const String supportPage = '/support-page';
  static const String nearbyStores = '/near-by-store';
  static const String nearbyStoreDetails = '/near-by-store-details';
  static const String rateYourExp = '/rate-your-exp';
  static const String rateYourExpComments = '/rate-your-exp-comments';
  static const String forgotPassword = '/forgot-password';
  static const String maintenancePage = '/maintenance-page';
  static const String brandsListPage = '/brands-list-page';
}

class MyAppRoute {
  static GoRouter router = GoRouter(
    navigatorKey: GlobalKeys.navigatorKey,
    initialLocation: AppRoutes.splashScreen,
    routes: [

      GoRoute(
        name: '/',
        path: AppRoutes.splashScreen,
        pageBuilder: (context, state) => platformPage(SplashScreen()),
      ),

      GoRoute(
        name: '/intro-slider',
        path: AppRoutes.introSlider,
        pageBuilder: (context, state) => platformPage(IntroductionPage()),
      ),

      GoRoute(
        path: '/link',
        name: 'firebase-link',
        redirect: (context, state) {
          final authBloc = BlocProvider.of<AuthBloc>(GlobalKeys.navigatorKey.currentContext!);
          final authState = authBloc.state;

          // If we have pending registration data → go to OTP
          if (authState is LoginPhoneCodeSentState) {
            final pendingData = authBloc.getPendingRegistrationData();
            if (pendingData != null) {
              // Don't redirect here — let the pageBuilder push to OTP
              return null; // stay on /link temporarily
            } else {
              // No pending data → redirect to register
              return AppRoutes.register;
            }
          }

          // If auth failed → go to register
          if (authState is AuthFailed) {
            return AppRoutes.register;
          }

          // Otherwise stay on /link to show loading
          return null;
        },
        pageBuilder: (context, state) {
          return platformPage(
            BlocListener<AuthBloc, AuthState>(
              listener: (context, authState) async {
                if (authState is LoginPhoneCodeSentState) {
                  final bloc = context.read<AuthBloc>();
                  final pendingData = bloc.getPendingRegistrationData();

                  if (pendingData != null && context.mounted) {
                    context.pushReplacement(
                      // ← Use pushReplacement!
                      AppRoutes.otpVerification,
                      extra: {
                        'phoneNumber': bloc.getPendingPhoneNumber(),
                        'registrationData': pendingData,
                        'verificationId': authState.verificationId,
                        'userNumber': bloc.getPendingPhoneNumber(),
                        'countryCode': bloc.getPendingCountryCode(),
                        'isoCode': bloc.getPendingIsoCode(),
                      },
                    );
                  }
                  // No else needed — redirect will handle going to register
                }

                if (authState is AuthFailed && context.mounted) {
                  ToastManager.show(
                    context: context,
                    message: authState.error,
                    type: ToastType.error,
                  );

                  // This will now work reliably because redirect handles fallback
                  context.go(AppRoutes.register);
                }
              },
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CustomCircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),

      GoRoute(
          name: 'otp-verification',
          path: AppRoutes.otpVerification,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return platformPage(OTPVerificationPage(
              phoneNumber: extra['phoneNumber'] ?? '',
              registrationData: extra['registrationData'] ?? {},
              verificationId: extra['verificationId'] ?? '',
              number: extra['userNumber'] ?? '',
              countryCode: extra['countryCode'] ?? '',
              isoCode: extra['isoCode'] ?? '',
            ));
          }),

      GoRoute(
        name: 'login',
        path: AppRoutes.login,
        pageBuilder: (context, state) => platformPage(LoginPage()),
      ),

      GoRoute(
        name: 'forgot-password',
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) => platformPage(ForgotPassword()),
      ),

      GoRoute(
        name: 'no-internet',
        path: AppRoutes.noInternet,
        pageBuilder: (context, state) => platformPage(const NoInternetConnection()),
      ),

      GoRoute(
        name: 'register',
        path: AppRoutes.register,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return platformPage(RegisterPage(
            userName: extra['name'] ?? '',
            userEmail: extra['email'] ?? '',
          ));
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Dashboard(
            index: navigationShell.currentIndex,
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              name: 'home',
              path: AppRoutes.home,
              pageBuilder: (context, state) => platformPage(HomePage()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              name: 'category-list-page',
              path: AppRoutes.categories,
              pageBuilder: (context, state) => platformPage(CategoryListPage()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              name: 'near-by-store',
              path: AppRoutes.nearbyStores,
              pageBuilder: (context, state) =>
                  platformPage(NearbyStoresPage()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              name: 'account',
              path: AppRoutes.account,
              pageBuilder: (context, state) => platformPage(AccountPage()),
            ),
          ])
        ]),

      GoRoute(
        name: 'cart',
        path: AppRoutes.cart,
        pageBuilder: (context, state) => platformPage(CartPage()),
      ),
      GoRoute(
        name: 'location-picker',
        path: AppRoutes.locationPicker,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return LocationPickerWidget(
            initialLatitude: args?['lat'],
            initialLongitude: args?['lng'],
            initialAddress: args?['address'],
            isFromAddressPage: args?['isFromAddressPage'],
            isEdit: args?['isEdit'],
            addressId: args?['addressId'],
            addressType: args?['addressType'],
            isFromCartPage: args?['isFromCartPage'],
            deliveryZoneId: args?['deliveryZoneId'],
          );
        },
      ),
      GoRoute(
        name: 'product-listing',
        path: AppRoutes.productListing,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final isTheirMoreCategory = extra['isTheirMoreCategory'] as bool? ??
              false; // Default to false if null
          final dynamic rawType = extra['type'];
          final ProductListingType listingType = rawType is ProductListingType
              ? rawType
              : rawType is String
                  ? ProductListingType.values.firstWhere(
                      (e) => e.name == rawType,
                      orElse: () => ProductListingType.category,
                    )
                  : ProductListingType.category;
          final String identifier = (extra['identifier']?.toString() ??
              extra['categorySlug']?.toString() ??
              '');
          return platformPage(
            ProductListingPage(
              isTheirMoreCategory: isTheirMoreCategory,
              title: extra['title']?.toString() ?? '',
              logo: extra['logo']?.toString() ?? '',
              totalProduct: extra['totalProduct']?.toString() ?? '',
              type: listingType,
              identifier: identifier,
            ),
          );
        },
      ),
      GoRoute(
          name: 'product-detail',
          path: AppRoutes.productDetailPage,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final productSlug = extra['productSlug']?.toString() ?? '';
            final title = extra['title']?.toString() ?? '';
            final mainImage = extra['mainImage']?.toString() ?? '';
            return platformPage(ProductDetailPage(
              key: ValueKey('product-detail-$productSlug'),
              productSlug: productSlug,
              initialData: ProductInitialData(
                title: title,
                mainImage: mainImage
              ),
            ));
          }),
      GoRoute(
          name: 'review-rating',
          path: AppRoutes.reviewRatingPage,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, String>;
            return platformPage(ReviewRatingListPage(
              productSlug: extra['productSlug']!,
            ));
          }),
      GoRoute(
          name: 'faq',
          path: AppRoutes.faqPage,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, String>;
            return platformPage(FaqListPage(
              productSlug: extra['productSlug']!,
            ));
          }),
      GoRoute(
        name: 'address-list',
        path: AppRoutes.addressList,
        pageBuilder: (context, state) => platformPage(AddressListPage()),
      ),
      GoRoute(
        name: 'payment-options',
        path: AppRoutes.paymentOptions,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return platformPage(
            PaymentOptionsPage(
              totalAmount: extra['totalAmount']?.toDouble() ?? 0.0,
              isFromAddMoney: extra['isFromAddMoney'] as bool? ?? false,
            ),
          );
        },
      ),
      GoRoute(
          name: 'order-success',
          path: AppRoutes.orderSuccess,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return platformPage(
              OrderSuccessPage(
                address: extra['address'].toString(),
                addressType: extra['addressType'].toString(),
                orderSlug: extra['orderSlug'].toString()
              )
            );
          }
        ),

      GoRoute(
        name: 'user-profile',
        path: AppRoutes.userProfile,
        pageBuilder: (context, state) => platformPage(UserProfilePage()),
      ),

      GoRoute(
        name: 'promo-code',
        path: AppRoutes.promoCode,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return platformPage(PromoCodePage(
            cartAmount: extra['cartAmount']?.toDouble(),
            deliveryCharges: extra['deliveryCharges']?.toDouble(),
          ));
        },
      ),

      GoRoute(
        name: 'my-orders',
        path: AppRoutes.myOrders,
        pageBuilder: (context, state) => platformPage(MyOrdersPage()),
      ),

      GoRoute(
        name: 'order-detail',
        path: AppRoutes.orderDetail,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return platformPage(
            OrderDetailPage(
              orderSlug: extra['order-slug'],
            ),
          );
        },
      ),

      GoRoute(
        name: 'shopping-list',
        path: AppRoutes.shoppingList,
        pageBuilder: (context, state) => platformPage(ShoppingListPage()),
      ),

      GoRoute(
        name: 'wallet',
        path: AppRoutes.wallet,
        pageBuilder: (context, state) => platformPage(WalletPage()),
      ),

      GoRoute(
        name: 'add-money',
        path: AppRoutes.addMoney,
        pageBuilder: (context, state) => platformPage(AddMoneyPage()),
      ),

      GoRoute(
        name: 'transactions',
        path: AppRoutes.transactions,
        pageBuilder: (context, state) => platformPage(TransactionPage()),
      ),

      GoRoute(
        name: 'delivery-tracking',
        path: AppRoutes.deliveryTracking,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return platformPage(
            DeliveryTrackingPage(
              orderSlug: extra['order-slug'],
            ),
          );
        },
      ),

      GoRoute(
        name: 'shopping-list-result',
        path: AppRoutes.shoppingListResult,
        pageBuilder: (context, state) => platformPage(ShoppingListResultPage()),
      ),

      GoRoute(
        name: 'wishlist',
        path: AppRoutes.wishlistPage,
        pageBuilder: (context, state) => platformPage(WishlistPage()),
      ),

      GoRoute(
        name: 'search',
        path: AppRoutes.search,
        pageBuilder: (context, state) => platformPage(SearchPage()),
      ),

      GoRoute(
        name: 'wishlist-product',
        path: AppRoutes.wishlistProduct,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return platformPage(
            WishlistProductListingPage(
              wishlistId: extra['wishlist-id'],
            ),
          );
        },
      ),

      GoRoute(
        name: 'save-for-later',
        path: AppRoutes.saveForLater,
        pageBuilder: (context, state) => platformPage(SaveForLaterPage()),
      ),

      GoRoute(
        name: 'policy-page',
        path: AppRoutes.policyPage,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return platformPage(PolicyPage(
            policyType: extra['policy-type'] ?? PolicyType.aboutUs,
          )
          );
        }
      ),

      GoRoute(
        name: 'support-page',
        path: AppRoutes.supportPage,
        pageBuilder: (context, state) => platformPage(SupportPage()),
      ),

      GoRoute(
        name: 'near-by-store-details',
        path: AppRoutes.nearbyStoreDetails,
        pageBuilder: (context, state) {
          final map = state.extra as Map<String, dynamic>;
          final storeSlug = map['store-slug'];
          final storeName = map['store-name'];
          return platformPage(NearbyStoreDetails(storeSlug: storeSlug, storeName: storeName,));
        },
      ),

      GoRoute(
        name: 'rate-your-exp',
        path: AppRoutes.rateYourExp,
        pageBuilder: (context, state) {
          final map = state.extra as Map<String, dynamic>;
          final orderSlug = map["orderSlug"];
          final orderId = map["orderId"];
          return platformPage(
            RateYourExpPage(
              orderSlug: orderSlug,
              orderId: orderId,
            ),
          );
        },
      ),

      GoRoute(
        name: 'rate-your-exp-comments',
        path: AppRoutes.rateYourExpComments,
        pageBuilder: (context, state) {
          final map = state.extra as Map<String, dynamic>;
          final orderSlug = map["orderSlug"];
          final items = map["items"];
          return platformPage(
            RateYourExpComments(
                orderSlug: orderSlug,
                items: items
            ),
          );
        },
      ),

      GoRoute(
        name: 'maintenance-page',
        path: AppRoutes.maintenancePage,
        pageBuilder: (context, state) => platformPage(MaintenancePage()),
      ),

      GoRoute(
        name: 'brands-list-page',
        path: AppRoutes.brandsListPage,
        pageBuilder: (context, state) {
          final map = state.extra as Map<String, dynamic>;
          final categorySlug = map["category-slug"];
          return platformPage(
            BrandsListPage(
              categorySlug: categorySlug
            ),
          );
        },
      ),
    ]
  );
}
