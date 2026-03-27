import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequest extends AuthEvent {
  final String? email;
  final String? phoneNumber;
  final String password;
  LoginRequest({
    this.email,
    this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [email, phoneNumber, password];
}

class RegisterRequest extends AuthEvent {
  final String name;
  final String email;
  final String mobile;
  final String password;
  final String country;
  final String iso2;
  final String countryCode;
  final String completePhoneNumber;
  final String confirmPassword;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.country,
    required this.iso2,
    required this.countryCode,
    required this.completePhoneNumber,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [
    name,
    email,
    mobile,
    password,
    country,
    iso2,
    countryCode,
    completePhoneNumber,
    confirmPassword
  ];
}

class StoreRegistrationDataEvent extends AuthEvent {
  final Map<String, dynamic> registrationData;
  final String phoneNumber;
  final String countryCode;
  final String isoCode;

  StoreRegistrationDataEvent({
    required this.registrationData,
    required this.phoneNumber,
    required this.countryCode,
    required this.isoCode,
  });

  @override
  List<Object?> get props => [registrationData, phoneNumber, countryCode, isoCode];
}

class ClearRegistrationDataEvent extends AuthEvent {}

class LogoutUserRequest extends AuthEvent {}

class DeleteUserRequest extends AuthEvent {}

class SendOtpToPhoneEvent extends AuthEvent {
  final String number;
  final String countryCode;
  final String isoCode;

  SendOtpToPhoneEvent({
    required this.number,
    required this.countryCode,
    required this.isoCode,
  });

  @override
  List<Object?> get props => [number, countryCode, isoCode];
}

class OnPhoneOtpSend extends AuthEvent {
  final String verificationId;
  final int? resendToken;

  OnPhoneOtpSend({required this.verificationId, this.resendToken});

  @override
  List<Object?> get props => [verificationId, resendToken];
}

class ResendOtpRequest extends AuthEvent {
  final String phoneNumber;
  final String countryCode;
  final String isoCode;

  ResendOtpRequest({
    required this.phoneNumber,
    required this.countryCode,
    required this.isoCode,
  });

  @override
  List<Object?> get props => [phoneNumber, isoCode];
}

class VerifySentOtp extends AuthEvent {
  final String otpCode;
  final String verificationId;
  final String? name;
  final String? countryCode;
  final String? phoneNumber;
  final String? isoCode;

  VerifySentOtp({
    required this.otpCode,
    required this.verificationId,
    this.name,
    this.countryCode,
    this.phoneNumber,
    this.isoCode,
  });

  @override
  List<Object?> get props =>
      [otpCode, verificationId, name, countryCode, phoneNumber, isoCode];
}

class OnPhoneAuthErrorEvent extends AuthEvent {
  final String error;

  OnPhoneAuthErrorEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class OnPhoneAuthVerificationCompleted extends AuthEvent {
  final String? name;
  final AuthCredential credential;
  final String? number;
  final String? countryCode;
  final String? isoCode;

  OnPhoneAuthVerificationCompleted({
    required this.credential,
    this.name,
    this.number,
    this.countryCode,
    this.isoCode,
  });

  @override
  List<Object?> get props => [credential, name, number, countryCode, isoCode];
}

class AuthFailureEvent extends AuthEvent {
  final String error;

  AuthFailureEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class SocialAuthRequest extends AuthEvent {
  final String firebaseToken;
  final bool isApple;

  SocialAuthRequest({
    required this.firebaseToken,
    required this.isApple
  });

  @override
  List<Object?> get props => [firebaseToken, isApple];
}

class GoogleLoginRequest extends AuthEvent {}

class AppleLoginRequest extends AuthEvent {}

class DeleteUserAccount extends AuthEvent {}

