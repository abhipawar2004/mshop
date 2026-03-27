import '../model/settings_model/settings_model.dart';

/// Modified singleton for managing settings data.
/// Instead of storing a raw list, we parse and store strongly-typed models for each section.
/// This makes it easier to access and use, e.g., SettingsData().system.appName.
class SettingsData {
  static final SettingsData _instance = SettingsData._internal();

  static SettingsData get instance => _instance;

  factory SettingsData() {
    return _instance;
  }

  SettingsData._internal();

  SystemSettings? system;
  StorageSettings? storage;
  EmailSettings? email;
  PaymentSettings? payment;
  AuthenticationSettings? authentication;
  NotificationSettings? notification;
  WebSettings? web;
  AppSettings? app;
  DeliveryBoySettings? deliveryBoy;
  HomeGeneralSettings? homeGeneralSettings;

  void setSettingsData(List<SettingsApiModel> data) {
    for (final item in data) {
      final valueJson = item.value as Map<String, dynamic>;
      switch (item.variable) {
        case 'system':
          system = SystemSettings.fromJson(valueJson);
          break;
        case 'storage':
          storage = StorageSettings.fromJson(valueJson);
          break;
        case 'email':
          email = EmailSettings.fromJson(valueJson);
          break;
        case 'payment':
          payment = PaymentSettings.fromJson(valueJson);
          break;
        case 'authentication':
          authentication = AuthenticationSettings.fromJson(valueJson);
          break;
        case 'notification':
          notification = NotificationSettings.fromJson(valueJson);
          break;
        case 'web':
          web = WebSettings.fromJson(valueJson);
          break;
        case 'app':
          app = AppSettings.fromJson(valueJson);
          break;
        case 'delivery_boy':
          deliveryBoy = DeliveryBoySettings.fromJson(valueJson);
          break;
        case 'home_general_settings':
          homeGeneralSettings = HomeGeneralSettings.fromJson(valueJson);
          break;
      }
    }
  }

  void clear() {
    system = null;
    storage = null;
    email = null;
    payment = null;
    authentication = null;
    notification = null;
    web = null;
    app = null;
    deliveryBoy = null;
    homeGeneralSettings = null;
  }
}