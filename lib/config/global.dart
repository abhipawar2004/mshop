import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hyper_local/model/user_data_model/user_data_model.dart';

class Global {
  static const String _boxName = 'UserDataBox';
  static const String _userKey = 'UserData';

  static UserDataModel? _userData;

  /// Initialize Hive data (user)
  static Future<void> initialize() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserDataModelAdapter());
    }
    Box box = await Hive.openBox<UserDataModel>(_boxName);
    _userData = box.get(_userKey);
    debugPrint('✅ Initialized UserData: $_userData');
    debugPrint('✅ Initialized UserData: ${_userData?.email}');
  }

  // ---------------- App Preferences (stored separately) ----------------
  static const String _prefsBoxName = 'AppPrefsBox';
  static const String _isFirstTimeKey = 'isFirstTime';
  static bool? _isFirstTime;

  /// Initialize preferences (should be called after Hive.initFlutter())
  static Future<void> initializePrefs() async {
    try {
      final Box prefsBox = await Hive.openBox(_prefsBoxName);
      _isFirstTime =
          prefsBox.get(_isFirstTimeKey, defaultValue: true) as bool? ?? true;
      debugPrint('✅ Initialized prefs: isFirstTime=$_isFirstTime');
    } catch (e) {
      debugPrint('❌ Failed to initialize prefs: $e');
      _isFirstTime = true;
    }
  }

  /// Get whether this is the first time the user launched the app.
  static bool get isFirstTime => _isFirstTime ?? true;

  /// Set the first-time flag and persist it.
  static Future<void> setIsFirstTime(bool value) async {
    final Box prefsBox = await Hive.openBox(_prefsBoxName);
    await prefsBox.put(_isFirstTimeKey, value);
    _isFirstTime = value;
    debugPrint('🔖 Set isFirstTime = $value');
  }

  /// Save full user data
  static Future<void> setUserData(UserDataModel userData) async {
    Box box = await Hive.openBox<UserDataModel>(_boxName);
    await box.put(_userKey, userData);
    _userData = userData;
    debugPrint('✅ Set UserData: $userData');
  }

  /// Clear user data
  static Future<void> clearUserData() async {
    Box box = await Hive.openBox<UserDataModel>(_boxName);
    await box.delete(_userKey);
    _userData = null;
    debugPrint('🗑️ Cleared UserData');
  }

  /// Get current user (sync, cached)
  static UserDataModel? get userData => _userData;

  /// Get token directly
  static String? get token => _userData?.token;

  /// Get language (sync, cached)
  static String get currentLanguage => _userData?.language ?? 'en';

  /// Update language inside UserDataModel
  static Future<void> setLanguage(String languageCode) async {
    if (_userData == null) return;
    final updatedUser = _userData!.copyWith(language: languageCode);
    await setUserData(updatedUser);
    debugPrint('🌐 Updated Language: $languageCode');
  }

  /// Supported languages
  static List<Map<String, String>> get supportedLanguages => [
        {'code': 'en', 'name': 'English', 'nativeName': 'English'},
        {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
        {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
        {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी'},
        {'code': 'gu', 'name': 'Gujarati', 'nativeName': 'ગુજરાતી'},
        {'code': 'te', 'name': 'Telugu', 'nativeName': 'తెలుగు'},
      ];

  /// Convert languageCode -> Locale
  static Locale getLocaleFromLanguage(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return const Locale('ar');
      case 'fr':
        return const Locale('fr');
      case 'hi':
        return const Locale('hi');
      case 'gu':
        return const Locale('gu');
      case 'te':
        return const Locale('te');
      default:
        return const Locale('en');
    }
  }

  /// Convert Locale -> languageCode
  static String getLanguageFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'ar';
      case 'fr':
        return 'fr';
      case 'hi':
        return 'hi';
      case 'gu':
        return 'gu';
      case 'te':
        return 'te';
      default:
        return 'en';
    }
  }
}
