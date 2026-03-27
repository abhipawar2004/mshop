part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfileModel userData;
  UserProfileLoaded({required this.userData});
  @override
  // TODO: implement props
  List<Object?> get props => [userData];
}

class UserProfileFailed extends UserProfileState {
  final String error;
  UserProfileFailed({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
