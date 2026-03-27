import 'dart:convert';

/// Base model for individual settings items from the API response.
/// This will hold the variable name and the parsed value as a specific model or Map.
class SettingsApiModel {
  final String variable;
  final dynamic value; // Will be parsed to specific models in SettingsData

  SettingsApiModel({
    required this.variable,
    required this.value,
  });

  factory SettingsApiModel.fromJson(Map<String, dynamic> json) {
    return SettingsApiModel(
      variable: json['variable'] as String,
      value: json['value'], // Keep as dynamic Map for now; parsed later
    );
  }
}

/// Model for the entire API response.
class SettingsResponse {
  final bool success;
  final String message;
  final List<SettingsApiModel> data;

  SettingsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SettingsResponse.fromJson(Map<String, dynamic> json) {
    return SettingsResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => SettingsApiModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convenience method to parse from a JSON string.
  static SettingsResponse fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return SettingsResponse.fromJson(json);
  }
}

/// Specific model for 'system' settings.
class SystemSettings {
  final String appName;
  final String sellerSupportNumber;
  final String sellerSupportEmail;
  final String systemTimezone;
  final String copyrightDetails;
  final String logo;
  final String favicon;
  final bool enableThirdPartyStoreSync;
  final bool shopify;
  final bool woocommerce;
  final bool etsy;
  final String checkoutType;
  final int minimumCartAmount;
  final int maximumItemsAllowedInCart;
  final String lowStockLimit;
  final String maximumDistanceToNearestStore;
  final bool enableWallet;
  final int welcomeWalletBalanceAmount;
  final bool sellerAppMaintenanceMode;
  final String sellerAppMaintenanceMessage;
  final bool webMaintenanceMode;
  final String webMaintenanceMessage;
  final bool? demoMode;
  final String? adminDemoModeMessage;
  final String? sellerDemoModeMessage;
  final String? customerDemoModeMessage;
  final String? customerLocationDemoModeMessage;
  final String? deliveryBoyDemoModeMessage;
  final bool referEarnStatus;
  final String referEarnMethodUser;
  final String referEarnBonusUser;
  final String referEarnMaximumBonusAmountUser;
  final String referEarnMethodReferral;
  final String referEarnBonusReferral;
  final String referEarnMaximumBonusAmountReferral;
  final String referEarnMinimumOrderAmount;
  final String referEarnNumberOfTimesBonus;
  final String currency;
  final String currencySymbol;

  SystemSettings({
    required this.appName,
    required this.sellerSupportNumber,
    required this.sellerSupportEmail,
    required this.systemTimezone,
    required this.copyrightDetails,
    required this.logo,
    required this.favicon,
    required this.enableThirdPartyStoreSync,
    required this.shopify,
    required this.woocommerce,
    required this.etsy,
    required this.checkoutType,
    required this.minimumCartAmount,
    required this.maximumItemsAllowedInCart,
    required this.lowStockLimit,
    required this.maximumDistanceToNearestStore,
    required this.enableWallet,
    required this.welcomeWalletBalanceAmount,
    required this.sellerAppMaintenanceMode,
    required this.sellerAppMaintenanceMessage,
    required this.webMaintenanceMode,
    required this.webMaintenanceMessage,
    required this.demoMode,
    required this.adminDemoModeMessage,
    required this.sellerDemoModeMessage,
    required this.customerDemoModeMessage,
    required this.customerLocationDemoModeMessage,
    required this.deliveryBoyDemoModeMessage,
    required this.referEarnStatus,
    required this.referEarnMethodUser,
    required this.referEarnBonusUser,
    required this.referEarnMaximumBonusAmountUser,
    required this.referEarnMethodReferral,
    required this.referEarnBonusReferral,
    required this.referEarnMaximumBonusAmountReferral,
    required this.referEarnMinimumOrderAmount,
    required this.referEarnNumberOfTimesBonus,
    required this.currency,
    required this.currencySymbol,
  });

