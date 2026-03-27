import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/config/global.dart';
import 'user_details_event.dart';
import 'user_details_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {

  UserDataBloc() : super(UserDataInitial()) {
    on<SetUserData>(_onSetUserData);
    on<GetUserData>(_onGetUserData);
    on<ClearUserData>(_onClearUserData);
    on<CheckUserStatus>(_onCheckUserStatus);
    
    // Check user details status when bloc is created
    add(CheckUserStatus());
  }

  Future<void> _onSetUserData(SetUserData event, Emitter<UserDataState> emit,) async {
    try {
      emit(UserDataLoading());
      // Store in Hive
      await Global.setUserData(event.userData);

      // Emit stored state
      emit(UserDataStored(
        userData: Global.userData!,
      ));
    } catch (error) {
      log('UserDetailsBloc: Error storing user details data: $error');
      emit(UserDataInitial());
    }
  }

  Future<void> _onGetUserData(GetUserData event, Emitter<UserDataState> emit,) async {
    emit(UserDataLoading());
    try {
      final userData = Global.userData;
      if (userData!.token.isNotEmpty) {
        emit(UserDataRetrieved(
          userData: userData,
          isLoggedIn: true,
        ));
      } else {
        emit(const UserDataRetrieved(isLoggedIn: false));
      }
    } catch (error) {
      log('UserDetailsBloc: Error getting stored user details data: $error');
      emit(const UserDataRetrieved(isLoggedIn: false));
    }
  }

  Future<void> _onClearUserData(ClearUserData event, Emitter<UserDataState> emit,) async {
    emit(UserDataLoading());
    try {
      // Clear from Hive
      await Global.clearUserData();

      // Emit cleared state
      emit(const UserDataCleared());
    } catch (error) {
      log('UserDetailsBloc: Error clearing user details data: $error');
      emit(UserDataInitial());
    }
  }

  Future<void> _onCheckUserStatus(CheckUserStatus event, Emitter<UserDataState> emit,) async {
    emit(UserDataLoading());
    try {
      if (await isLoggedIn()) {
        final userData = Global.userData;
        
        if (userData!.token.isNotEmpty) {
          emit(UserStatusChecked(
            isLoggedIn: true,
            userData: userData,
          ));
        } else {
          emit(const UserStatusChecked(isLoggedIn: false));
        }
      } else {
        emit(const UserStatusChecked(isLoggedIn: false));
      }
    } catch (e, error) {
      log('UserDetailsBloc: Error checking user details status: $error');
      emit(const UserStatusChecked(isLoggedIn: false));
    }
  }

  Future<bool> isLoggedIn() async {
    return Global.token != null;
  }

}


