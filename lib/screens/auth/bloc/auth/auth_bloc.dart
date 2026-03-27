import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/model/user_data_model/user_data_model.dart';
import 'package:hyper_local/screens/auth/repo/auth_repo.dart';
import '../../../../bloc/user_details_bloc/user_details_bloc.dart';
import '../../../../bloc/user_details_bloc/user_details_event.dart';
import '../../model/auth_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository = AuthRepository();
  final UserDataBloc _userDetailBloc;

  Map<String, dynamic>? _pendingRegistrationData;
  String? _pendingPhoneNumber;
  String? _pendingCountryCode;
  String? _pendingIsoCode;

  AuthBloc(this._userDetailBloc) : super(AuthInitial()) {
    on<LoginRequest>(_onLoginRequest);
    on<RegisterRequest>(_onRegisterRequest);
    on<LogoutUserRequest>(_onLogoutUserRequest);
    on<DeleteUserRequest>(_onDeleteUserRequest);
    on<SendOtpToPhoneEvent>(_onSendOtpToPhone);
    on<VerifySentOtp>(_onVerifySentOtp);
    on<OnPhoneOtpSend>(_onPhoneOtpSent);
    on<OnPhoneAuthVerificationCompleted>(_onPhoneAuthVerified);
    on<ResendOtpRequest>(_onResendOtp);
    on<AuthFailureEvent>(_onAuthFailureEvent);
    on<SocialAuthRequest>(_onSocialAuthRequest);
    on<GoogleLoginRequest>(_onGoogleLoginRequest);
    on<AppleLoginRequest>(_onAppleLoginRequest);
    on<StoreRegistrationDataEvent>(_onStoreRegistrationData);
    on<ClearRegistrationDataEvent>(_onClearRegistrationData);
    on<DeleteUserAccount>(_onDeleteUserAccount);
  }

  Future<void> _onStoreRegistrationData(
    StoreRegistrationDataEvent event,
    Emitter<AuthState> emit,
  ) async {
    _pendingRegistrationData = event.registrationData;
    _pendingPhoneNumber = event.phoneNumber;
    _pendingCountryCode = event.countryCode;
    _pendingIsoCode = event.isoCode;

    log('✅ Registration data stored in bloc');
    emit(RegistrationDataStored(
      registrationData: event.registrationData,
      phoneNumber: event.phoneNumber,
      countryCode: event.countryCode,
      isoCode: event.isoCode,
    ));
  }

  Map<String, dynamic>? getPendingRegistrationData() =>
      _pendingRegistrationData;

  String? getPendingPhoneNumber() => _pendingPhoneNumber;
  String? getPendingCountryCode() => _pendingCountryCode;
  String? getPendingIsoCode() => _pendingIsoCode;

  Future<void> _onClearRegistrationData(
    ClearRegistrationDataEvent event,
    Emitter<AuthState> emit,
  ) async {
    _pendingRegistrationData = null;
    _pendingPhoneNumber = null;
    _pendingCountryCode = null;
    _pendingIsoCode = null;
    log('🗑️ Registration data cleared from bloc');
  }

  Future<void> _onLoginRequest(
    LoginRequest event,
    Emitter<AuthState> emit,
  ) async {
    log('[AUTH_BLOC] LoginRequest received with payload: ${{
      'email': event.email ?? '',
      'mobile': event.phoneNumber ?? '',
      'passwordLength': event.password.length,
    }}');
    print('[AUTH_BLOC] LoginRequest received with payload: ${{
      'email': event.email ?? '',
      'mobile': event.phoneNumber ?? '',
      'passwordLength': event.password.length,
    }}');

    emit(AuthLoading());
    try {
      final response = await _repository.login(
        email: event.email ?? '',
        phoneNumber: event.phoneNumber ?? '',
        password: event.password,
      );

      log('[AUTH_BLOC] Login API parsed response: ${response.first.toJson()}');
      print(
          '[AUTH_BLOC] Login API parsed response: ${response.first.toJson()}');

      if (response.first.success == true) {
        final userData = response.first.data!;
        _userDetailBloc.add(SetUserData(UserDataModel(
          token: response.first.accessToken ?? '',
          userId: userData.id.toString(),
          name: userData.name ?? '',
          email: userData.email ?? '',
          mobile: userData.mobile ?? '',
          country: userData.country ?? '',
          iso2: userData.iso2 ?? '',
          profileImage: userData.profileImage ?? '',
          referralCode: userData.referralCode ?? '',
          language: 'en',
        )));

        log('[AUTH_BLOC] Login success. message=${response.first.message} userId=${userData.id}');
        print(
            '[AUTH_BLOC] Login success. message=${response.first.message} userId=${userData.id}');
        emit(
            AuthSuccess(message: response.first.message ?? 'Login successful'));
      } else {
        log('[AUTH_BLOC] Login failed from API. message=${response.first.message}');
        print(
            '[AUTH_BLOC] Login failed from API. message=${response.first.message}');
        emit(AuthFailed(error: response.first.message ?? 'Login failed'));
      }
    } catch (e) {
      log('[AUTH_BLOC] Login exception: $e');
      print('[AUTH_BLOC] Login exception: $e');
      emit(AuthFailed(error: e.toString()));
    }
  }

  Future<void> _onRegisterRequest(
    RegisterRequest event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _repository.register(
        name: event.name,
        email: event.email,
        mobile: event.mobile,
        country: event.country,
        iso2: event.iso2,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );

      if (response.first.success == true) {
        final userData = response.first.data!;
        _userDetailBloc.add(SetUserData(UserDataModel(
          token: response.first.accessToken ?? '',
          userId: userData.id.toString(),
          name: userData.name ?? '',
          email: userData.email ?? '',
          mobile: userData.mobile ?? '',
          country: userData.country ?? '',
          iso2: userData.iso2 ?? '',
          profileImage: userData.profileImage ?? '',
          referralCode: userData.referralCode ?? '',
          language: 'en',
        )));
        emit(AuthSuccess(
            message: response.first.message ?? 'Register successful'));
      } else {
        String errorMessage = response.first.message ?? 'Register failed';

        if (errorMessage
            .toLowerCase()
            .contains('mobile has already been taken')) {
          errorMessage =
              'This mobile number is already registered. Please use a different number or login.';
        }

        emit(AuthFailed(error: errorMessage));
      }
    } catch (e) {
      emit(AuthFailed(error: e.toString()));
    }
  }

  Future<void> _onLogoutUserRequest(
    LogoutUserRequest event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await FirebaseAuth.instance.signOut();
      await _repository.logout();
      _userDetailBloc.add(ClearUserData());

      _pendingRegistrationData = null;
      _pendingPhoneNumber = null;
      _pendingCountryCode = null;
      _pendingIsoCode = null;
      emit(LogoutUserSuccess());
    } catch (e) {
      emit(AuthFailed(error: e.toString()));
    }
  }

  Future<void> _onDeleteUserRequest(
    DeleteUserRequest event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.delete();
      _userDetailBloc.add(ClearUserData());
      _pendingRegistrationData = null;
      _pendingPhoneNumber = null;
      _pendingCountryCode = null;
      _pendingIsoCode = null;
      emit(DeleteUserSuccess());
    } catch (e) {
      emit(AuthFailed(error: e.toString()));
    }
  }

  Future<void> _onSendOtpToPhone(
    SendOtpToPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoginCodeSentProgress(
      registrationData: _pendingRegistrationData,
      phoneNumber: _pendingPhoneNumber,
      countryCode: _pendingCountryCode,
      isoCode: _pendingIsoCode,
    ));
    try {
      await _verifyPhoneNumber(
        countryCode: event.countryCode,
        phoneNumber: event.number,
        isoCode: event.isoCode,
      );
    } catch (e) {
      log('OTP Send Failed: $e');
      emit(AuthFailed(error: e.toString()));
    }
  }

  Future<void> _onVerifySentOtp(
    VerifySentOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(VerifyingOTP());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otpCode,
      );
      add(OnPhoneAuthVerificationCompleted(
        credential: credential,
        countryCode: event.countryCode,
        number: event.phoneNumber,
        isoCode: event.isoCode,
      ));
    } catch (e) {
      emit(AuthFailed(error: e.toString()));
    }
  }

  void _onPhoneOtpSent(OnPhoneOtpSend event, Emitter<AuthState> emit) {
    log('📱 Emitting LoginPhoneCodeSentState with ID: ${event.verificationId}');
    emit(LoginPhoneCodeSentState(
      verificationId: event.verificationId,
      registrationData: _pendingRegistrationData,
      phoneNumber: _pendingPhoneNumber,
      countryCode: _pendingCountryCode,
      isoCode: _pendingIsoCode,
    ));
  }

  Future<void> _onPhoneAuthVerified(
    OnPhoneAuthVerificationCompleted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final credential = event.credential;
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final token = await userCredential.user?.getIdToken(true);

      log('Phone Auth Success | Token: $token | Number: ${event.number}');

      emit(OTPVerified(message: 'OTP Verified'));
    } catch (e, s) {
      log('Phone verification failed: $e', stackTrace: s);
      emit(AuthFailed(error: e.toString()));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpRequest event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _verifyPhoneNumber(
        countryCode: event.countryCode,
        phoneNumber: event.phoneNumber,
        isoCode: event.isoCode,
      );
    } catch (e) {
      emit(AuthFailed(error: 'Please wait before resending.'));
    }
  }

  Future<void> _verifyPhoneNumber({
    required String countryCode,
    required String phoneNumber,
    required String isoCode,
  }) async {
    final fullNumber = countryCode + phoneNumber;
    log('Verifying phone: $fullNumber | ISO: $isoCode');

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: fullNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        add(OnPhoneAuthVerificationCompleted(
          credential: credential,
          countryCode: countryCode,
          number: phoneNumber,
          isoCode: isoCode,
        ));
      },
      verificationFailed: (FirebaseAuthException e) {
        log('Verification failed: ${e.message}');
        add(AuthFailureEvent(error: e.message ?? 'Verification failed'));
      },
      codeSent: (String verificationId, int? resendToken) {
        log('✅ OTP Code Sent! VerificationId: $verificationId');
        add(OnPhoneOtpSend(
            verificationId: verificationId, resendToken: resendToken));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('Auto retrieval timeout: $verificationId');
      },
      timeout: const Duration(seconds: 120),
    );
  }

  Future<void> _onAuthFailureEvent(
    AuthFailureEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthFailed(error: event.error));
  }

  Future<void> _onSocialAuthRequest(
    SocialAuthRequest event,
    Emitter<AuthState> emit,
  ) async {
    try {
      log('🧭 [AUTH_BLOC] SocialAuthRequest: ${{
        'isApple': event.isApple,
        'firebaseToken': event.firebaseToken,
      }}');

      final response = await _repository.socialAuth(
          firebaseToken: event.firebaseToken, isApple: event.isApple);
      if (response['success'] == false &&
          response['data']?['new_user'] == true) {
        emit(SocialAuthSuccess(
          newUser: response['data']['new_user'] != null
              ? response['data']['new_user'] ?? true
              : true,
          userName: response['data']['name'] != null
              ? response['data']['name'] ?? ''
              : '',
          userEmail: response['data']['email'] != null
              ? response['data']['email'] ?? ''
              : '',
        ));
      } else if (response['success'] == true) {
        List<AuthModel> userData = [];
        userData.add(AuthModel.fromJson(response));
        final user = userData.first.data!;

        _userDetailBloc.add(SetUserData(UserDataModel(
          token: userData.first.accessToken ?? '',
          userId: user.id.toString(),
          name: user.name ?? '',
          email: user.email ?? '',
          mobile: user.mobile ?? '',
          country: user.country ?? '',
          iso2: user.iso2 ?? '',
          profileImage: user.profileImage ?? '',
          referralCode: user.referralCode ?? '',
          language: 'en',
        )));
        emit(
            AuthSuccess(message: userData.first.message ?? 'Login successful'));
      } else {
        emit(AuthFailed(
            error: response['message']?.toString() ?? 'Social login failed'));
      }
    } catch (e) {
      emit(AuthFailed(error: e.toString()));
    }
  }

  Future<void> _onGoogleLoginRequest(
    GoogleLoginRequest event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      log('🧭 [AUTH_BLOC] GoogleLoginRequest received');
      print('🧭 [AUTH_BLOC] GoogleLoginRequest received');
      String firebaseUserToken = await _repository.googleLogin();
      log('Firebase token via google  $firebaseUserToken');
      print('🧭 [AUTH_BLOC] Firebase token via google: $firebaseUserToken');
      if (firebaseUserToken.trim().isEmpty) {
        log('🧭 [AUTH_BLOC] Empty Firebase token, reverting to AuthInitial');
        print('🧭 [AUTH_BLOC] Empty Firebase token, reverting to AuthInitial');
        emit(AuthInitial());
        return;
      }
      log('🧭 [AUTH_BLOC] Dispatching SocialAuthRequest for Google');
      print('🧭 [AUTH_BLOC] Dispatching SocialAuthRequest for Google');
      add(SocialAuthRequest(firebaseToken: firebaseUserToken, isApple: false));
    } catch (e) {
      print('🧭 [AUTH_BLOC] Google login failed: $e');
      emit(AuthFailed(error: e.toString()));
    }
  }

  Future<void> _onAppleLoginRequest(
    AppleLoginRequest event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      String firebaseUserToken = await _repository.appleLogin();
      log('Firebase token via apple  $firebaseUserToken');
      if (firebaseUserToken.trim().isEmpty) {
        emit(AuthInitial());
        return;
      }
      add(SocialAuthRequest(firebaseToken: firebaseUserToken, isApple: true));
    } catch (e) {
      emit(AuthFailed(error: e.toString()));
    }
  }

  Future<void> _onDeleteUserAccount(
      DeleteUserAccount event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _repository.deleteUser();
      if (response['success'] == true) {
        emit(DeleteUserSuccess());
      }
    } catch (e) {
      emit(AuthFailed(error: e.toString()));
    }
  }
}