  factory SystemSettings.fromJson(Map<String, dynamic> json) {
    return SystemSettings(
      appName: json['appName'] as String,
      sellerSupportNumber: json['sellerSupportNumber'] as String,
      sellerSupportEmail: json['sellerSupportEmail'] as String,
      systemTimezone: json['systemTimezone'] as String,
      copyrightDetails: json['copyrightDetails'] as String,
      logo: json['logo'] as String,
      favicon: json['favicon'] as String,
      enableThirdPartyStoreSync: json['enableThirdPartyStoreSync'] as bool,
      shopify: json['Shopify'] as bool, // Note: JSON uses 'Shopify' with capital S
      woocommerce: json['Woocommerce'] as bool,
      etsy: json['etsy'] as bool,
      checkoutType: json['checkoutType'] as String,
      minimumCartAmount: json['minimumCartAmount'] as int,
      maximumItemsAllowedInCart: json['maximumItemsAllowedInCart'] as int,
      lowStockLimit: json['lowStockLimit'] as String,
      maximumDistanceToNearestStore: json['maximumDistanceToNearestStore'] as String,
      enableWallet: json['enableWallet'] as bool,
      welcomeWalletBalanceAmount: json['welcomeWalletBalanceAmount'] as int,
      sellerAppMaintenanceMode: json['sellerAppMaintenanceMode'] as bool,
      sellerAppMaintenanceMessage: json['sellerAppMaintenanceMessage'] as String,
      webMaintenanceMode: json['webMaintenanceMode'] as bool,
      webMaintenanceMessage: json['webMaintenanceMessage'] as String,
      demoMode: json['demoMode'] as bool,
      adminDemoModeMessage: json['adminDemoModeMessage'] as String,
      sellerDemoModeMessage : json['sellerDemoModeMessage'] as String,
      customerDemoModeMessage : json['customerDemoModeMessage'] as String,
      customerLocationDemoModeMessage : json['customerLocationDemoModeMessage'] as String,
      deliveryBoyDemoModeMessage : json['deliveryBoyDemoModeMessage'] as String,
      referEarnStatus: json['referEarnStatus'] as bool,
      referEarnMethodUser: json['referEarnMethodUser'] as String,
      referEarnBonusUser: json['referEarnBonusUser'] as String,
      referEarnMaximumBonusAmountUser: json['referEarnMaximumBonusAmountUser'] as String,
      referEarnMethodReferral: json['referEarnMethodReferral'] as String,
      referEarnBonusReferral: json['referEarnBonusReferral'] as String,
      referEarnMaximumBonusAmountReferral: json['referEarnMaximumBonusAmountReferral'] as String,
      referEarnMinimumOrderAmount: json['referEarnMinimumOrderAmount'] as String,
      referEarnNumberOfTimesBonus: json['referEarnNumberOfTimesBonus'] as String,
      currency: json['currency'] as String,
      currencySymbol: json['currencySymbol'] as String,
    );
  }
}

/// Specific model for 'storage' settings.
class StorageSettings {
  final String awsRegion;
  final String awsBucket;
  final String awsAssetUrl;

  StorageSettings({
    required this.awsRegion,
    required this.awsBucket,
    required this.awsAssetUrl,
  });

  factory StorageSettings.fromJson(Map<String, dynamic> json) {
    return StorageSettings(
      awsRegion: json['awsRegion'] as String,
      awsBucket: json['awsBucket'] as String,
      awsAssetUrl: json['awsAssetUrl'] as String,
    );
  }
}

/// Specific model for 'email' settings.
class EmailSettings {
  final String smtpHost;
  final String smtpPort;
  final String smtpEmail;
  final String smtpEncryption;
  final String smtpContentType;

  EmailSettings({
    required this.smtpHost,
    required this.smtpPort,
    required this.smtpEmail,
    required this.smtpEncryption,
    required this.smtpContentType,
  });

  factory EmailSettings.fromJson(Map<String, dynamic> json) {
    return EmailSettings(
      smtpHost: json['smtpHost'] as String,
      smtpPort: json['smtpPort'] as String,
      smtpEmail: json['smtpEmail'] as String,
      smtpEncryption: json['smtpEncryption'] as String,
      smtpContentType: json['smtpContentType'] as String,
    );
  }
}

/// Specific model for 'payment' settings.
class PaymentSettings {
  final bool stripePayment;
  final String stripePaymentMode;
  final String stripePublishableKey;
  final String stripeCurrencyCode;
  final bool razorpayPayment;
  final String razorpayPaymentMode;
  final String razorpayKeyId;
  final bool paystackPayment;
  final String paystackPaymentMode;
  final String paystackPublicKey;
  final bool wallet;
  final bool cod;
  final bool directBankTransfer;
  final String bankAccountName;
  final String bankAccountNumber;
  final String bankName;
  final String bankCode;
  final String bankExtraNote;
  final bool flutterWavePayment;
  final String flutterWavePaymentMode;
  final String flutterWavePublicKey;
  final String flutterWaveCurrencyCode;

