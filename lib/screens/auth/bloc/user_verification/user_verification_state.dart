
import 'package:equatable/equatable.dart';

abstract class UserVerificationState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserVerificationInitial extends UserVerificationState {}

class VerifyingUser extends UserVerificationState {}

class UserVerified extends UserVerificationState {
  final bool isUserVerified;
  UserVerified({required this.isUserVerified});
}

class UserVerificationFailed extends UserVerificationState {
  final String error;
  UserVerificationFailed({required this.error});
}