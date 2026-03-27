import 'package:equatable/equatable.dart';

import '../../model/user_data_model/user_data_model.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataStored extends UserDataState {
  final UserDataModel userData;

  const UserDataStored({
    required this.userData,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [userData];
}

class UserDataRetrieved extends UserDataState {
  final UserDataModel? userData;
  final bool isLoggedIn;

  const UserDataRetrieved({
    this.userData,
    required this.isLoggedIn,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [userData, isLoggedIn];
}

class UserDataCleared extends UserDataState {
  const UserDataCleared();
}

class UserStatusChecked extends UserDataState {
  final bool isLoggedIn;
  final String? token;
  final UserDataModel? userData;

  const UserStatusChecked({
    required this.isLoggedIn,
    this.token,
    this.userData,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [isLoggedIn, token, userData];
}