  PaymentSettings({
    required this.stripePayment,
    required this.stripePaymentMode,
    required this.stripePublishableKey,
    required this.stripeCurrencyCode,
    required this.razorpayPayment,
    required this.razorpayPaymentMode,
    required this.razorpayKeyId,
    required this.paystackPayment,
    required this.paystackPaymentMode,
    required this.paystackPublicKey,
    required this.wallet,
    required this.cod,
    required this.directBankTransfer,
    required this.bankAccountName,
    required this.bankAccountNumber,
    required this.bankName,
    required this.bankCode,
    required this.bankExtraNote,
    required this.flutterWavePayment,
    required this.flutterWavePaymentMode,
    required this.flutterWavePublicKey,
    required this.flutterWaveCurrencyCode,
  });

  factory PaymentSettings.fromJson(Map<String, dynamic> json) {
    return PaymentSettings(
      stripePayment: json['stripePayment'] as bool,
      stripePaymentMode: json['stripePaymentMode'] as String,
      stripePublishableKey: json['stripePublishableKey'] as String,
      stripeCurrencyCode: json['stripeCurrencyCode'] as String,
      razorpayPayment: json['razorpayPayment'] as bool,
      razorpayPaymentMode: json['razorpayPaymentMode'] as String,
      razorpayKeyId: json['razorpayKeyId'] as String,
      paystackPayment: json['paystackPayment'] as bool,
      paystackPaymentMode: json['paystackPaymentMode'] as String,
      paystackPublicKey: json['paystackPublicKey'] as String,
      wallet: json['wallet'] as bool,
      cod: json['cod'] as bool,
      directBankTransfer: json['directBankTransfer'] as bool,
      bankAccountName: json['bankAccountName'] as String,
      bankAccountNumber: json['bankAccountNumber'] as String,
      bankName: json['bankName'] as String,
      bankCode: json['bankCode'] as String,
      bankExtraNote: json['bankExtraNote'] as String,
      flutterWavePayment: json['flutterwavePayment'] as bool,
      flutterWavePaymentMode: json['flutterwavePaymentMode'] as String,
      flutterWavePublicKey: json['flutterwavePublicKey'] as String,
      flutterWaveCurrencyCode: json['flutterwaveCurrencyCode'] as String,
    );
  }
}

/// Specific model for 'authentication' settings.
class AuthenticationSettings {
  final bool customSms;
  final String customSmsUrl;
  final String customSmsMethod;
  final String googleRecaptchaSiteKey;
  final bool firebase;
  final String fireBaseApiKey;
  final String fireBaseAuthDomain;
  final String fireBaseDatabaseURL;
  final String fireBaseProjectId;
  final String fireBaseStorageBucket;
  final String fireBaseMessagingSenderId;
  final String fireBaseAppId;
  final String fireBaseMeasurementId;
  final bool appleLogin;
  final bool googleLogin;
  final bool facebookLogin;
  final String googleApiKey;

  AuthenticationSettings({
    required this.customSms,
    required this.customSmsUrl,
    required this.customSmsMethod,
    required this.googleRecaptchaSiteKey,
    required this.firebase,
    required this.fireBaseApiKey,
    required this.fireBaseAuthDomain,
    required this.fireBaseDatabaseURL,
    required this.fireBaseProjectId,
    required this.fireBaseStorageBucket,
    required this.fireBaseMessagingSenderId,
    required this.fireBaseAppId,
    required this.fireBaseMeasurementId,
    required this.appleLogin,
    required this.googleLogin,
    required this.facebookLogin,
    required this.googleApiKey,
  });

  factory AuthenticationSettings.fromJson(Map<String, dynamic> json) {
    return AuthenticationSettings(
      customSms: json['customSms'] as bool,
      customSmsUrl: json['customSmsUrl'] as String,
      customSmsMethod: json['customSmsMethod'] as String,
      googleRecaptchaSiteKey: json['googleRecaptchaSiteKey'] as String,
      firebase: json['firebase'] as bool,
      fireBaseApiKey: json['fireBaseApiKey'] as String,
      fireBaseAuthDomain: json['fireBaseAuthDomain'] as String,
      fireBaseDatabaseURL: json['fireBaseDatabaseURL'] as String,
      fireBaseProjectId: json['fireBaseProjectId'] as String,
      fireBaseStorageBucket: json['fireBaseStorageBucket'] as String,
      fireBaseMessagingSenderId: json['fireBaseMessagingSenderId'] as String,
      fireBaseAppId: json['fireBaseAppId'] as String,
      fireBaseMeasurementId: json['fireBaseMeasurementId'] as String,
      appleLogin: json['appleLogin'] as bool,
      googleLogin: json['googleLogin'] as bool,
      facebookLogin: json['facebookLogin'] as bool,
      googleApiKey: json['googleApiKey'] as String,
    );
  }
}

