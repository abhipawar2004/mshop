import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('gu'),
    Locale('hi'),
    Locale('te')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hyper Local'**
  String get appTitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Hyper Local'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'Gujarati'**
  String get gujarati;

  /// No description provided for @telugu.
  ///
  /// In en, this message translates to:
  /// **'Telugu'**
  String get telugu;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @nearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get nearby;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get networkError;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get tryAgain;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get permissionDenied;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required'**
  String get locationPermissionRequired;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services'**
  String get enableLocation;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @changeAppTheme.
  ///
  /// In en, this message translates to:
  /// **'Change app theme'**
  String get changeAppTheme;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System mode'**
  String get systemMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @viewCouponOffers.
  ///
  /// In en, this message translates to:
  /// **'View Coupon & Offers'**
  String get viewCouponOffers;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select payment method'**
  String get selectPaymentMethod;

  /// No description provided for @payUsing.
  ///
  /// In en, this message translates to:
  /// **'Pay Using'**
  String get payUsing;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmpty;

  /// No description provided for @looksLikeYouHaventAddedAnythingYet.
  ///
  /// In en, this message translates to:
  /// **'Looks like you haven\'t added anything yet'**
  String get looksLikeYouHaventAddedAnythingYet;

  /// No description provided for @browseProducts.
  ///
  /// In en, this message translates to:
  /// **'Browse products'**
  String get browseProducts;

  /// No description provided for @addMoreItemsTapped.
  ///
  /// In en, this message translates to:
  /// **'Add more items tapped!'**
  String get addMoreItemsTapped;

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get removeItem;

  /// No description provided for @areYouSureYouWantToRemoveItemFromCart.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {item} from cart?'**
  String areYouSureYouWantToRemoveItemFromCart(String item);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @saveForLater.
  ///
  /// In en, this message translates to:
  /// **'Save for Later'**
  String get saveForLater;

  /// No description provided for @billDetails.
  ///
  /// In en, this message translates to:
  /// **'Bill details'**
  String get billDetails;

  /// No description provided for @itemsTotal.
  ///
  /// In en, this message translates to:
  /// **'Items total'**
  String get itemsTotal;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @deliveryCharge.
  ///
  /// In en, this message translates to:
  /// **'Delivery charge'**
  String get deliveryCharge;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get free;

  /// No description provided for @perStoreDropOffFees.
  ///
  /// In en, this message translates to:
  /// **'Per store drop off fees'**
  String get perStoreDropOffFees;

  /// No description provided for @handlingCharge.
  ///
  /// In en, this message translates to:
  /// **'Handling charge'**
  String get handlingCharge;

  /// No description provided for @promoCode.
  ///
  /// In en, this message translates to:
  /// **'Promo code'**
  String get promoCode;

  /// No description provided for @promoDiscount.
  ///
  /// In en, this message translates to:
  /// **'Promo discount'**
  String get promoDiscount;

  /// No description provided for @removeCoupon.
  ///
  /// In en, this message translates to:
  /// **'Remove Coupon'**
  String get removeCoupon;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand total'**
  String get grandTotal;

  /// No description provided for @yourTotalSavings.
  ///
  /// In en, this message translates to:
  /// **'Your total savings'**
  String get yourTotalSavings;

  /// No description provided for @downloadInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download Invoice'**
  String get downloadInvoice;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @failedToLoadOrders.
  ///
  /// In en, this message translates to:
  /// **'Failed to load orders'**
  String get failedToLoadOrders;

  /// No description provided for @rateOrder.
  ///
  /// In en, this message translates to:
  /// **'Rate Order'**
  String get rateOrder;

  /// No description provided for @howWasYourOrder.
  ///
  /// In en, this message translates to:
  /// **'How was your order?'**
  String get howWasYourOrder;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @orderDetailsRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Order details refreshed'**
  String get orderDetailsRefreshed;

  /// No description provided for @rateYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate your experience'**
  String get rateYourExperience;

  /// No description provided for @failedToLoadOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load order details'**
  String get failedToLoadOrderDetails;

  /// No description provided for @noItemsToDisplay.
  ///
  /// In en, this message translates to:
  /// **'No items to display'**
  String get noItemsToDisplay;

  /// No description provided for @deleteReview.
  ///
  /// In en, this message translates to:
  /// **'Delete Review?'**
  String get deleteReview;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @cancelItem.
  ///
  /// In en, this message translates to:
  /// **'Cancel item'**
  String get cancelItem;

  /// No description provided for @areYouSureYouWantToCancelThisItem.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this item?'**
  String get areYouSureYouWantToCancelThisItem;

  /// No description provided for @cancelReturnRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel return request'**
  String get cancelReturnRequest;

  /// No description provided for @areYouSureYouWantToCancelThisReturnRequest.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this return request?'**
  String get areYouSureYouWantToCancelThisReturnRequest;

  /// No description provided for @cancelReturnRequestButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel Return Request'**
  String get cancelReturnRequestButton;

  /// No description provided for @cancelItemButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel Item'**
  String get cancelItemButton;

  /// No description provided for @howWasYourShoppingExperience.
  ///
  /// In en, this message translates to:
  /// **'How was your shopping experience?'**
  String get howWasYourShoppingExperience;

  /// No description provided for @trackDelivery.
  ///
  /// In en, this message translates to:
  /// **'Track Delivery'**
  String get trackDelivery;

  /// No description provided for @myWishlist.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get myWishlist;

  /// No description provided for @createNewWishlist.
  ///
  /// In en, this message translates to:
  /// **'Create new wishlist'**
  String get createNewWishlist;

  /// No description provided for @createNewWishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Wishlist'**
  String get createNewWishlistTitle;

  /// No description provided for @enterWishlistName.
  ///
  /// In en, this message translates to:
  /// **'Enter wishlist name'**
  String get enterWishlistName;

  /// No description provided for @pleaseEnterAWishlistName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a wishlist name'**
  String get pleaseEnterAWishlistName;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @editWishlist.
  ///
  /// In en, this message translates to:
  /// **'Edit Wishlist'**
  String get editWishlist;

  /// No description provided for @noWishlistsYet.
  ///
  /// In en, this message translates to:
  /// **'No wishlists yet'**
  String get noWishlistsYet;

  /// No description provided for @noOtherWishlistsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No other wishlists available'**
  String get noOtherWishlistsAvailable;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @deleteWishlistName.
  ///
  /// In en, this message translates to:
  /// **'Delete {wishlistName}'**
  String deleteWishlistName(String wishlistName);

  /// No description provided for @myAddresses.
  ///
  /// In en, this message translates to:
  /// **'My Addresses'**
  String get myAddresses;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddress;

  /// No description provided for @areYouSureYouWantToDeleteThisAddress.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get areYouSureYouWantToDeleteThisAddress;

  /// No description provided for @near.
  ///
  /// In en, this message translates to:
  /// **'Near'**
  String get near;

  /// No description provided for @noAddressSelected.
  ///
  /// In en, this message translates to:
  /// **'No address selected'**
  String get noAddressSelected;

  /// No description provided for @pleaseSelectAnImageAndEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please select an image and enter your name'**
  String get pleaseSelectAnImageAndEnterYourName;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfile;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @labelCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'{label} copied to clipboard'**
  String labelCopiedToClipboard(String label);

  /// No description provided for @yourDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Your Delivery Address'**
  String get yourDeliveryAddress;

  /// No description provided for @shoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingList;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @termsCondition.
  ///
  /// In en, this message translates to:
  /// **'Terms & Condition'**
  String get termsCondition;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @refundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get refundPolicy;

  /// No description provided for @shippingPolicy.
  ///
  /// In en, this message translates to:
  /// **'Shipping Policy'**
  String get shippingPolicy;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @nameMustBeAtLeast2Characters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMustBeAtLeast2Characters;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @specification.
  ///
  /// In en, this message translates to:
  /// **'Specification'**
  String get specification;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @similarProducts.
  ///
  /// In en, this message translates to:
  /// **'Similar Products'**
  String get similarProducts;

  /// No description provided for @specifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specifications;

  /// No description provided for @customerReviews.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get customerReviews;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @addYourReview.
  ///
  /// In en, this message translates to:
  /// **'Add Your Review'**
  String get addYourReview;

  /// No description provided for @rateThisProduct.
  ///
  /// In en, this message translates to:
  /// **'Rate this product'**
  String get rateThisProduct;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @questionAndAnswers.
  ///
  /// In en, this message translates to:
  /// **'Question and Answers'**
  String get questionAndAnswers;

  /// No description provided for @askAQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a Question'**
  String get askAQuestion;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @questionSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Question submitted successfully!'**
  String get questionSubmittedSuccessfully;

  /// No description provided for @pleaseSelectVariant.
  ///
  /// In en, this message translates to:
  /// **'Please select variant'**
  String get pleaseSelectVariant;

  /// No description provided for @viewProductDetails.
  ///
  /// In en, this message translates to:
  /// **'View Product Details'**
  String get viewProductDetails;

  /// No description provided for @productAddedToCartSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product added to cart successfully!'**
  String get productAddedToCartSuccessfully;

  /// No description provided for @failedToAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to add product: {error}'**
  String failedToAddProduct(String error);

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @productVariants.
  ///
  /// In en, this message translates to:
  /// **'Product Variants'**
  String get productVariants;

  /// No description provided for @selectVariant.
  ///
  /// In en, this message translates to:
  /// **'Select variant'**
  String get selectVariant;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noProductFound.
  ///
  /// In en, this message translates to:
  /// **'No Product Found'**
  String get noProductFound;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @popularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get popularity;

  /// No description provided for @searchResultFor.
  ///
  /// In en, this message translates to:
  /// **'Search result for \"{title}\"'**
  String searchResultFor(String title);

  /// No description provided for @relevanceDefault.
  ///
  /// In en, this message translates to:
  /// **'Relevance (default)'**
  String get relevanceDefault;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price (low to high)'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price (high to low)'**
  String get priceHighToLow;

  /// No description provided for @discountHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Discount (high to low)'**
  String get discountHighToLow;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @startTypingForSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Start typing for suggestions'**
  String get startTypingForSuggestions;

  /// No description provided for @noSuggestionsFound.
  ///
  /// In en, this message translates to:
  /// **'No suggestions found'**
  String get noSuggestionsFound;

  /// No description provided for @speak.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get speak;

  /// No description provided for @trySayingSomething.
  ///
  /// In en, this message translates to:
  /// **'Try saying something'**
  String get trySayingSomething;

  /// No description provided for @speechStoppedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Speech stopped. Try again.'**
  String get speechStoppedTryAgain;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProducts;

  /// No description provided for @searchForProducts.
  ///
  /// In en, this message translates to:
  /// **'Search for products'**
  String get searchForProducts;

  /// No description provided for @typeProductNameBrandOrCategory.
  ///
  /// In en, this message translates to:
  /// **'Type a product name, brand, or category to get started'**
  String get typeProductNameBrandOrCategory;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @trySearchingWithDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try searching with different keywords'**
  String get trySearchingWithDifferentKeywords;

  /// No description provided for @nearbyStores.
  ///
  /// In en, this message translates to:
  /// **'Nearby Stores'**
  String get nearbyStores;

  /// No description provided for @noStoresFoundNearby.
  ///
  /// In en, this message translates to:
  /// **'No stores found nearby.'**
  String get noStoresFoundNearby;

  /// No description provided for @searchInStore.
  ///
  /// In en, this message translates to:
  /// **'Search in {storeName}'**
  String searchInStore(String storeName);

  /// No description provided for @savedForLater.
  ///
  /// In en, this message translates to:
  /// **'Saved for later'**
  String get savedForLater;

  /// No description provided for @moveToCart.
  ///
  /// In en, this message translates to:
  /// **'Move to Cart'**
  String get moveToCart;

  /// No description provided for @addFirstItem.
  ///
  /// In en, this message translates to:
  /// **'Add First Item'**
  String get addFirstItem;

  /// No description provided for @resultFor.
  ///
  /// In en, this message translates to:
  /// **'Result for \"{title}\"'**
  String resultFor(String title);

  /// No description provided for @addMoney.
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get addMoney;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note:'**
  String get note;

  /// No description provided for @hyperlocalWalletBalanceValidFor1Year.
  ///
  /// In en, this message translates to:
  /// **'Hyperlocal Wallet balance is valid for 1 year from the date of money added'**
  String get hyperlocalWalletBalanceValidFor1Year;

  /// No description provided for @hyperlocalWalletBalanceCannotBeTransferred.
  ///
  /// In en, this message translates to:
  /// **'Hyperlocal Wallet balance cannot be transfer to a bank account as per RBI guidelines'**
  String get hyperlocalWalletBalanceCannotBeTransferred;

  /// No description provided for @pleaseEnterAnAmountGreaterThanOrEqualTo1.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount greater than or equal to 1'**
  String get pleaseEnterAnAmountGreaterThanOrEqualTo1;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @promoCodeCoupons.
  ///
  /// In en, this message translates to:
  /// **'Promo Code & Coupons'**
  String get promoCodeCoupons;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get callUs;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get emailUs;

  /// No description provided for @tapToContact.
  ///
  /// In en, this message translates to:
  /// **'Tap to contact'**
  String get tapToContact;

  /// No description provided for @rateStoreName.
  ///
  /// In en, this message translates to:
  /// **'Rate {storeName}'**
  String rateStoreName(String storeName);

  /// No description provided for @editYourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Edit your feedback'**
  String get editYourFeedback;

  /// No description provided for @howWasYourExperience.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get howWasYourExperience;

  /// No description provided for @tapToRate.
  ///
  /// In en, this message translates to:
  /// **'Tap to rate'**
  String get tapToRate;

  /// No description provided for @star.
  ///
  /// In en, this message translates to:
  /// **'{rating} Star'**
  String star(int rating);

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'{rating} Stars'**
  String stars(int rating);

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get titleRequired;

  /// No description provided for @egGreatService.
  ///
  /// In en, this message translates to:
  /// **'e.g., Great service!'**
  String get egGreatService;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description *'**
  String get descriptionRequired;

  /// No description provided for @shareMoreDetails.
  ///
  /// In en, this message translates to:
  /// **'Share more details...'**
  String get shareMoreDetails;

  /// No description provided for @submitFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// No description provided for @updateFeedback.
  ///
  /// In en, this message translates to:
  /// **'Update Feedback'**
  String get updateFeedback;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @deleteFeedback.
  ///
  /// In en, this message translates to:
  /// **'Delete Feedback'**
  String get deleteFeedback;

  /// No description provided for @areYouSureYouWantToDeleteThisFeedback.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this feedback?'**
  String get areYouSureYouWantToDeleteThisFeedback;

  /// No description provided for @pleaseGiveARating.
  ///
  /// In en, this message translates to:
  /// **'Please give a rating'**
  String get pleaseGiveARating;

  /// No description provided for @pleaseEnterATitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterATitle;

  /// No description provided for @pleaseEnterADescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get pleaseEnterADescription;

  /// No description provided for @deliveryType.
  ///
  /// In en, this message translates to:
  /// **'Delivery Type'**
  String get deliveryType;

  /// No description provided for @rushDelivery.
  ///
  /// In en, this message translates to:
  /// **'Rush Delivery'**
  String get rushDelivery;

  /// No description provided for @prioritizedDeliveryForYourUrgentNeeds.
  ///
  /// In en, this message translates to:
  /// **'Prioritized delivery for your urgent needs.'**
  String get prioritizedDeliveryForYourUrgentNeeds;

  /// No description provided for @regularDelivery.
  ///
  /// In en, this message translates to:
  /// **'Regular Delivery'**
  String get regularDelivery;

  /// No description provided for @standardDeliveryWithNoExtraCharges.
  ///
  /// In en, this message translates to:
  /// **'Standard delivery with no extra charges.'**
  String get standardDeliveryWithNoExtraCharges;

  /// No description provided for @deliverTo.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get deliverTo;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @appUnderMaintenance.
  ///
  /// In en, this message translates to:
  /// **'App Under Maintenance'**
  String get appUnderMaintenance;

  /// No description provided for @noOrderFound.
  ///
  /// In en, this message translates to:
  /// **'No Order Found'**
  String get noOrderFound;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No Search Results'**
  String get noSearchResults;

  /// No description provided for @microphoneUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission or speech service unavailable'**
  String get microphoneUnavailable;

  /// No description provided for @speakNow.
  ///
  /// In en, this message translates to:
  /// **'Speak Now'**
  String get speakNow;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @noSpeechDetected.
  ///
  /// In en, this message translates to:
  /// **'No speech detected'**
  String get noSpeechDetected;

  /// No description provided for @locationServices.
  ///
  /// In en, this message translates to:
  /// **'Location Services'**
  String get locationServices;

  /// No description provided for @appPermission.
  ///
  /// In en, this message translates to:
  /// **'App Permission'**
  String get appPermission;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with apple'**
  String get continueWithApple;

  /// No description provided for @reviewsRatings.
  ///
  /// In en, this message translates to:
  /// **'Reviews & Ratings'**
  String get reviewsRatings;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @dialog.
  ///
  /// In en, this message translates to:
  /// **'Dialog'**
  String get dialog;

  /// No description provided for @looksLikeTheStoreCatchingSomeRest.
  ///
  /// In en, this message translates to:
  /// **'Looks like the store\'s catching some rest. Come back in a little while!'**
  String get looksLikeTheStoreCatchingSomeRest;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'Address Line 1'**
  String get addressLine1;

  /// No description provided for @addressLine2Optional.
  ///
  /// In en, this message translates to:
  /// **'Address Line 2 (Optional)'**
  String get addressLine2Optional;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @zipcode.
  ///
  /// In en, this message translates to:
  /// **'Zipcode'**
  String get zipcode;

  /// No description provided for @landmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark'**
  String get landmark;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @soldBy.
  ///
  /// In en, this message translates to:
  /// **'Sold by:'**
  String get soldBy;

  /// No description provided for @searchAnAreaOrAddress.
  ///
  /// In en, this message translates to:
  /// **'Search an area or address'**
  String get searchAnAreaOrAddress;

  /// No description provided for @describeTheIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get describeTheIssue;

  /// No description provided for @writeYourReviewHere.
  ///
  /// In en, this message translates to:
  /// **'Write your review here...'**
  String get writeYourReviewHere;

  /// No description provided for @typeYourQuestionHere.
  ///
  /// In en, this message translates to:
  /// **'Type your question here...'**
  String get typeYourQuestionHere;

  /// No description provided for @enterReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter review title'**
  String get enterReviewTitle;

  /// No description provided for @shareYourThoughts.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts...'**
  String get shareYourThoughts;

  /// No description provided for @searchForAreaStreetName.
  ///
  /// In en, this message translates to:
  /// **'Search for area, street name...'**
  String get searchForAreaStreetName;

  /// No description provided for @pleaseSelectADeliveryAddressFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a delivery address first'**
  String get pleaseSelectADeliveryAddressFirst;

  /// No description provided for @paymentMethodNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Payment method not selected'**
  String get paymentMethodNotSelected;

  /// No description provided for @inclusiveOfAllTax.
  ///
  /// In en, this message translates to:
  /// **'(inclusive of all tax)'**
  String get inclusiveOfAllTax;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @packOf.
  ///
  /// In en, this message translates to:
  /// **'Pack Of'**
  String get packOf;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @madeIn.
  ///
  /// In en, this message translates to:
  /// **'Made In'**
  String get madeIn;

  /// No description provided for @indicator.
  ///
  /// In en, this message translates to:
  /// **'Indicator'**
  String get indicator;

  /// No description provided for @guaranteePeriod.
  ///
  /// In en, this message translates to:
  /// **'Guarantee Period'**
  String get guaranteePeriod;

  /// No description provided for @warrantyPeriod.
  ///
  /// In en, this message translates to:
  /// **'Warranty Period'**
  String get warrantyPeriod;

  /// No description provided for @returnable.
  ///
  /// In en, this message translates to:
  /// **'Returnable'**
  String get returnable;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get noDescriptionAvailable;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @stores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get stores;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// No description provided for @promoApplied.
  ///
  /// In en, this message translates to:
  /// **'Promo Applied'**
  String get promoApplied;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get on;

  /// No description provided for @rushDeliveryActive.
  ///
  /// In en, this message translates to:
  /// **'Rush Delivery Active'**
  String get rushDeliveryActive;

  /// No description provided for @cashbackApplied.
  ///
  /// In en, this message translates to:
  /// **'Cashback Applied'**
  String get cashbackApplied;

  /// No description provided for @instantDiscountApplied.
  ///
  /// In en, this message translates to:
  /// **'Instant Discount Applied'**
  String get instantDiscountApplied;

  /// No description provided for @willBeAdded.
  ///
  /// In en, this message translates to:
  /// **'Will be added'**
  String get willBeAdded;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @clearCartConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to clear the cart?'**
  String get clearCartConfirm;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yesClear.
  ///
  /// In en, this message translates to:
  /// **'Yes, clear'**
  String get yesClear;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmation;

  /// No description provided for @maxCartItemLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You have reached maximum cart item limit'**
  String get maxCartItemLimitReached;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @shopByCategories.
  ///
  /// In en, this message translates to:
  /// **'Shop By Categories'**
  String get shopByCategories;

  /// No description provided for @topBrands.
  ///
  /// In en, this message translates to:
  /// **'Top Brands'**
  String get topBrands;

  /// No description provided for @addItemsToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Add items to get started'**
  String get addItemsToGetStarted;

  /// No description provided for @yourShoppingListIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your shopping list is empty'**
  String get yourShoppingListIsEmpty;

  /// No description provided for @listItem.
  ///
  /// In en, this message translates to:
  /// **'List item'**
  String get listItem;

  /// No description provided for @itemsAdded.
  ///
  /// In en, this message translates to:
  /// **'items added'**
  String get itemsAdded;

  /// No description provided for @startShopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get startShopping;

  /// No description provided for @typeItemName.
  ///
  /// In en, this message translates to:
  /// **'Type item name...'**
  String get typeItemName;

  /// No description provided for @pleaseAdd1ItemInShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Please add at least 1 item in your shopping list'**
  String get pleaseAdd1ItemInShoppingList;

  /// No description provided for @selectDeliveryLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Location'**
  String get selectDeliveryLocation;

  /// No description provided for @searchForAreaStreet.
  ///
  /// In en, this message translates to:
  /// **'Search for area, street name...'**
  String get searchForAreaStreet;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get useCurrentLocation;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @savedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get savedAddresses;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not Logged In'**
  String get notLoggedIn;

  /// No description provided for @pleaseLoginToViewYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your profile'**
  String get pleaseLoginToViewYourProfile;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// No description provided for @trackYourDelivery.
  ///
  /// In en, this message translates to:
  /// **'Track your Delivery'**
  String get trackYourDelivery;

  /// No description provided for @returnItem.
  ///
  /// In en, this message translates to:
  /// **'Return Item'**
  String get returnItem;

  /// No description provided for @failedToLoadTrackingData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tracking data'**
  String get failedToLoadTrackingData;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @onTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get onTheWay;

  /// No description provided for @trackingLiveLocation.
  ///
  /// In en, this message translates to:
  /// **'Tracking live location'**
  String get trackingLiveLocation;

  /// No description provided for @arrivingIn.
  ///
  /// In en, this message translates to:
  /// **'Arriving in'**
  String get arrivingIn;

  /// No description provided for @mins.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get mins;

  /// No description provided for @deliveryPartner.
  ///
  /// In en, this message translates to:
  /// **'Delivery Partner'**
  String get deliveryPartner;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderId;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @orderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get orderPlaced;

  /// No description provided for @deliveryDetails.
  ///
  /// In en, this message translates to:
  /// **'Delivery details'**
  String get deliveryDetails;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'{label} copied to clipboard'**
  String copiedToClipboard(String label);

  /// No description provided for @orderIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Order ID copied!'**
  String get orderIdCopied;

  /// No description provided for @reasonForReturn.
  ///
  /// In en, this message translates to:
  /// **'Reason for return'**
  String get reasonForReturn;

  /// No description provided for @submitReturn.
  ///
  /// In en, this message translates to:
  /// **'Submit Return'**
  String get submitReturn;

  /// No description provided for @thisProductIsNotCancelable.
  ///
  /// In en, this message translates to:
  /// **'This product is not cancelable'**
  String get thisProductIsNotCancelable;

  /// No description provided for @thisProductIsNotReturnable.
  ///
  /// In en, this message translates to:
  /// **'This product is not returnable'**
  String get thisProductIsNotReturnable;

  /// No description provided for @returnButton.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnButton;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @moveToEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Move to…'**
  String get moveToEllipsis;

  /// No description provided for @addToEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Add to…'**
  String get addToEllipsis;

  /// No description provided for @locationAccessNeeded.
  ///
  /// In en, this message translates to:
  /// **'Location Access Needed'**
  String get locationAccessNeeded;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @appPermissions.
  ///
  /// In en, this message translates to:
  /// **'App Permissions'**
  String get appPermissions;

  /// No description provided for @checkingEmail.
  ///
  /// In en, this message translates to:
  /// **'Checking email...'**
  String get checkingEmail;

  /// No description provided for @searchInStoreName.
  ///
  /// In en, this message translates to:
  /// **'Search in {storeName}'**
  String searchInStoreName(String storeName);

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @greatService.
  ///
  /// In en, this message translates to:
  /// **'e.g., Great service!'**
  String get greatService;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @emailOrPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone Number'**
  String get emailOrPhoneNumber;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @uploadImages.
  ///
  /// In en, this message translates to:
  /// **'Upload images'**
  String get uploadImages;

  /// No description provided for @tapToUploadPhotos.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload photos'**
  String get tapToUploadPhotos;

  /// No description provided for @helpUsUnderstandYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Help us understand your experience'**
  String get helpUsUnderstandYourExperience;

  /// No description provided for @youCanUploadUpToMaxImages.
  ///
  /// In en, this message translates to:
  /// **'You can upload up to {max} images only.'**
  String youCanUploadUpToMaxImages(int max);

  /// No description provided for @onlyRemainingMoreImagesAdded.
  ///
  /// In en, this message translates to:
  /// **'Only {remaining} more image(s) added. Max limit: {max}.'**
  String onlyRemainingMoreImagesAdded(int remaining, int max);

  /// No description provided for @maxImagesAllowedExtensions.
  ///
  /// In en, this message translates to:
  /// **'• Max {max} images • {extensions} • {size} per image'**
  String maxImagesAllowedExtensions(int max, String extensions, String size);

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get clearCart;

  /// No description provided for @clearAllItems.
  ///
  /// In en, this message translates to:
  /// **'Clear all items?'**
  String get clearAllItems;

  /// No description provided for @allItemsWillBeRemovedCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'All items will be removed and this action cannot be undone'**
  String get allItemsWillBeRemovedCannotBeUndone;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment successful!'**
  String get paymentSuccessful;

  /// No description provided for @paymentFailedOrCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment failed or cancelled'**
  String get paymentFailedOrCancelled;

  /// No description provided for @failedToDeleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete address'**
  String get failedToDeleteAddress;

  /// No description provided for @pressAgainToExitTheApp.
  ///
  /// In en, this message translates to:
  /// **'Press again to exit the app'**
  String get pressAgainToExitTheApp;

  /// No description provided for @youHaveReachedMaximumLimitOfCart.
  ///
  /// In en, this message translates to:
  /// **'You have reached maximum limit of the cart'**
  String get youHaveReachedMaximumLimitOfCart;

  /// No description provided for @sellerInformationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Seller information not available'**
  String get sellerInformationNotAvailable;

  /// No description provided for @failedToRefreshOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to refresh order details'**
  String get failedToRefreshOrderDetails;

  /// No description provided for @productSavedForLater.
  ///
  /// In en, this message translates to:
  /// **'{productName} is saved for later'**
  String productSavedForLater(String productName);

  /// No description provided for @promoCodeAppliedOnYourCart.
  ///
  /// In en, this message translates to:
  /// **'Promo code applied on your cart'**
  String get promoCodeAppliedOnYourCart;

  /// No description provided for @youHaveCrossedMaximumCartAmountLimit.
  ///
  /// In en, this message translates to:
  /// **'You have crossed maximum cart amount limit. Please remove some products from cart'**
  String get youHaveCrossedMaximumCartAmountLimit;

  /// No description provided for @feedbackSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully!'**
  String get feedbackSubmittedSuccessfully;

  /// No description provided for @feedbackUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Feedback updated successfully!'**
  String get feedbackUpdatedSuccessfully;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailed;

  /// No description provided for @copiedToClipboardWithLabel.
  ///
  /// In en, this message translates to:
  /// **'{label} copied to clipboard!'**
  String copiedToClipboardWithLabel(String label);

  /// No description provided for @pleaseEnterCompleteOTP.
  ///
  /// In en, this message translates to:
  /// **'Please enter complete OTP'**
  String get pleaseEnterCompleteOTP;

  /// No description provided for @verificationIdNotFound.
  ///
  /// In en, this message translates to:
  /// **'Verification ID not found. Please try again.'**
  String get verificationIdNotFound;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to {phoneNumber}'**
  String otpSentTo(String phoneNumber);

  /// No description provided for @registrationDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Registration data not found. Please try again.'**
  String get registrationDataNotFound;

  /// No description provided for @noAccountFoundWithEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email or phone'**
  String get noAccountFoundWithEmailOrPhone;

  /// No description provided for @pleaseEnterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Email already registered. Please use a different email.'**
  String get emailAlreadyRegistered;

  /// No description provided for @pleaseEnterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterYourFullName;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @pleaseEnterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhoneNumber;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// No description provided for @passwordMustBeAtLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMustBeAtLeast8Characters;

  /// No description provided for @pleaseConfirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmYourPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @otpVerified.
  ///
  /// In en, this message translates to:
  /// **'OTP Verified'**
  String get otpVerified;

  /// No description provided for @pleaseSelectAPaymentMethodFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method first'**
  String get pleaseSelectAPaymentMethodFirst;

  /// No description provided for @fetchingAddress.
  ///
  /// In en, this message translates to:
  /// **'Fetching address...'**
  String get fetchingAddress;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected location'**
  String get selectedLocation;

  /// No description provided for @gettingAddress.
  ///
  /// In en, this message translates to:
  /// **'Getting address...'**
  String get gettingAddress;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown location'**
  String get unknownLocation;

  /// No description provided for @deliveryNotAvailableAtThisLocation.
  ///
  /// In en, this message translates to:
  /// **'Delivery not available at this location'**
  String get deliveryNotAvailableAtThisLocation;

  /// No description provided for @sorryWeDontDeliverHereYet.
  ///
  /// In en, this message translates to:
  /// **'Sorry! We don\'t deliver here yet'**
  String get sorryWeDontDeliverHereYet;

  /// No description provided for @thisLocationIsOutsideOurDeliveryZone.
  ///
  /// In en, this message translates to:
  /// **'This location is currently outside our delivery zone. Try searching for a nearby area or check back later.'**
  String get thisLocationIsOutsideOurDeliveryZone;

  /// No description provided for @addressDetails.
  ///
  /// In en, this message translates to:
  /// **'Address Details'**
  String get addressDetails;

  /// No description provided for @pleaseEnterAddressLine1.
  ///
  /// In en, this message translates to:
  /// **'Please enter Address Line 1'**
  String get pleaseEnterAddressLine1;

  /// No description provided for @pleaseEnterCountry.
  ///
  /// In en, this message translates to:
  /// **'Please enter Country'**
  String get pleaseEnterCountry;

  /// No description provided for @pleaseEnterState.
  ///
  /// In en, this message translates to:
  /// **'Please enter State'**
  String get pleaseEnterState;

  /// No description provided for @pleaseEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter City'**
  String get pleaseEnterCity;

  /// No description provided for @pleaseEnterZipcode.
  ///
  /// In en, this message translates to:
  /// **'Please enter Zipcode'**
  String get pleaseEnterZipcode;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @pleaseEnterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get pleaseEnterMobileNumber;

  /// No description provided for @saveAddressAs.
  ///
  /// In en, this message translates to:
  /// **'Save address as'**
  String get saveAddressAs;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @enterCompleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Complete Address'**
  String get enterCompleteAddress;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @checkingDelivery.
  ///
  /// In en, this message translates to:
  /// **'Checking delivery...'**
  String get checkingDelivery;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @confirmAddressToProceed.
  ///
  /// In en, this message translates to:
  /// **'Confirm Address to Proceed'**
  String get confirmAddressToProceed;

  /// No description provided for @addAddressToProceed.
  ///
  /// In en, this message translates to:
  /// **'Add Address to Proceed'**
  String get addAddressToProceed;

  /// No description provided for @deliveryNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Delivery Not Available'**
  String get deliveryNotAvailable;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account to continue'**
  String get signInToYourAccount;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAnAccount;

  /// No description provided for @emailVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully'**
  String get emailVerifiedSuccessfully;

  /// No description provided for @phoneNumberVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified successfully'**
  String get phoneNumberVerifiedSuccessfully;

  /// No description provided for @thisEmailIsNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is not registered. Please sign up first.'**
  String get thisEmailIsNotRegistered;

  /// No description provided for @thisPhoneNumberIsNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This phone number is not registered. Please sign up first.'**
  String get thisPhoneNumberIsNotRegistered;

  /// No description provided for @unableToVerifyUser.
  ///
  /// In en, this message translates to:
  /// **'Unable to verify user. Please try again.'**
  String get unableToVerifyUser;

  /// No description provided for @emailOrPhoneNumberIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number is required'**
  String get emailOrPhoneNumberIsRequired;

  /// No description provided for @enterValidEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter valid email or phone'**
  String get enterValidEmailOrPhone;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @passwordMustBeAtLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @emailAlreadyRegisteredUseDifferent.
  ///
  /// In en, this message translates to:
  /// **'Email already registered. Please use a different email.'**
  String get emailAlreadyRegisteredUseDifferent;

  /// No description provided for @changeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get changeLocation;

  /// No description provided for @chooseAddressForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Choose address for delivery'**
  String get chooseAddressForDelivery;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @tapCoinToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Tap coin to refresh'**
  String get tapCoinToRefresh;

  /// No description provided for @viewTransactions.
  ///
  /// In en, this message translates to:
  /// **'View Transactions'**
  String get viewTransactions;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @pleaseFillDetailsCreateYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the details to create your account'**
  String get pleaseFillDetailsCreateYourAccount;

  /// No description provided for @emailAvailable.
  ///
  /// In en, this message translates to:
  /// **'Email available'**
  String get emailAvailable;

  /// No description provided for @errorVerifyingEmail.
  ///
  /// In en, this message translates to:
  /// **'Error verifying email'**
  String get errorVerifyingEmail;

  /// No description provided for @pleaseAddYourDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Please add your delivery address'**
  String get pleaseAddYourDeliveryAddress;

  /// No description provided for @areYouSureDeleteFeedback.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete feedback'**
  String get areYouSureDeleteFeedback;

  /// No description provided for @addTo.
  ///
  /// In en, this message translates to:
  /// **'Add to…'**
  String get addTo;

  /// No description provided for @moveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to…'**
  String get moveTo;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @rewardPoints.
  ///
  /// In en, this message translates to:
  /// **'Reward Points'**
  String get rewardPoints;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get referralCode;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @pleaseCheckConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again'**
  String get pleaseCheckConnection;

  /// No description provided for @noProfileDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No profile data available'**
  String get noProfileDataAvailable;

  /// No description provided for @giveYourDeliveryHeroFeedback.
  ///
  /// In en, this message translates to:
  /// **'Give your delivery hero a feedback!'**
  String get giveYourDeliveryHeroFeedback;

  /// No description provided for @editYourFeedbackFor.
  ///
  /// In en, this message translates to:
  /// **'Edit your feedback for {name}'**
  String editYourFeedbackFor(String name);

  /// No description provided for @leaveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Leave Feedback'**
  String get leaveFeedback;

  /// No description provided for @editFeedback.
  ///
  /// In en, this message translates to:
  /// **'Edit Feedback'**
  String get editFeedback;

  /// No description provided for @editSellerFeedback.
  ///
  /// In en, this message translates to:
  /// **'Edit Seller Feedback'**
  String get editSellerFeedback;

  /// No description provided for @leaveSellerFeedback.
  ///
  /// In en, this message translates to:
  /// **'Leave Seller Feedback'**
  String get leaveSellerFeedback;

  /// No description provided for @productNotApprovedBySeller.
  ///
  /// In en, this message translates to:
  /// **'This product is not approved by seller'**
  String get productNotApprovedBySeller;

  /// No description provided for @leaveItemFeedback.
  ///
  /// In en, this message translates to:
  /// **'Leave Item Feedback'**
  String get leaveItemFeedback;

  /// No description provided for @cashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash On Delivery'**
  String get cashOnDelivery;

  /// No description provided for @paidOnline.
  ///
  /// In en, this message translates to:
  /// **'Paid Online'**
  String get paidOnline;

  /// No description provided for @orderPlacedOn.
  ///
  /// In en, this message translates to:
  /// **'Order placed on {date}'**
  String orderPlacedOn(String date);

  /// No description provided for @locationAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'This app provides hyper-local services. Please enable location to get personalized recommendations and accurate results.'**
  String get locationAccessDescription;

  /// No description provided for @turnOnLocationServicesDescription.
  ///
  /// In en, this message translates to:
  /// **'Turn on Location Services and grant app location permission to continue.'**
  String get turnOnLocationServicesDescription;

  /// No description provided for @loadingPaymentPage.
  ///
  /// In en, this message translates to:
  /// **'Loading payment page...'**
  String get loadingPaymentPage;

  /// No description provided for @youCanUploadUpToImagesOnly.
  ///
  /// In en, this message translates to:
  /// **'You can upload up to {count} images only.'**
  String youCanUploadUpToImagesOnly(int count);

  /// No description provided for @onlyMoreImagesAddedMaxLimit.
  ///
  /// In en, this message translates to:
  /// **'Only {remaining} more image(s) added. Max limit: {max}.'**
  String onlyMoreImagesAddedMaxLimit(int remaining, int max);

  /// No description provided for @onlinePaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Online Payment Methods'**
  String get onlinePaymentMethods;

  /// No description provided for @noCategoryFound.
  ///
  /// In en, this message translates to:
  /// **'No Category Found'**
  String get noCategoryFound;

  /// No description provided for @noStoreFound.
  ///
  /// In en, this message translates to:
  /// **'No Store Found'**
  String get noStoreFound;

  /// No description provided for @wereNotHereYet.
  ///
  /// In en, this message translates to:
  /// **'We’re not here yet'**
  String get wereNotHereYet;

  /// No description provided for @weCouldntFindAnyCategories.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any categories.'**
  String get weCouldntFindAnyCategories;

  /// No description provided for @weCouldntFindAnyStoreInYourSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any store in your select location.'**
  String get weCouldntFindAnyStoreInYourSelectLocation;

  /// No description provided for @phoneNumberCopied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied to clipboard!'**
  String get phoneNumberCopied;

  /// No description provided for @emailCopied.
  ///
  /// In en, this message translates to:
  /// **'Email copied to clipboard!'**
  String get emailCopied;

  /// No description provided for @pleaseWaitBeforeResending.
  ///
  /// In en, this message translates to:
  /// **'Please wait before resending.'**
  String get pleaseWaitBeforeResending;

  /// No description provided for @toPay.
  ///
  /// In en, this message translates to:
  /// **'To Pay:'**
  String get toPay;

  /// No description provided for @currentlyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Currently unavailable'**
  String get currentlyUnavailable;

  /// No description provided for @noStoresOrProductsAreAvailableInThisAreaRightNow.
  ///
  /// In en, this message translates to:
  /// **'No stores or products are available in this area right now.'**
  String get noStoresOrProductsAreAvailableInThisAreaRightNow;

  /// No description provided for @checkConnectionAndTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get checkConnectionAndTryAgain;

  /// No description provided for @weWillBeBackSoon.
  ///
  /// In en, this message translates to:
  /// **'We\'ll be back soon. Hang tight!'**
  String get weWillBeBackSoon;

  /// No description provided for @noOrdersYetDescription.
  ///
  /// In en, this message translates to:
  /// **'It looks like you don\'t have any orders yet.'**
  String get noOrdersYetDescription;

  /// No description provided for @tryAdjustingSearchTerms.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms.'**
  String get tryAdjustingSearchTerms;

  /// No description provided for @noProductMatchingSearch.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any products matching your search.'**
  String get noProductMatchingSearch;

  /// No description provided for @feedbackDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Review deleted successfully!'**
  String get feedbackDeletedSuccessfully;

  /// No description provided for @rateDeliveryHero.
  ///
  /// In en, this message translates to:
  /// **'Rate Delivery Hero'**
  String get rateDeliveryHero;

  /// No description provided for @howWasTheDelivery.
  ///
  /// In en, this message translates to:
  /// **'How was the delivery?'**
  String get howWasTheDelivery;

  /// No description provided for @egSuperFastDelivery.
  ///
  /// In en, this message translates to:
  /// **'e.g., Super fast delivery!'**
  String get egSuperFastDelivery;

  /// No description provided for @youMightAlsoLike.
  ///
  /// In en, this message translates to:
  /// **'You might also like'**
  String get youMightAlsoLike;

  /// No description provided for @storeCurrentlyClosed.
  ///
  /// In en, this message translates to:
  /// **'Store is currently closed'**
  String get storeCurrentlyClosed;

  /// No description provided for @minimumQuantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Minimum quantity is {minQty}'**
  String minimumQuantityRequired(Object minQty);

  /// No description provided for @maximumQuantityAllowed.
  ///
  /// In en, this message translates to:
  /// **'Maximum {maxQty} items allowed'**
  String maximumQuantityAllowed(Object maxQty);

  /// No description provided for @onlyXItemsInStock.
  ///
  /// In en, this message translates to:
  /// **'Only {stock} items available in stock'**
  String onlyXItemsInStock(Object stock);

  /// No description provided for @minimumCartAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Add {minAmount} more to reach the {miniCheckoutAmount} minimum checkout.'**
  String minimumCartAmountRequired(Object minAmount, Object miniCheckoutAmount);

  /// No description provided for @youHaveReachedMaximumLimitOfTheCart.
  ///
  /// In en, this message translates to:
  /// **'Maximum items limit reached'**
  String get youHaveReachedMaximumLimitOfTheCart;

  /// No description provided for @onlyOneStoreAtATime.
  ///
  /// In en, this message translates to:
  /// **'You can only order from one store at a time'**
  String get onlyOneStoreAtATime;

  /// No description provided for @onlyFewLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {stock} left!'**
  String onlyFewLeft(Object stock);

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get inStock;

  /// No description provided for @noTransactionYet.
  ///
  /// In en, this message translates to:
  /// **'No Transaction Yet'**
  String get noTransactionYet;

  /// No description provided for @noTransactionDescriptionMsg.
  ///
  /// In en, this message translates to:
  /// **'Your wallet activity will appear here once'**
  String get noTransactionDescriptionMsg;

  /// No description provided for @noTransactionDescriptionSecondaryMsg.
  ///
  /// In en, this message translates to:
  /// **'you make your first transaction.'**
  String get noTransactionDescriptionSecondaryMsg;

  /// Shown when user tries to add items beyond cart limit
  ///
  /// In en, this message translates to:
  /// **'You can add only {remaining} more item(s) to your cart.'**
  String cannotAddMoreThanXItems(Object remaining);

  /// Simpler version of max items warning
  ///
  /// In en, this message translates to:
  /// **'You can add only {count} more item(s).'**
  String youCanAddOnlyXMoreItems(Object count);

  /// No description provided for @cartIsAlreadyAtMaximumLimit.
  ///
  /// In en, this message translates to:
  /// **'Your cart has reached the maximum item limit ({maxAllowed}).'**
  String cartIsAlreadyAtMaximumLimit(Object maxAllowed);

  /// No description provided for @cannotAddFromDifferentStore.
  ///
  /// In en, this message translates to:
  /// **'You can only add items from the same store. Please clear your cart or choose items from this store.'**
  String get cannotAddFromDifferentStore;

  /// No description provided for @cartAlreadyContainsMultipleStores.
  ///
  /// In en, this message translates to:
  /// **'Your cart already contains items from multiple stores. Please complete the current order or clear the cart first.'**
  String get cartAlreadyContainsMultipleStores;

  /// No description provided for @inCart.
  ///
  /// In en, this message translates to:
  /// **'in cart'**
  String get inCart;

  /// No description provided for @thisActionIsPermanent.
  ///
  /// In en, this message translates to:
  /// **'This action is PERMANENT.'**
  String get thisActionIsPermanent;

  /// No description provided for @allYourDataWillBeLostForever.
  ///
  /// In en, this message translates to:
  /// **'All your data will be lost forever.'**
  String get allYourDataWillBeLostForever;

  /// No description provided for @addYourFirstAddressToStart.
  ///
  /// In en, this message translates to:
  /// **'Add your first address to get started'**
  String get addYourFirstAddressToStart;

  /// No description provided for @noAddressFound.
  ///
  /// In en, this message translates to:
  /// **'No Address Found'**
  String get noAddressFound;

  /// No description provided for @includingAllTax.
  ///
  /// In en, this message translates to:
  /// **'(inclusive of all tax)'**
  String get includingAllTax;

  /// No description provided for @dataPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'data'**
  String get dataPlaceholder;

  /// No description provided for @writeYourNoteHere.
  ///
  /// In en, this message translates to:
  /// **'Write your note here...'**
  String get writeYourNoteHere;

  /// No description provided for @clearingYourCart.
  ///
  /// In en, this message translates to:
  /// **'Clearing your cart...'**
  String get clearingYourCart;

  /// No description provided for @imagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get imagesLabel;

  /// No description provided for @imagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG (Max 5MB)'**
  String get imagesSubtitle;

  /// No description provided for @pdfDocumentLabel.
  ///
  /// In en, this message translates to:
  /// **'PDF Document'**
  String get pdfDocumentLabel;

  /// No description provided for @pdfDocumentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'PDF files (Max 10MB)'**
  String get pdfDocumentSubtitle;

  /// No description provided for @wordDocumentLabel.
  ///
  /// In en, this message translates to:
  /// **'Word Document'**
  String get wordDocumentLabel;

  /// No description provided for @wordDocumentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'DOCX files (Max 10MB)'**
  String get wordDocumentSubtitle;

  /// No description provided for @cannotOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Cannot open file: {url}'**
  String cannotOpenFile(String url);

  /// No description provided for @errorOpeningAttachment.
  ///
  /// In en, this message translates to:
  /// **'Error opening attachment: {error}'**
  String errorOpeningAttachment(String error);

  /// No description provided for @paystackPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Paystack Payment'**
  String get paystackPaymentTitle;

  /// No description provided for @enableLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get enableLocationTitle;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @youWillBeResponsible.
  ///
  /// In en, this message translates to:
  /// **'you will be responsible'**
  String get youWillBeResponsible;

  /// No description provided for @deleteWishlistConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this wishlist?'**
  String get deleteWishlistConfirmation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'en',
        'fr',
        'gu',
        'hi',
        'te'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
