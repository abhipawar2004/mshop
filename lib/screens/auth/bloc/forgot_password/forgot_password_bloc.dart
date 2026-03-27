import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/auth/repo/auth_repo.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _repository = AuthRepository();

  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<UserForgotPassword>(_onForgotPassword);
  }

  Future<void> _onForgotPassword(
      UserForgotPassword event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());
    try {
      final response = await _repository.forgotPassword(event.email);

      final bool success = response['success'] ?? true;
      final String message = response['message'] ?? '';
      log('Success forgot password $success');
      if (success) {
        emit(ForgotPasswordSuccess(message: message));
      } else {
        emit(ForgotPasswordFailed(message: message));
      }
    } catch (e) {
      emit(ForgotPasswordFailed(message: e.toString()));
    }
  }
}
