import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RegistrationHelper {
  static const String _keyRegistrationData = 'pending_registration_data';
  static const String _keyPhoneData = 'pending_phone_data';

  // Save registration data before Firebase redirect
  static Future<void> savePendingRegistration({
    required Map<String, dynamic> registrationData,
    required String phoneNumber,
    required String countryCode,
    required String isoCode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRegistrationData, jsonEncode(registrationData));
    await prefs.setString(_keyPhoneData, jsonEncode({
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'isoCode': isoCode,
    }));
  }

  static Future<Map<String, dynamic>?> getPendingRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    final regData = prefs.getString(_keyRegistrationData);
    final phoneData = prefs.getString(_keyPhoneData);

    if (regData != null && phoneData != null) {
      return {
        'registrationData': jsonDecode(regData),
        'phoneData': jsonDecode(phoneData),
      };
    }
    return null;
  }

  static Future<void> clearPendingRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRegistrationData);
    await prefs.remove(_keyPhoneData);
  }
}