/// Specific model for 'notification' settings.
class NotificationSettings {
  final String firebaseProjectId;
  final String vapIdKey;

  NotificationSettings({
    required this.firebaseProjectId,
    required this.vapIdKey,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      firebaseProjectId: json['firebaseProjectId'] as String,
      vapIdKey: json['vapIdKey'] as String,
    );
  }
}

/// Specific model for 'web' settings.
class WebSettings {
  final String siteName;
  final String siteCopyright;
  final String supportNumber;
  final String supportEmail;
  final String address;
  final String shortDescription;
  final String siteHeaderLogo;
  final String siteFooterLogo;
  final String siteFavicon;
  final String headerScript;
  final String footerScript;
  final String googleMapKey;
  final String mapIframe;
  final bool appDownloadSection;
  final String appSectionTitle;
  final String appSectionTagline;
  final String appSectionPlaystoreLink;
  final String appSectionAppstoreLink;
  final String appSectionShortDescription;
  final String facebookLink;
  final String instagramLink;
  final String xLink;
  final String youtubeLink;
  final String shippingFeatureSection;
  final String shippingFeatureSectionTitle;
  final String shippingFeatureSectionDescription;
  final String returnFeatureSection;
  final String returnFeatureSectionTitle;
  final String returnFeatureSectionDescription;
  final String safetySecurityFeatureSection;
  final String safetySecurityFeatureSectionTitle;
  final String safetySecurityFeatureSectionDescription;
  final String supportFeatureSection;
  final String supportFeatureSectionTitle;
  final String supportFeatureSectionDescription;
  final String metaKeywords;
  final String metaDescription;
  final String defaultLatitude;
  final String defaultLongitude;
  final bool enableCountryValidation;
  final List<String> allowedCountries;
  final String returnRefundPolicy;
  final String shippingPolicy;
  final String privacyPolicy;
  final String termsCondition;
  final String aboutUs;

  WebSettings({
    required this.siteName,
    required this.siteCopyright,
    required this.supportNumber,
    required this.supportEmail,
    required this.address,
    required this.shortDescription,
    required this.siteHeaderLogo,
    required this.siteFooterLogo,
    required this.siteFavicon,
    required this.headerScript,
    required this.footerScript,
    required this.googleMapKey,
    required this.mapIframe,
    required this.appDownloadSection,
    required this.appSectionTitle,
    required this.appSectionTagline,
    required this.appSectionPlaystoreLink,
    required this.appSectionAppstoreLink,
    required this.appSectionShortDescription,
    required this.facebookLink,
    required this.instagramLink,
    required this.xLink,
    required this.youtubeLink,
    required this.shippingFeatureSection,
    required this.shippingFeatureSectionTitle,
    required this.shippingFeatureSectionDescription,
    required this.returnFeatureSection,
    required this.returnFeatureSectionTitle,
    required this.returnFeatureSectionDescription,
    required this.safetySecurityFeatureSection,
    required this.safetySecurityFeatureSectionTitle,
    required this.safetySecurityFeatureSectionDescription,
    required this.supportFeatureSection,
    required this.supportFeatureSectionTitle,
    required this.supportFeatureSectionDescription,
    required this.metaKeywords,
    required this.metaDescription,
    required this.defaultLatitude,
    required this.defaultLongitude,
    required this.enableCountryValidation,
    required this.allowedCountries,
    required this.returnRefundPolicy,
    required this.shippingPolicy,
    required this.privacyPolicy,
    required this.termsCondition,
    required this.aboutUs,
  });

