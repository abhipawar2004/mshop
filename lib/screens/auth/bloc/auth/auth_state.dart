import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthFailed extends AuthState {
  final String error;
  AuthFailed({required this.error});
  @override
  List<Object?> get props => [error];
}

class RegistrationDataStored extends AuthState {
  final Map<String, dynamic> registrationData;
  final String phoneNumber;
  final String countryCode;
  final String isoCode;

  RegistrationDataStored({
    required this.registrationData,
    required this.phoneNumber,
    required this.countryCode,
    required this.isoCode,
  });

  @override
  List<Object?> get props => [registrationData, phoneNumber, countryCode, isoCode];
}

class LogoutUserSuccess extends AuthState {}

class DeleteUserSuccess extends AuthState {}

class OTPLoading extends AuthState {}

class VerifyingOTP extends AuthState {}

class OTPVerified extends AuthState {
  final String message;
  OTPVerified({required this.message});
  @override
  List<Object?> get props => [message];
}

class OTPFailed extends AuthState {
  final String error;
  OTPFailed({required this.error});
  @override
  List<Object?> get props => [error];
}

class LoginCodeSentProgress extends AuthState {
  final Map<String, dynamic>? registrationData;
  final String? phoneNumber;
  final String? countryCode;
  final String? isoCode;

  LoginCodeSentProgress({
    this.registrationData,
    this.phoneNumber,
    this.countryCode,
    this.isoCode,
  });

  @override
  List<Object?> get props => [registrationData, phoneNumber, countryCode, isoCode];
}

class LoginPhoneCodeSentState extends AuthState {
  final String? verificationId;
  final Map<String, dynamic>? registrationData;
  final String? phoneNumber;
  final String? countryCode;
  final String? isoCode;

  LoginPhoneCodeSentState({
    this.verificationId,
    this.registrationData,
    this.phoneNumber,
    this.countryCode,
    this.isoCode,
  });

  @override
  List<Object?> get props => [
    verificationId,
    registrationData,
    phoneNumber,
    countryCode,
    isoCode,
  ];
}

class SocialAuthSuccess extends AuthState {
  final bool newUser;
  final String userName;
  final String userEmail;

  SocialAuthSuccess({
    required this.newUser,
    required this.userName,
    required this.userEmail,
  });

  @override
  List<Object> get props => [newUser, userName, userEmail];
}