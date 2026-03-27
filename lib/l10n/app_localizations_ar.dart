// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'هايبر لوكال';

  @override
  String get appName => 'هايبر لوكال';

  @override
  String get welcome => 'مرحباً';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'تسجيل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get home => 'الصفحة الرئيسية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get french => 'الفرنسية';

  @override
  String get hindi => 'الهندية';

  @override
  String get gujarati => 'الغوجاراتية';

  @override
  String get telugu => 'التيلجو';

  @override
  String get location => 'الموقع';

  @override
  String get selectLocation => 'اختر الموقع';

  @override
  String get currentLocation => 'الموقع الحالي';

  @override
  String get search => 'بحث';

  @override
  String get categories => 'الفئات';

  @override
  String get nearby => 'بالقرب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get ok => 'حسناً';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get networkError => 'خطأ في الشبكة';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get permissionDenied => 'تم رفض الإذن';

  @override
  String get locationPermissionRequired => 'يتطلب إذن الوصول إلى الموقع';

  @override
  String get enableLocation => 'يرجى تفعيل خدمات الموقع';

  @override
  String get appearance => 'المظهر';

  @override
  String get changeAppTheme => 'تغيير سمة التطبيق';

  @override
  String get systemMode => 'وضع النظام';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get apply => 'تطبيق';

  @override
  String get current => 'الحالي';

  @override
  String get cart => 'عربة التسوق';

  @override
  String get viewCouponOffers => 'عرض الكوبونات والعروض';

  @override
  String get placeOrder => 'إتمام الطلب';

  @override
  String get selectPaymentMethod => 'اختر طريقة الدفع';

  @override
  String get payUsing => 'الدفع باستخدام';

  @override
  String get yourCartIsEmpty => 'عربة التسوق فارغة';

  @override
  String get looksLikeYouHaventAddedAnythingYet => 'يبدو أنك لم تضف أي شيء بعد';

  @override
  String get browseProducts => 'تصفح المنتجات';

  @override
  String get addMoreItemsTapped => 'تم النقر لإضافة المزيد من العناصر!';

  @override
  String get removeItem => 'إزالة العنصر';

  @override
  String areYouSureYouWantToRemoveItemFromCart(String item) {
    return 'هل أنت متأكد أنك تريد إزالة $item من العربة؟';
  }

  @override
  String get delete => 'حذف';

  @override
  String get saveForLater => 'احفظه لوقت لاحق';

  @override
  String get billDetails => 'تفاصيل الفاتورة';

  @override
  String get itemsTotal => 'إجمالي العناصر';

  @override
  String get saved => 'تم الحفظ';

  @override
  String get deliveryCharge => 'رسوم التوصيل';

  @override
  String get free => 'مجاناً';

  @override
  String get perStoreDropOffFees => 'رسوم التسليم لكل متجر';

  @override
  String get handlingCharge => 'رسوم المناولة';

  @override
  String get promoCode => 'رمز العرض';

  @override
  String get promoDiscount => 'خصم العرض';

  @override
  String get removeCoupon => 'إزالة الكوبون';

  @override
  String get grandTotal => 'المجموع الكلي';

  @override
  String get yourTotalSavings => 'إجمالي التوفير الخاص بك';

  @override
  String get downloadInvoice => 'تحميل الفاتورة';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get noOrdersYet => 'لا توجد طلبات بعد';

  @override
  String get failedToLoadOrders => 'فشل تحميل الطلبات';

  @override
  String get rateOrder => 'تقييم الطلب';

  @override
  String get howWasYourOrder => 'كيف كان طلبك؟';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get orderDetailsRefreshed => 'تم تحديث تفاصيل الطلب';

  @override
  String get rateYourExperience => 'قيّم تجربتك';

  @override
  String get failedToLoadOrderDetails => 'فشل تحميل تفاصيل الطلب';

  @override
  String get noItemsToDisplay => 'لا توجد عناصر للعرض';

  @override
  String get deleteReview => 'حذف التقييم؟';

  @override
  String get thisActionCannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get edit => 'تعديل';

  @override
  String get cancelItem => 'إلغاء العنصر';

  @override
  String get areYouSureYouWantToCancelThisItem =>
      'هل أنت متأكد أنك تريد إلغاء هذا العنصر؟';

  @override
  String get cancelReturnRequest => 'إلغاء طلب الإرجاع';

  @override
  String get areYouSureYouWantToCancelThisReturnRequest =>
      'هل أنت متأكد أنك تريد إلغاء طلب الإرجاع هذا؟';

  @override
  String get cancelReturnRequestButton => 'إلغاء طلب الإرجاع';

  @override
  String get cancelItemButton => 'إلغاء العنصر';

  @override
  String get howWasYourShoppingExperience => 'كيف كانت تجربتك في التسوق؟';

  @override
  String get trackDelivery => 'تتبع التوصيل';

  @override
  String get myWishlist => 'قائمة رغباتي';

  @override
  String get createNewWishlist => 'إنشاء قائمة رغبات جديدة';

  @override
  String get createNewWishlistTitle => 'إنشاء قائمة رغبات جديدة';

  @override
  String get enterWishlistName => 'أدخل اسم قائمة الرغبات';

  @override
  String get pleaseEnterAWishlistName => 'يرجى إدخال اسم قائمة الرغبات';

  @override
  String get create => 'إنشاء';

  @override
  String get update => 'تحديث';

  @override
  String get editWishlist => 'تعديل قائمة الرغبات';

  @override
  String get noWishlistsYet => 'لا توجد قوائم رغبات بعد';

  @override
  String get noOtherWishlistsAvailable => 'لا توجد قوائم رغبات أخرى';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String deleteWishlistName(String wishlistName) {
    return 'حذف $wishlistName';
  }

  @override
  String get myAddresses => 'عناويني';

  @override
  String get addAddress => 'إضافة عنوان';

  @override
  String get deleteAddress => 'حذف العنوان';

  @override
  String get areYouSureYouWantToDeleteThisAddress =>
      'هل أنت متأكد أنك تريد حذف هذا العنوان؟';

  @override
  String get near => 'بالقرب من';

  @override
  String get noAddressSelected => 'لم يتم اختيار عنوان';

  @override
  String get pleaseSelectAnImageAndEnterYourName =>
      'يرجى اختيار صورة وإدخال اسمك';

  @override
  String get loadingProfile => 'جارٍ تحميل الملف الشخصي...';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String labelCopiedToClipboard(String label) {
    return 'تم نسخ $label إلى الحافظة';
  }

  @override
  String get yourDeliveryAddress => 'عنوان التوصيل الخاص بك';

  @override
  String get shoppingList => 'قائمة التسوق';

  @override
  String get aboutUs => 'معلومات عنا';

  @override
  String get termsCondition => 'الشروط والأحكام';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get refundPolicy => 'سياسة الاسترجاع';

  @override
  String get shippingPolicy => 'سياسة الشحن';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get pleaseEnterYourName => 'يرجى إدخال اسمك';

  @override
  String get nameMustBeAtLeast2Characters =>
      'يجب أن يكون الاسم مكوناً من حرفين على الأقل';

  @override
  String get productDetails => 'تفاصيل المنتج';

  @override
  String get description => 'الوصف';

  @override
  String get specification => 'المواصفات';

  @override
  String get reviews => 'المراجعات';

  @override
  String get similarProducts => 'منتجات مشابهة';

  @override
  String get specifications => 'المواصفات';

  @override
  String get customerReviews => 'تقييمات العملاء';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get addYourReview => 'أضف تقييمك';

  @override
  String get rateThisProduct => 'قيّم هذا المنتج';

  @override
  String get submitReview => 'إرسال التقييم';

  @override
  String get questionAndAnswers => 'الأسئلة والأجوبة';

  @override
  String get askAQuestion => 'اسأل سؤالاً';

  @override
  String get submit => 'إرسال';

  @override
  String get questionSubmittedSuccessfully => 'تم إرسال السؤال بنجاح!';

  @override
  String get pleaseSelectVariant => 'يرجى اختيار خيار';

  @override
  String get viewProductDetails => 'عرض تفاصيل المنتج';

  @override
  String get productAddedToCartSuccessfully =>
      'تمت إضافة المنتج إلى العربة بنجاح!';

  @override
  String failedToAddProduct(String error) {
    return 'فشل إضافة المنتج: $error';
  }

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String get productVariants => 'خيارات المنتج';

  @override
  String get selectVariant => 'اختر الخيار';

  @override
  String get add => 'إضافة';

  @override
  String get noProductFound => 'لم يتم العثور على منتج';

  @override
  String get filters => 'الفلاتر';

  @override
  String get sort => 'ترتيب';

  @override
  String get popularity => 'الأكثر شهرة';

  @override
  String searchResultFor(String title) {
    return 'نتائج البحث عن \"$title\"';
  }

  @override
  String get relevanceDefault => 'الصلة (افتراضي)';

  @override
  String get priceLowToHigh => 'السعر (من الأقل للأعلى)';

  @override
  String get priceHighToLow => 'السعر (من الأعلى للأقل)';

  @override
  String get discountHighToLow => 'الخصم (من الأعلى للأقل)';

  @override
  String get items => 'عناصر';

  @override
  String get startTypingForSuggestions => 'ابدأ بالكتابة للحصول على اقتراحات';

  @override
  String get noSuggestionsFound => 'لم يتم العثور على اقتراحات';

  @override
  String get speak => 'تحدث';

  @override
  String get trySayingSomething => 'حاول قول شيء';

  @override
  String get speechStoppedTryAgain => 'توقف الصوت. حاول مرة أخرى.';

  @override
  String get close => 'إغلاق';

  @override
  String get searchProducts => 'ابحث عن المنتجات...';

  @override
  String get searchForProducts => 'ابحث عن المنتجات';

  @override
  String get typeProductNameBrandOrCategory =>
      'اكتب اسم المنتج أو العلامة التجارية أو الفئة';

  @override
  String get searching => 'جارٍ البحث...';

  @override
  String get trySearchingWithDifferentKeywords =>
      'حاول البحث باستخدام كلمات مختلفة';

  @override
  String get nearbyStores => 'المتاجر القريبة';

  @override
  String get noStoresFoundNearby => 'لم يتم العثور على متاجر قريبة.';

  @override
  String searchInStore(String storeName) {
    return 'البحث في $storeName';
  }

  @override
  String get savedForLater => 'محفوظ لوقت لاحق';

  @override
  String get moveToCart => 'انقل إلى العربة';

  @override
  String get addFirstItem => 'أضف العنصر الأول';

  @override
  String resultFor(String title) {
    return 'النتائج لـ \"$title\"';
  }

  @override
  String get addMoney => 'إضافة رصيد';

  @override
  String get enterAmount => 'أدخل المبلغ';

  @override
  String get note => 'ملاحظة:';

  @override
  String get hyperlocalWalletBalanceValidFor1Year =>
      'رصيد محفظة هايبر لوكال صالح لمدة سنة من تاريخ الإضافة';

  @override
  String get hyperlocalWalletBalanceCannotBeTransferred =>
      'لا يمكن تحويل رصيد المحفظة إلى حساب بنكي وفقاً لتعليمات RBI';

  @override
  String get pleaseEnterAnAmountGreaterThanOrEqualTo1 =>
      'يرجى إدخال مبلغ أكبر من أو يساوي 1';

  @override
  String get transactions => 'المعاملات';

  @override
  String get promoCodeCoupons => 'رموز العرض والكوبونات';

  @override
  String get support => 'الدعم';

  @override
  String get callUs => 'اتصل بنا';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get emailUs => 'راسلنا عبر البريد';

  @override
  String get tapToContact => 'اضغط للاتصال';

  @override
  String rateStoreName(String storeName) {
    return 'قيّم $storeName';
  }

  @override
  String get editYourFeedback => 'تعديل ملاحظاتك';

  @override
  String get howWasYourExperience => 'كيف كانت تجربتك؟';

  @override
  String get tapToRate => 'اضغط للتقييم';

  @override
  String star(int rating) {
    return '$rating نجمة';
  }

  @override
  String stars(int rating) {
    return '$rating نجوم';
  }

  @override
  String get titleRequired => 'العنوان *';

  @override
  String get egGreatService => 'مثال: خدمة رائعة!';

  @override
  String get descriptionRequired => 'الوصف *';

  @override
  String get shareMoreDetails => 'شارك المزيد من التفاصيل...';

  @override
  String get submitFeedback => 'إرسال الملاحظات';

  @override
  String get updateFeedback => 'تحديث الملاحظات';

  @override
  String get updating => 'جارٍ التحديث...';

  @override
  String get submitting => 'جارٍ الإرسال...';

  @override
  String get deleteFeedback => 'حذف الملاحظات';

  @override
  String get areYouSureYouWantToDeleteThisFeedback =>
      'هل تريد حذف هذه الملاحظات؟';

  @override
  String get pleaseGiveARating => 'يرجى إعطاء تقييم';

  @override
  String get pleaseEnterATitle => 'يرجى إدخال عنوان';

  @override
  String get pleaseEnterADescription => 'يرجى إدخال وصف';

  @override
  String get deliveryType => 'نوع التوصيل';

  @override
  String get rushDelivery => 'توصيل سريع';

  @override
  String get prioritizedDeliveryForYourUrgentNeeds =>
      'توصيل ذو أولوية لاحتياجاتك العاجلة.';

  @override
  String get regularDelivery => 'توصيل عادي';

  @override
  String get standardDeliveryWithNoExtraCharges =>
      'توصيل قياسي بدون رسوم إضافية.';

  @override
  String get deliverTo => 'التوصيل إلى';

  @override
  String get change => 'تغيير';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get appUnderMaintenance => 'التطبيق تحت الصيانة';

  @override
  String get noOrderFound => 'لم يتم العثور على طلب';

  @override
  String get noSearchResults => 'لا توجد نتائج بحث';

  @override
  String get microphoneUnavailable => 'إذن الميكروفون أو خدمة الصوت غير متوفرة';

  @override
  String get speakNow => 'تحدث الآن';

  @override
  String get listening => 'جارٍ الاستماع...';

  @override
  String get noSpeechDetected => 'لم يتم اكتشاف صوت';

  @override
  String get locationServices => 'خدمات الموقع';

  @override
  String get appPermission => 'إذن التطبيق';

  @override
  String get continueWithGoogle => 'تابع باستخدام جوجل';

  @override
  String get continueWithApple => 'تابع باستخدام آبل';

  @override
  String get reviewsRatings => 'المراجعات والتقييمات';

  @override
  String get frequentlyAskedQuestions => 'الأسئلة الشائعة';

  @override
  String get dialog => 'مربع الحوار';

  @override
  String get looksLikeTheStoreCatchingSomeRest =>
      'يبدو أن المتجر يأخذ قسطًا من الراحة. عد بعد قليل!';

  @override
  String get addressLine1 => 'سطر العنوان 1';

  @override
  String get addressLine2Optional => 'سطر العنوان 2 (اختياري)';

  @override
  String get country => 'البلد';

  @override
  String get state => 'الولاية';

  @override
  String get city => 'المدينة';

  @override
  String get zipcode => 'الرمز البريدي';

  @override
  String get landmark => 'معلم بارز';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get soldBy => 'مباع من:';

  @override
  String get searchAnAreaOrAddress => 'ابحث عن منطقة أو عنوان';

  @override
  String get describeTheIssue => 'صف المشكلة';

  @override
  String get writeYourReviewHere => 'اكتب تقييمك هنا...';

  @override
  String get typeYourQuestionHere => 'اكتب سؤالك هنا...';

  @override
  String get enterReviewTitle => 'أدخل عنوان التقييم';

  @override
  String get shareYourThoughts => 'شارك أفكارك...';

  @override
  String get searchForAreaStreetName => 'ابحث عن منطقة أو اسم شارع...';

  @override
  String get pleaseSelectADeliveryAddressFirst =>
      'يرجى اختيار عنوان التوصيل أولاً';

  @override
  String get paymentMethodNotSelected => 'لم يتم اختيار طريقة الدفع';

  @override
  String get inclusiveOfAllTax => '(شامل جميع الضرائب)';

  @override
  String get brand => 'العلامة التجارية';

  @override
  String get packOf => 'عبوة من';

  @override
  String get category => 'الفئة';

  @override
  String get madeIn => 'صنع في';

  @override
  String get indicator => 'المؤشر';

  @override
  String get guaranteePeriod => 'مدة الضمان';

  @override
  String get warrantyPeriod => 'مدة الكفالة';

  @override
  String get returnable => 'قابل للإرجاع';

  @override
  String get na => 'غير متوفر';

  @override
  String get yes => 'نعم';

  @override
  String get noDescriptionAvailable => 'لا يوجد وصف متاح.';

  @override
  String get wallet => 'المحفظة';

  @override
  String get wishlist => 'قائمة الرغبات';

  @override
  String get stores => 'المتاجر';

  @override
  String get account => 'الحساب';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get currentLanguage => 'اللغة الحالية';

  @override
  String get promoApplied => 'تم تطبيق العرض';

  @override
  String get on => 'مفعل';

  @override
  String get rushDeliveryActive => 'التوصيل السريع مفعل';

  @override
  String get cashbackApplied => 'تم تطبيق الكاش باك';

  @override
  String get instantDiscountApplied => 'تم تطبيق الخصم الفوري';

  @override
  String get willBeAdded => 'سيتم الإضافة';

  @override
  String get areYouSure => 'هل أنت متأكد؟';

  @override
  String get clearCartConfirm => 'هل تريد فعلاً إفراغ العربة؟';

  @override
  String get no => 'لا';

  @override
  String get yesClear => 'نعم، امسح';

  @override
  String get logoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get maxCartItemLimitReached => 'لقد وصلت إلى الحد الأقصى لعدد العناصر';

  @override
  String get all => 'الكل';

  @override
  String get shopByCategories => 'تسوق حسب الفئات';

  @override
  String get topBrands => 'أفضل العلامات التجارية';

  @override
  String get addItemsToGetStarted => 'أضف عناصر للبدء';

  @override
  String get yourShoppingListIsEmpty => 'قائمة التسوق الخاصة بك فارغة';

  @override
  String get listItem => 'عنصر القائمة';

  @override
  String get itemsAdded => 'تمت إضافة عناصر';

  @override
  String get startShopping => 'ابدأ التسوق';

  @override
  String get typeItemName => 'اكتب اسم العنصر...';

  @override
  String get pleaseAdd1ItemInShoppingList =>
      'الرجاء إضافة عنصر واحد (1) على الأقل في قائمة التسوق الخاصة بك';

  @override
  String get selectDeliveryLocation => 'حدد موقع التسليم';

  @override
  String get searchForAreaStreet => 'ابحث عن منطقة، اسم شارع...';

  @override
  String get useCurrentLocation => 'استخدام الموقع الحالي';

  @override
  String get addNewAddress => 'إضافة عنوان جديد';

  @override
  String get savedAddresses => 'العناوين المحفوظة';

  @override
  String get notLoggedIn => 'غير مُسجل الدخول';

  @override
  String get pleaseLoginToViewYourProfile =>
      'الرجاء تسجيل الدخول لعرض ملفك الشخصي';

  @override
  String get goToLogin => 'اذهب إلى تسجيل الدخول';

  @override
  String get trackYourDelivery => 'تتبع طلبك';

  @override
  String get returnItem => 'إرجاع العنصر';

  @override
  String get failedToLoadTrackingData => 'فشل في تحميل بيانات التتبع';

  @override
  String get delivered => 'تم التوصيل';

  @override
  String get onTheWay => 'في الطريق';

  @override
  String get trackingLiveLocation => 'تتبع الموقع المباشر';

  @override
  String get arrivingIn => 'سيصل في غضون';

  @override
  String get mins => 'دقيقة';

  @override
  String get deliveryPartner => 'شريك التوصيل';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get orderId => 'رقم الطلب';

  @override
  String get payment => 'الدفع';

  @override
  String get orderPlaced => 'تم وضع الطلب';

  @override
  String get deliveryDetails => 'تفاصيل التوصيل';

  @override
  String copiedToClipboard(String label) {
    return 'تم نسخ $label إلى الحافظة';
  }

  @override
  String get orderIdCopied => 'تم نسخ رقم الطلب!';

  @override
  String get reasonForReturn => 'سبب الإرجاع';

  @override
  String get submitReturn => 'إرسال طلب الإرجاع';

  @override
  String get thisProductIsNotCancelable => 'لا يمكن إلغاء هذا المنتج';

  @override
  String get thisProductIsNotReturnable => 'لا يمكن إرجاع هذا المنتج';

  @override
  String get returnButton => 'إرجاع';

  @override
  String get qty => 'الكمية';

  @override
  String get moveToEllipsis => 'نقل إلى...';

  @override
  String get addToEllipsis => 'إضافة إلى...';

  @override
  String get locationAccessNeeded => 'مطلوب إذن الوصول إلى الموقع';

  @override
  String get later => 'لاحقًا';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get appPermissions => 'أذونات التطبيق';

  @override
  String get checkingEmail => 'جارٍ التحقق من البريد الإلكتروني...';

  @override
  String searchInStoreName(String storeName) {
    return 'البحث في $storeName';
  }

  @override
  String get descriptionOptional => 'الوصف (اختياري)';

  @override
  String get greatService => 'على سبيل المثال، خدمة رائعة!';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterYourFullName => 'أدخل اسمك الكامل';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get enterYourPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get enterYourPassword => 'أدخل كلمة المرور الخاصة بك';

  @override
  String get confirmYourPassword => 'تأكيد كلمة المرور الخاصة بك';

  @override
  String get emailOrPhoneNumber => 'البريد الإلكتروني أو رقم الهاتف';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get uploadImages => 'تحميل الصور';

  @override
  String get tapToUploadPhotos => 'اضغط لتحميل الصور';

  @override
  String get helpUsUnderstandYourExperience => 'ساعدنا على فهم تجربتك';

  @override
  String youCanUploadUpToMaxImages(int max) {
    return 'يمكنك تحميل ما يصل إلى $max صور فقط.';
  }

  @override
  String onlyRemainingMoreImagesAdded(int remaining, int max) {
    return 'تمت إضافة $remaining صور أخرى فقط. الحد الأقصى: $max.';
  }

  @override
  String maxImagesAllowedExtensions(int max, String extensions, String size) {
    return '• الحد الأقصى $max صورة • $extensions • $size لكل صورة';
  }

  @override
  String get product => 'المنتج';

  @override
  String get quantity => 'الكمية';

  @override
  String get price => 'السعر';

  @override
  String get clearCart => 'مسح سلة التسوق';

  @override
  String get clearAllItems => 'مسح جميع العناصر؟';

  @override
  String get allItemsWillBeRemovedCannotBeUndone =>
      'ستتم إزالة جميع العناصر ولا يمكن التراجع عن هذا الإجراء';

  @override
  String get paymentSuccessful => 'تم الدفع بنجاح!';

  @override
  String get paymentFailedOrCancelled => 'فشل أو إلغاء الدفع';

  @override
  String get failedToDeleteAddress => 'فشل في حذف العنوان';

  @override
  String get pressAgainToExitTheApp => 'اضغط مرة أخرى للخروج من التطبيق';

  @override
  String get youHaveReachedMaximumLimitOfCart =>
      'لقد وصلت إلى الحد الأقصى لسلة التسوق';

  @override
  String get sellerInformationNotAvailable => 'معلومات البائع غير متوفرة';

  @override
  String get failedToRefreshOrderDetails => 'فشل في تحديث تفاصيل الطلب';

  @override
  String productSavedForLater(String productName) {
    return 'تم حفظ $productName لوقت لاحق';
  }

  @override
  String get promoCodeAppliedOnYourCart =>
      'تم تطبيق الرمز الترويجي على سلة التسوق الخاصة بك';

  @override
  String get youHaveCrossedMaximumCartAmountLimit =>
      'لقد تجاوزت الحد الأقصى لمبلغ سلة التسوق. الرجاء إزالة بعض المنتجات من السلة';

  @override
  String get feedbackSubmittedSuccessfully => 'تم إرسال الملاحظات بنجاح!';

  @override
  String get feedbackUpdatedSuccessfully => 'تم تحديث الملاحظات بنجاح!';

  @override
  String get paymentFailed => 'فشل الدفع';

  @override
  String copiedToClipboardWithLabel(String label) {
    return 'تم نسخ $label إلى الحافظة!';
  }

  @override
  String get pleaseEnterCompleteOTP => 'الرجاء إدخال رمز OTP كاملاً';

  @override
  String get verificationIdNotFound =>
      'لم يتم العثور على معرّف التحقق. الرجاء المحاولة مرة أخرى.';

  @override
  String otpSentTo(String phoneNumber) {
    return 'تم إرسال رمز OTP إلى $phoneNumber';
  }

  @override
  String get registrationDataNotFound =>
      'لم يتم العثور على بيانات التسجيل. الرجاء المحاولة مرة أخرى.';

  @override
  String get noAccountFoundWithEmailOrPhone =>
      'لم يتم العثور على حساب بهذا البريد الإلكتروني أو رقم الهاتف';

  @override
  String get pleaseEnterValidPhoneNumber => 'الرجاء إدخال رقم هاتف صالح';

  @override
  String get emailAlreadyRegistered =>
      'البريد الإلكتروني مسجل بالفعل. الرجاء استخدام بريد إلكتروني مختلف.';

  @override
  String get pleaseEnterYourFullName => 'الرجاء إدخال اسمك الكامل';

  @override
  String get pleaseEnterYourEmail => 'الرجاء إدخال بريدك الإلكتروني';

  @override
  String get pleaseEnterAValidEmail => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get pleaseEnterYourPhoneNumber => 'الرجاء إدخال رقم هاتفك';

  @override
  String get pleaseEnterYourPassword => 'الرجاء إدخال كلمة المرور الخاصة بك';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get pleaseConfirmYourPassword => 'الرجاء تأكيد كلمة المرور الخاصة بك';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get otpVerified => 'تم التحقق من رمز OTP';

  @override
  String get pleaseSelectAPaymentMethodFirst => 'الرجاء تحديد طريقة دفع أولاً';

  @override
  String get fetchingAddress => 'جاري جلب العنوان...';

  @override
  String get selectedLocation => 'الموقع المحدد';

  @override
  String get gettingAddress => 'جاري جلب العنوان...';

  @override
  String get unknownLocation => 'موقع غير معروف';

  @override
  String get deliveryNotAvailableAtThisLocation =>
      'التوصيل غير متاح في هذا الموقع';

  @override
  String get sorryWeDontDeliverHereYet => 'عذراً! لا نقوم بالتوصيل هنا بعد';

  @override
  String get thisLocationIsOutsideOurDeliveryZone =>
      'هذا الموقع خارج منطقة التوصيل حالياً. جرب البحث عن منطقة قريبة أو تحقق لاحقاً.';

  @override
  String get addressDetails => 'تفاصيل العنوان';

  @override
  String get pleaseEnterAddressLine1 => 'الرجاء إدخال سطر العنوان 1';

  @override
  String get pleaseEnterCountry => 'الرجاء إدخال الدولة';

  @override
  String get pleaseEnterState => 'الرجاء إدخال الولاية';

  @override
  String get pleaseEnterCity => 'الرجاء إدخال المدينة';

  @override
  String get pleaseEnterZipcode => 'الرجاء إدخال الرمز البريدي';

  @override
  String get contactDetails => 'تفاصيل الاتصال';

  @override
  String get pleaseEnterMobileNumber => 'الرجاء إدخال رقم الجوال';

  @override
  String get saveAddressAs => 'حفظ العنوان باسم';

  @override
  String get work => 'العمل';

  @override
  String get other => 'أخرى';

  @override
  String get enterCompleteAddress => 'أدخل العنوان الكامل';

  @override
  String get confirm => 'تأكيد';

  @override
  String get checkingDelivery => 'جاري التحقق من التوصيل...';

  @override
  String get confirmLocation => 'تأكيد الموقع';

  @override
  String get confirmAddressToProceed => 'أكد العنوان للمتابعة';

  @override
  String get addAddressToProceed => 'أضف عنواناً للمتابعة';

  @override
  String get deliveryNotAvailable => 'التوصيل غير متاح';

  @override
  String get skip => 'تخطي';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInToYourAccount => 'سجل الدخول إلى حسابك للمتابعة';

  @override
  String get verifying => 'جاري التحقق...';

  @override
  String get or => 'أو';

  @override
  String get dontHaveAnAccount => 'ليس لديك حساب؟ ';

  @override
  String get emailVerifiedSuccessfully =>
      'تم التحقق من البريد الإلكتروني بنجاح';

  @override
  String get phoneNumberVerifiedSuccessfully => 'تم التحقق من رقم الهاتف بنجاح';

  @override
  String get thisEmailIsNotRegistered =>
      'هذا البريد الإلكتروني غير مسجل. يرجى التسجيل أولاً.';

  @override
  String get thisPhoneNumberIsNotRegistered =>
      'هذا رقم الهاتف غير مسجل. يرجى التسجيل أولاً.';

  @override
  String get unableToVerifyUser =>
      'تعذر التحقق من المستخدم. يرجى المحاولة مرة أخرى.';

  @override
  String get emailOrPhoneNumberIsRequired =>
      'البريد الإلكتروني أو رقم الهاتف مطلوب';

  @override
  String get enterValidEmailOrPhone =>
      'أدخل بريداً إلكترونياً أو هاتفاً صالحاً';

  @override
  String get passwordIsRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordMustBeAtLeast6Characters =>
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get alreadyHaveAnAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get emailAlreadyRegisteredUseDifferent =>
      'البريد الإلكتروني مسجل بالفعل. يرجى استخدام بريد آخر.';

  @override
  String get changeLocation => 'تغيير الموقع';

  @override
  String get chooseAddressForDelivery => 'اختر عنواناً للتوصيل';

  @override
  String get balance => 'الرصيد';

  @override
  String get tapCoinToRefresh => 'اضغط على العملة للتحديث';

  @override
  String get viewTransactions => 'عرض المعاملات';

  @override
  String get verifyOtp => 'التحقق من رمز OTP';

  @override
  String get pleaseFillDetailsCreateYourAccount =>
      'يرجى ملء التفاصيل لإنشاء حسابك';

  @override
  String get emailAvailable => 'البريد الإلكتروني متاح';

  @override
  String get errorVerifyingEmail => 'خطأ في التحقق من البريد الإلكتروني';

  @override
  String get pleaseAddYourDeliveryAddress =>
      'يرجى إضافة عنوان التوصيل الخاص بك';

  @override
  String get areYouSureDeleteFeedback => 'هل أنت متأكد من حذف التقييم';

  @override
  String get addTo => 'إضافة إلى…';

  @override
  String get moveTo => 'نقل إلى…';

  @override
  String get accountInformation => 'معلومات الحساب';

  @override
  String get mobile => 'الجوال';

  @override
  String get rewardPoints => 'نقاط المكافآت';

  @override
  String get referralCode => 'كود الإحالة';

  @override
  String get notProvided => 'غير مقدم';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get failedToLoadProfile => 'فشل تحميل الملف الشخصي';

  @override
  String get pleaseCheckConnection => 'يرجى التحقق من الاتصال وإعادة المحاولة';

  @override
  String get noProfileDataAvailable => 'لا توجد بيانات ملف شخصي متاحة';

  @override
  String get giveYourDeliveryHeroFeedback =>
      'أعطِ تقييماً لسائق التوصيل الخاص بك!';

  @override
  String editYourFeedbackFor(String name) {
    return 'عدل تقييمك لـ $name';
  }

  @override
  String get leaveFeedback => 'ترك تقييم';

  @override
  String get editFeedback => 'تعديل التقييم';

  @override
  String get editSellerFeedback => 'تعديل تقييم البائع';

  @override
  String get leaveSellerFeedback => 'ترك تقييم للبائع';

  @override
  String get productNotApprovedBySeller => 'هذا المنتج غير معتمد من البائع';

  @override
  String get leaveItemFeedback => 'ترك تقييم للعنصر';

  @override
  String get cashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get paidOnline => 'مدفوع عبر الإنترنت';

  @override
  String orderPlacedOn(String date) {
    return 'تم تقديم الطلب في $date';
  }

  @override
  String get locationAccessDescription =>
      'تطبيق هذا يقدم خدمات محلية فائقة. يرجى تفعيل الموقع للحصول على توصيات شخصية ونتائج دقيقة.';

  @override
  String get turnOnLocationServicesDescription =>
      'فعّل خدمات الموقع وامنح التطبيق إذن الموقع للمتابعة.';

  @override
  String get loadingPaymentPage => 'جاري تحميل صفحة الدفع...';

  @override
  String youCanUploadUpToImagesOnly(int count) {
    return 'يمكنك رفع حتى $count صور فقط.';
  }

  @override
  String onlyMoreImagesAddedMaxLimit(int remaining, int max) {
    return 'تم إضافة $remaining صورة(صور) إضافية فقط. الحد الأقصى: $max.';
  }

  @override
  String get onlinePaymentMethods => 'طرق الدفع عبر الإنترنت';

  @override
  String get noCategoryFound => 'لم يتم العثور على فئة';

  @override
  String get noStoreFound => 'لم يتم العثور على متجر';

  @override
  String get wereNotHereYet => 'لم نصل هنا بعد';

  @override
  String get weCouldntFindAnyCategories => 'لم نتمكن من العثور على أي فئات.';

  @override
  String get weCouldntFindAnyStoreInYourSelectLocation =>
      'لم نتمكن من العثور على أي متجر في الموقع المحدد.';

  @override
  String get phoneNumberCopied => 'تم نسخ رقم الهاتف إلى الحافظة!';

  @override
  String get emailCopied => 'تم نسخ البريد الإلكتروني إلى الحافظة!';

  @override
  String get pleaseWaitBeforeResending => 'يرجى الانتظار قبل إعادة الإرسال.';

  @override
  String get toPay => 'المبلغ المستحق:';

  @override
  String get currentlyUnavailable => 'غير متاح حالياً';

  @override
  String get noStoresOrProductsAreAvailableInThisAreaRightNow =>
      'لا توجد متاجر أو منتجات متاحة في هذه المنطقة الآن.';

  @override
  String get checkConnectionAndTryAgain =>
      'يرجى التحقق من الاتصال وإعادة المحاولة.';

  @override
  String get weWillBeBackSoon => 'سنعود قريباً. انتظر قليلاً!';

  @override
  String get noOrdersYetDescription => 'يبدو أنه ليس لديك أي طلبات بعد.';

  @override
  String get tryAdjustingSearchTerms => 'جرب تعديل مصطلحات البحث.';

  @override
  String get noProductMatchingSearch =>
      'لم نتمكن من العثور على أي منتجات تطابق بحثك.';

  @override
  String get feedbackDeletedSuccessfully => 'تم حذف التقييم بنجاح!';

  @override
  String get rateDeliveryHero => 'قيّم سائق التوصيل';

  @override
  String get howWasTheDelivery => 'كيف كان التوصيل؟';

  @override
  String get egSuperFastDelivery => 'مثال: توصيل فائق السرعة!';

  @override
  String get youMightAlsoLike => 'You might also like';

  @override
  String get storeCurrentlyClosed => 'Store is currently closed';

  @override
  String minimumQuantityRequired(Object minQty) {
    return 'Minimum quantity is $minQty';
  }

  @override
  String maximumQuantityAllowed(Object maxQty) {
    return 'Maximum $maxQty items allowed';
  }

  @override
  String onlyXItemsInStock(Object stock) {
    return 'Only $stock items available in stock';
  }

  @override
  String minimumCartAmountRequired(
      Object minAmount, Object miniCheckoutAmount) {
    return 'Add $minAmount more to reach the $miniCheckoutAmount minimum checkout.';
  }

  @override
  String get youHaveReachedMaximumLimitOfTheCart =>
      'لقد وصلت إلى الحد الأقصى للسلة';

  @override
  String get onlyOneStoreAtATime =>
      'You can only order from one store at a time';

  @override
  String onlyFewLeft(Object stock) {
    return 'Only $stock left!';
  }

  @override
  String get inStock => 'In stock';

  @override
  String get noTransactionYet => 'No Transaction Yet';

  @override
  String get noTransactionDescriptionMsg =>
      'Your wallet activity will appear here once';

  @override
  String get noTransactionDescriptionSecondaryMsg =>
      'you make your first transaction.';

  @override
  String cannotAddMoreThanXItems(Object remaining) {
    return 'You can add only $remaining more item(s) to your cart.';
  }

  @override
  String youCanAddOnlyXMoreItems(Object count) {
    return 'You can add only $count more item(s).';
  }

  @override
  String cartIsAlreadyAtMaximumLimit(Object maxAllowed) {
    return 'Your cart has reached the maximum item limit ($maxAllowed).';
  }

  @override
  String get cannotAddFromDifferentStore =>
      'You can only add items from the same store. Please clear your cart or choose items from this store.';

  @override
  String get cartAlreadyContainsMultipleStores =>
      'Your cart already contains items from multiple stores. Please complete the current order or clear the cart first.';

  @override
  String get inCart => 'in cart';

  @override
  String get thisActionIsPermanent => 'This action is PERMANENT.';

  @override
  String get allYourDataWillBeLostForever =>
      'All your data will be lost forever.';

  @override
  String get addYourFirstAddressToStart =>
      'Add your first address to get started';

  @override
  String get noAddressFound => 'No Address Found';

  @override
  String get includingAllTax => '(inclusive of all tax)';

  @override
  String get dataPlaceholder => 'data';

  @override
  String get writeYourNoteHere => 'Write your note here...';

  @override
  String get clearingYourCart => 'Clearing your cart...';

  @override
  String get imagesLabel => 'Images';

  @override
  String get imagesSubtitle => 'JPG, PNG (Max 5MB)';

  @override
  String get pdfDocumentLabel => 'PDF Document';

  @override
  String get pdfDocumentSubtitle => 'PDF files (Max 10MB)';

  @override
  String get wordDocumentLabel => 'Word Document';

  @override
  String get wordDocumentSubtitle => 'DOCX files (Max 10MB)';

  @override
  String cannotOpenFile(String url) {
    return 'Cannot open file: $url';
  }

  @override
  String errorOpeningAttachment(String error) {
    return 'Error opening attachment: $error';
  }

  @override
  String get paystackPaymentTitle => 'Paystack Payment';

  @override
  String get enableLocationTitle => 'Enable Location';

  @override
  String get failed => 'Failed';

  @override
  String get youWillBeResponsible => 'you will be responsible';

  @override
  String get deleteWishlistConfirmation =>
      'Are you sure you want to delete this wishlist?';
}
