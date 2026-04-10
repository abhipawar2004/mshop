import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/notification_service.dart';
import 'package:hyper_local/screens/auth/model/auth_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _androidClientId = AppConstant.androidClientId;
  final String _serverClientId = AppConstant.serverClientId;

  String _maskTokenForLog(String? token) {
    if (token == null || token.isEmpty) return '<empty>';
    if (token.length <= 20) return '<redacted:${token.length} chars>';
    return '${token.substring(0, 10)}...${token.substring(token.length - 10)} '
        '(${token.length} chars)';
  }

  dynamic _sanitizeInternalErrorForLog(dynamic data) {
    if (data is Map<String, dynamic>) {
      final sanitized = Map<String, dynamic>.from(data);
      final nested = sanitized['data'];
      if (nested is Map<String, dynamic>) {
        final nestedSanitized = Map<String, dynamic>.from(nested);
        final errorText = nestedSanitized['error']?.toString() ?? '';
        final lower = errorText.toLowerCase();
        if (lower.contains('splfileobject::__construct') ||
            lower.contains('/var/www/') ||
            lower.contains('service-account-file.json') ||
            lower.contains('failed to open stream')) {
          nestedSanitized['error'] =
              'Internal server configuration error (redacted)';
          sanitized['data'] = nestedSanitized;
        }
      }
      return sanitized;
    }

    return data;
  }

  void _debugAuth(String message) {
    log(message);
    print(message);
  }

  String deviceType = '';
  String getDeviceType() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else {
      return 'unknown';
    }
  }

  Future<List<AuthModel>> login({
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      String? fcmToken = await getFCMToken();
      final payload = {
        if (email.isNotEmpty) 'email': email,
        if (phoneNumber.isNotEmpty)
          'mobile': phoneNumber.isEmpty ? 0 : int.parse(phoneNumber),
        'password': password,
        'fcm_token': fcmToken,
        'device_type': getDeviceType()
      };

      final sanitizedPayload = {
        ...payload,
        if (payload['password'] != null)
          'password': '***(${password.length} chars)***',
      };

      _debugAuth('[LOGIN_API] URL: ${ApiRoutes.loginApi}');
      _debugAuth('[LOGIN_API] PAYLOAD: ${jsonEncode(sanitizedPayload)}');

      final response = await AppConstant.apiBaseHelper
          .postAPICall(ApiRoutes.loginApi, payload);

      _debugAuth('[LOGIN_API] STATUS: ${response.statusCode}');
      _debugAuth('[LOGIN_API] RESPONSE: ${jsonEncode(response.data)}');

      if (response.data['success'] == true) {
        List<AuthModel> userData = [];
        userData.add(AuthModel.fromJson(response.data));
        return userData;
      } else {
        // API returned failure — throw a meaningful exception with the message
        String message = response.data['message']?.toString() ?? 'Login failed';
        throw ApiException(message);
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<AuthModel>> register(
      {required String name,
      required String email,
      required String mobile,
      required String country,
      required String iso2,
      required String password,
      required String confirmPassword,
      required String type,
      required String gstNo}) async {
    try {
      String? fcmToken = await getFCMToken();
      final response =
          await AppConstant.apiBaseHelper.postAPICall(ApiRoutes.registerApi, {
        'name': name,
        'email': email,
        'mobile': mobile,
        'password': password,
        'country': country,
        'iso_2': iso2,
        'password_confirmation': confirmPassword,
        'fcm_token': fcmToken,
        'device_type': getDeviceType(),
        'type': type,
        'gst_no': gstNo,
      });

      if (response.data['success'] == true) {
        List<AuthModel> userData = [];
        userData.add(AuthModel.fromJson(response.data));
        return userData;
      }
      return [];
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> verifyUser(
      {required String type, required String value}) async {
    try {
      final payload = {'type': type, 'value': value};
      _debugAuth('[VERIFY_USER_API] URL: ${ApiRoutes.verifyUserApi}');
      _debugAuth('[VERIFY_USER_API] PAYLOAD: ${jsonEncode(payload)}');
      _debugAuth(
          "[VERIFY_USER_API] CURL: curl --request POST '${ApiRoutes.verifyUserApi}' --header 'Content-Type: application/json' --header 'Accept: application/json' --data '${jsonEncode(payload)}'");

      final response = await AppConstant.apiBaseHelper.postAPICall(
        ApiRoutes.verifyUserApi,
        payload,
        includeAuthorization: false,
      );

      _debugAuth('[VERIFY_USER_API] STATUS: ${response.statusCode}');
      _debugAuth('[VERIFY_USER_API] RESPONSE: ${jsonEncode(response.data)}');

      return response.data;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      final payload = <String, dynamic>{};

      log('🔵 LOGOUT API PAYLOAD: ${jsonEncode(payload)}');
      log('🔵 LOGOUT API URL: ${ApiRoutes.logoutApi}');

      final response = await AppConstant.apiBaseHelper
          .postAPICall(ApiRoutes.logoutApi, payload);

      log('🟢 LOGOUT API RESPONSE: ${jsonEncode(response.data)}');
    } catch (e) {
      log('🔴 LOGOUT API ERROR: $e');
      // Don't throw exception on logout failure - user should still be able to log out locally
      // The backend logout is a courtesy call; Firebase sign-out is what matters
    }
  }

  Future<String> sendOTP({required String phoneNumber}) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          throw ApiException(e.message ?? 'Failed to send OTP');
        },
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );

      return '';
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, String>> sendOTPWithCallback({
    required String phoneNumber,
    Function(String verificationId)? onCodeSent,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final Completer<String> completer = Completer<String>();

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          completer.completeError(e.message ?? 'Failed to send OTP');
        },
        codeSent: (String verificationId, int? resendToken) {
          completer.complete(verificationId);
          if (onCodeSent != null) {
            onCodeSent(verificationId);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );

      final verificationId = await completer.future;
      return {'verificationId': verificationId};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<bool> verifyOTP(
      {required String verificationId, required String otpCode}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> socialAuth({
    required String firebaseToken,
    required bool isApple,
  }) async {
    try {
      String? fcmToken = await getFCMToken();
      String? apiUrl = '';
      if (isApple) {
        apiUrl = ApiRoutes.appleAuthApi;
      } else {
        apiUrl = ApiRoutes.googleAuthApi;
      }

      final payload = {
        'idToken': firebaseToken,
        'device_type': getDeviceType(),
        'fcm_token': fcmToken,
      };

      final payloadForLog = {
        ...payload,
        'idToken': _maskTokenForLog(firebaseToken),
      };

      _debugAuth('🛰️ [SOCIAL_AUTH] API URL: $apiUrl');
      _debugAuth('🛰️ [SOCIAL_AUTH] PAYLOAD: ${jsonEncode(payloadForLog)}');

      final response =
          await AppConstant.apiBaseHelper.postAPICall(apiUrl, payload);
      _debugAuth('🛰️ [SOCIAL_AUTH] STATUS: ${response.statusCode}');
      final responseForLog = _sanitizeInternalErrorForLog(response.data);
      _debugAuth('🛰️ [SOCIAL_AUTH] RESPONSE: ${jsonEncode(responseForLog)}');
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<String> googleLogin() async {
    try {
      _debugAuth('🟢 [GOOGLE_LOGIN] Starting Google Sign-In');

      final googleSignIn = GoogleSignIn.instance;

      // On Android v7, provide both client IDs explicitly.
      await googleSignIn.initialize(
        clientId: _androidClientId,
        serverClientId: _serverClientId,
      );
      _debugAuth(
          '🟢 [GOOGLE_LOGIN] GoogleSignIn initialized with clientId=$_androidClientId serverClientId=$_serverClientId');

      // Trigger the Google Sign-In flow
      final googleUser = await googleSignIn.authenticate();

      _debugAuth(
          '🟢 [GOOGLE_LOGIN] authenticate() completed, googleUser.id = ${googleUser.id}');

      _debugAuth('🟢 [GOOGLE_LOGIN] GOOGLE USER: ${jsonEncode({
            'id': googleUser.id,
            'email': googleUser.email,
            'displayName': googleUser.displayName,
            'photoUrl': googleUser.photoUrl,
          })}');

      if (googleUser.id.isEmpty) {
        throw ApiException('User cancelled the login');
      }

      final googleAuth = googleUser.authentication;
      _debugAuth('🟢 [GOOGLE_LOGIN] GOOGLE AUTH: ${jsonEncode({
            'idToken': googleAuth.idToken,
          })}');

      // Try to get access token with timeout (it may fail or hang on some devices)
      String? accessToken;
      try {
        final authClient = googleSignIn.authorizationClient;
        final authorization = await authClient.authorizationForScopes(
            ['email']).timeout(const Duration(seconds: 5));
        accessToken = authorization?.accessToken;
        _debugAuth('🟢 [GOOGLE_LOGIN] Got access token: $accessToken');
      } catch (e) {
        _debugAuth(
            '🟠 [GOOGLE_LOGIN] Failed to get access token: $e. Continuing with idToken only.');
      }

      _debugAuth('🟢 [GOOGLE_LOGIN] AUTHORIZATION: ${jsonEncode({
            'accessToken': accessToken,
          })}');

      if ((accessToken == null || accessToken.isEmpty) &&
          (googleAuth.idToken == null || googleAuth.idToken!.isEmpty)) {
        throw ApiException('Google login did not return valid credentials');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: googleAuth.idToken,
      );
      _debugAuth('🟢 [GOOGLE_LOGIN] FIREBASE CREDENTIAL INPUT: ${jsonEncode({
            'credentialType': 'GoogleAuthProvider',
            'accessToken': accessToken,
            'idToken': googleAuth.idToken,
          })}');

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      _debugAuth('🟢 [GOOGLE_LOGIN] FIREBASE USER: ${jsonEncode({
            'uid': user?.uid,
            'email': user?.email,
            'displayName': user?.displayName,
            'phoneNumber': user?.phoneNumber,
            'photoURL': user?.photoURL,
            'isAnonymous': user?.isAnonymous,
          })}');
      if (user != null) {
        final IdTokenResult idTokenResult = await user.getIdTokenResult();
        final String? firebaseIdToken = idTokenResult.token;
        final idTokenResultLog = jsonEncode(
          {
            'token': firebaseIdToken,
            'authTime': idTokenResult.authTime,
            'expirationTime': idTokenResult.expirationTime,
            'issuedAtTime': idTokenResult.issuedAtTime,
            'signInProvider': idTokenResult.signInProvider,
            'claims': idTokenResult.claims,
          },
          toEncodable: (obj) {
            if (obj is DateTime) return obj.toIso8601String();
            return obj.toString();
          },
        );
        _debugAuth(
            '🟢 [GOOGLE_LOGIN] FIREBASE ID TOKEN RESULT: $idTokenResultLog');
        if (firebaseIdToken != null) {
          return firebaseIdToken;
        } else {
          throw ApiException('Failed to get token');
        }
      } else {
        throw ApiException('Failed to sign in');
      }
    } catch (e, stackTrace) {
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('cancel') ||
          errorMessage.contains('canceled')) {
        _debugAuth(
            '🟠 [GOOGLE_LOGIN] google_sign_in returned cancellation. Trying Firebase provider fallback...');
        final String fallbackToken =
            await _googleLoginFirebaseProviderFallback();
        if (fallbackToken.isNotEmpty) {
          return fallbackToken;
        }
        _debugAuth('🟠 [GOOGLE_LOGIN] User cancelled login');
        return '';
      } else {
        _debugAuth('🔴 [GOOGLE_LOGIN] EXCEPTION: ${e.toString()}');
        _debugAuth('🔴 [GOOGLE_LOGIN] STACK TRACE: $stackTrace');
        _debugAuth('🔴 [GOOGLE_LOGIN] Throwing ApiException');
        throw ApiException(e.toString());
      }
    }
  }

  Future<String> _googleLoginFirebaseProviderFallback() async {
    try {
      if (!Platform.isAndroid) {
        return '';
      }

      final googleProvider = GoogleAuthProvider();
      final userCredential = await _auth.signInWithProvider(googleProvider);
      final user = userCredential.user;
      if (user == null) {
        return '';
      }

      final idTokenResult = await user.getIdTokenResult(true);
      final firebaseIdToken = idTokenResult.token;
      _debugAuth('🟢 [GOOGLE_LOGIN] Fallback sign-in provider: '
          '${idTokenResult.signInProvider}, tokenPresent=${firebaseIdToken != null}');
      return firebaseIdToken ?? '';
    } catch (e, stackTrace) {
      final message = e.toString().toLowerCase();
      _debugAuth('🟠 [GOOGLE_LOGIN] Fallback failed: $e');
      _debugAuth('🟠 [GOOGLE_LOGIN] Fallback stack: $stackTrace');

      if (message.contains('invalid-cert-hash')) {
        throw ApiException(
            'Google Sign-In is not configured for this app signing key. Add this app\'s SHA-1 and SHA-256 fingerprints to Firebase Android app (package com.app.mastrokart), then download and replace android/app/google-services.json.');
      }

      return '';
    }
  }

  Future<String> appleLogin() async {
    try {
      // Trigger Apple Sign In
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create Firebase credential from Apple
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with the credential
      final userCredential = await _auth.signInWithCredential(oauthCredential);
      await userCredential.user!.getIdToken(true);

      final user = userCredential.user;
      if (user != null) {
        // Get Firebase ID token (this is the JWT you likely want, similar to Google's accessToken in your example)
        final idTokenResult = await user.getIdTokenResult();
        final String? accessToken = idTokenResult.token;

        if (accessToken != null) {
          return accessToken;
        } else {
          throw ApiException('Failed to get Firebase ID token');
        }
      } else {
        throw ApiException('Failed to sign in with Apple');
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      // Handle Apple-specific errors (e.g., user cancelled)
      if (e.code == AuthorizationErrorCode.canceled) {
        throw ApiException('User cancelled the Apple login');
      } else {
        throw ApiException('Apple login failed: ${e.message}');
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await AppConstant.apiBaseHelper
          .postAPICall(ApiRoutes.forgotPasswordApi, {'email': email});

      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> deleteUser() async {
    try {
      final response = await AppConstant.apiBaseHelper
          .getAPICall(ApiRoutes.deleteUserApi, {});
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      throw ApiException('Failed to get user profile');
    }
  }
}
