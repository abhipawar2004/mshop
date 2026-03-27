import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import '../../repo/auth_repo.dart';
import 'user_verification_event.dart';
import 'user_verification_state.dart';

class UserVerificationBloc
    extends Bloc<UserVerificationEvent, UserVerificationState> {
  final AuthRepository _repository = AuthRepository();

  void _debugVerification(String message) {
    log(message);
    print(message);
  }

  UserVerificationBloc() : super(UserVerificationInitial()) {
    on<VerifyUser>(_onVerifyUser);
    on<ResetVerification>(_onResetVerification);
  }

  Future<void> _onVerifyUser(
      VerifyUser event, Emitter<UserVerificationState> emit) async {
    _debugVerification(
        '[VERIFY_USER_BLOC] VerifyUser event received. type=${event.type} value=${event.value}');
    emit(VerifyingUser());
    try {
      final response = await _repository.verifyUser(
        type: event.type,
        value: event.value,
      );

      _debugVerification(
          '[VERIFY_USER_BLOC] Verify user API response: $response');

      final bool exists = response['data']?['exists'] ?? false;
      final bool success = response['success'] == true;

      _debugVerification(
          '[VERIFY_USER_BLOC] Parsed response. success=$success exists=$exists');

      if (success || !success) {
        emit(UserVerified(isUserVerified: exists));
      }
    } catch (e) {
      _debugVerification('[VERIFY_USER_BLOC] Verify user failed: $e');
      emit(UserVerificationFailed(error: e.toString()));
    }
  }

  Future<void> _onResetVerification(
      ResetVerification event, Emitter<UserVerificationState> emit) async {
    emit(UserVerificationInitial());
  }
}
