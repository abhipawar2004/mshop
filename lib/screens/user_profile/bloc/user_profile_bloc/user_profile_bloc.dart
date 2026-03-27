import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/user_profile/repo/user_profile_repo.dart';
import '../../model/user_profile_model.dart';
import 'package:hyper_local/config/global.dart';
part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<ResetUserProfile>(_onResetUserProfile);
  }

  final UserProfileRepository repository = UserProfileRepository();

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      // Check if user is actually logged in (has token)
      if (Global.userData == null || Global.userData!.token.isEmpty) {
        emit(UserProfileInitial());
        return;
      }

      final response = await repository.fetchUserProfile();
      if (response.first.success == true) {
        // Persist updated fields locally from fetch
        final current = Global.userData;
        final apiData = response.first.data;
        if (current != null && apiData != null) {
          final updated = current.copyWith(
            name: apiData.name ?? current.name,
            profileImage: apiData.profileImage ?? current.profileImage,
          );
          await Global.setUserData(updated);
        }
        emit(UserProfileLoaded(userData: response.first));
      }
    } catch (e) {
      emit(UserProfileFailed(error: e.toString()));
    }
  }

  Future<void> _onResetUserProfile(
      ResetUserProfile event, Emitter<UserProfileState> emit) async {
    emit(UserProfileInitial());
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final response = await repository.updateUserProfile(
        userName: event.userName,
        userImage: event.userImage,
      );

      if (response.first.success == true) {
        emit(UserProfileLoaded(userData: response.first));
      }
    } catch (e) {
      emit(UserProfileFailed(error: e.toString()));
    }
  }

}
