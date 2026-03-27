part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchUserProfile extends UserProfileEvent {}

class UpdateUserProfile extends UserProfileEvent {
  final String userName;
  final File? userImage;

  UpdateUserProfile({required this.userName, this.userImage});

  @override
  // TODO: implement props
  List<Object?> get props => [userName, userImage];
}

class DeleteUser extends UserProfileEvent {}

class ResetUserProfile extends UserProfileEvent {}
