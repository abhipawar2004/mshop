import 'package:equatable/equatable.dart';
import 'package:hyper_local/model/user_data_model/user_data_model.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SetUserData extends UserDataEvent {
  final UserDataModel userData;

  const SetUserData(this.userData);

  @override
  // TODO: implement props
  List<Object?> get props => [userData];
}

class GetUserData extends UserDataEvent {}

class ClearUserData extends UserDataEvent {}

class CheckUserStatus extends UserDataEvent {}


