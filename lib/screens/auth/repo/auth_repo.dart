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
  final String _serverClientId = AppConstant.serverClientId;

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
      final response =
          await AppConstant.apiBaseHelper.postAPICall(ApiRoutes.loginApi, {
        if (email.isNotEmpty) 'email': email,
        if (phoneNumber.isNotEmpty)
          'mobile': phoneNumber.isEmpty ? 0 : int.parse(phoneNumber),
        'password': password,
        'fcm_token': fcmToken,
        'device_type': getDeviceType()
      });
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
      required String confirmPassword}) async {
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
        'device_type': getDeviceType()
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
      final response = await AppConstant.apiBaseHelper
          .postAPICall(ApiRoutes.verifyUserApi, {'type': type, 'value': value});
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
      throw ApiException('Failed to logout user');
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

      log('🛰️ [SOCIAL_AUTH] API URL: $apiUrl');
      log('🛰️ [SOCIAL_AUTH] PAYLOAD: ${jsonEncode(payload)}');

      final response =
          await AppConstant.apiBaseHelper.postAPICall(apiUrl, payload);
      log('🛰️ [SOCIAL_AUTH] STATUS: ${response.statusCode}');
      log('🛰️ [SOCIAL_AUTH] RESPONSE: ${jsonEncode(response.data)}');
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<String> googleLogin() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    try {
      await googleSignIn.initialize(serverClientId: _serverClientId);
      log('🟢 [GOOGLE_LOGIN] GoogleSignIn initialized');

      final GoogleSignInAccount googleUser =
          await googleSignIn.authenticate(scopeHint: ['email']);
      log('🟢 [GOOGLE_LOGIN] GOOGLE USER: ${jsonEncode({
            'id': googleUser.id,
            'email': googleUser.email,
            'displayName': googleUser.displayName,
            'photoUrl': googleUser.photoUrl,
          })}');
      if (googleUser.id.isEmpty) {
        throw ApiException('User cancelled the login');
      }
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      log('🟢 [GOOGLE_LOGIN] GOOGLE AUTH: ${jsonEncode({
            'idToken': googleAuth.idToken,
          })}');

      final authClient = googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);
      final String? accessToken = authorization?.accessToken;
      log('🟢 [GOOGLE_LOGIN] AUTHORIZATION: ${jsonEncode({
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
      log('🟢 [GOOGLE_LOGIN] FIREBASE CREDENTIAL INPUT: ${jsonEncode({
            'credentialType': 'GoogleAuthProvider',
            'accessToken': accessToken,
            'idToken': googleAuth.idToken,
          })}');

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      log('🟢 [GOOGLE_LOGIN] FIREBASE USER: ${jsonEncode({
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
        log('🟢 [GOOGLE_LOGIN] FIREBASE ID TOKEN RESULT: ${jsonEncode({
              'token': firebaseIdToken,
              'authTime': idTokenResult.authTime,
              'expirationTime': idTokenResult.expirationTime,
              'issuedAtTime': idTokenResult.issuedAtTime,
              'signInProvider': idTokenResult.signInProvider,
              'claims': idTokenResult.claims,
            })}');
        if (firebaseIdToken != null) {
          return firebaseIdToken;
        } else {
          throw ApiException('Failed to get token');
        }
      } else {
        throw ApiException('Failed to sign in');
      }
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('cancel') ||
          errorMessage.contains('canceled')) {
        return '';
      } else {
        // Any other error — treat as real failure
        throw ApiException(e.toString());
      }
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
      throw Exception(e.toString());
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