  factory WebSettings.fromJson(Map<String, dynamic> json) {
    return WebSettings(
      siteName: json['siteName'] as String,
      siteCopyright: json['siteCopyright'] as String,
      supportNumber: json['supportNumber'] as String,
      supportEmail: json['supportEmail'] as String,
      address: json['address'] as String,
      shortDescription: json['shortDescription'] as String,
      siteHeaderLogo: json['siteHeaderLogo'] as String,
      siteFooterLogo: json['siteFooterLogo'] as String,
      siteFavicon: json['siteFavicon'] as String,
      headerScript: json['headerScript'] as String,
      footerScript: json['footerScript'] as String,
      googleMapKey: json['googleMapKey'] as String,
      mapIframe: json['mapIframe'] as String,
      appDownloadSection: json['appDownloadSection'] as bool,
      appSectionTitle: json['appSectionTitle'] as String,
      appSectionTagline: json['appSectionTagline'] as String,
      appSectionPlaystoreLink: json['appSectionPlaystoreLink'] as String,
      appSectionAppstoreLink: json['appSectionAppstoreLink'] as String,
      appSectionShortDescription: json['appSectionShortDescription'] as String,
      facebookLink: json['facebookLink'] as String,
      instagramLink: json['instagramLink'] as String,
      xLink: json['xLink'] as String,
      youtubeLink: json['youtubeLink'] as String,
      shippingFeatureSection: json['shippingFeatureSection'] as String,
      shippingFeatureSectionTitle: json['shippingFeatureSectionTitle'] as String,
      shippingFeatureSectionDescription: json['shippingFeatureSectionDescription'] as String,
      returnFeatureSection: json['returnFeatureSection'] as String,
      returnFeatureSectionTitle: json['returnFeatureSectionTitle'] as String,
      returnFeatureSectionDescription: json['returnFeatureSectionDescription'] as String,
      safetySecurityFeatureSection: json['safetySecurityFeatureSection'] as String,
      safetySecurityFeatureSectionTitle: json['safetySecurityFeatureSectionTitle'] as String,
      safetySecurityFeatureSectionDescription: json['safetySecurityFeatureSectionDescription'] as String,
      supportFeatureSection: json['supportFeatureSection'] as String,
      supportFeatureSectionTitle: json['supportFeatureSectionTitle'] as String,
      supportFeatureSectionDescription: json['supportFeatureSectionDescription'] as String,
      metaKeywords: json['metaKeywords'] as String,
      metaDescription: json['metaDescription'] as String,
      defaultLatitude: json['defaultLatitude'] as String,
      defaultLongitude: json['defaultLongitude'] as String,
      enableCountryValidation: json['enableCountryValidation'] as bool,
      allowedCountries: (json['allowedCountries'] as List<dynamic>).cast<String>(),
      returnRefundPolicy: json['returnRefundPolicy'] as String,
      shippingPolicy: json['shippingPolicy'] as String,
      privacyPolicy: json['privacyPolicy'] as String,
      termsCondition: json['termsCondition'] as String,
      aboutUs: json['aboutUs'] as String,
    );
  }
}

/// Specific model for 'app' settings.
class AppSettings {
  final String appstoreLink;
  final String playstoreLink;
  final String appScheme;
  final String appDomainName;

  AppSettings({
    required this.appstoreLink,
    required this.playstoreLink,
    required this.appScheme,
    required this.appDomainName,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      appstoreLink: json['appstoreLink'] as String,
      playstoreLink: json['playstoreLink'] as String,
      appScheme: json['appScheme'] as String,
      appDomainName: json['appDomainName'] as String,
    );
  }
}

/// Specific model for 'delivery_boy' settings.
class DeliveryBoySettings {
  final String termsCondition;
  final String privacyPolicy;

  DeliveryBoySettings({
    required this.termsCondition,
    required this.privacyPolicy,
  });

  factory DeliveryBoySettings.fromJson(Map<String, dynamic> json) {
    return DeliveryBoySettings(
      termsCondition: json['termsCondition'] as String,
      privacyPolicy: json['privacyPolicy'] as String,
    );
  }
}

/// Specific model for 'home_general_settings' settings.
class HomeGeneralSettings {
  final String title;
  final List<String>? searchLabels;
  final String backgroundType;
  final String backgroundColor;
  final String backgroundImage;
  final String icon;
  final String activeIcon;
  final String fontColor;

  HomeGeneralSettings({
    required this.title,
    required this.searchLabels,
    required this.backgroundType,
    required this.backgroundColor,
    required this.backgroundImage,
    required this.icon,
    required this.activeIcon,
    required this.fontColor,
  });

  factory HomeGeneralSettings.fromJson(Map<String, dynamic> json) {
    return HomeGeneralSettings(
      title: json['title'] as String,
      searchLabels: json['searchLabels'].cast<String>(),
      backgroundType: json['backgroundType'] as String,
      backgroundColor: json['backgroundColor'] as String,
      backgroundImage: json['backgroundImage'] as String,
      icon: json['icon'] as String,
      activeIcon: json['activeIcon'] as String,
      fontColor: json['fontColor'] as String,
    );
  }
}