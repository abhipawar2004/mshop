
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/auth_repo.dart';
import 'user_verification_event.dart';
import 'user_verification_state.dart';

class UserVerificationBloc extends Bloc<UserVerificationEvent, UserVerificationState> {
  final AuthRepository _repository = AuthRepository();

  UserVerificationBloc() : super(UserVerificationInitial()) {
    on<VerifyUser>(_onVerifyUser);
    on<ResetVerification>(_onResetVerification);
  }

  Future<void> _onVerifyUser(VerifyUser event, Emitter<UserVerificationState> emit) async {
    emit(VerifyingUser());
    try {
      final response = await _repository.verifyUser(
        type: event.type,
          value: event.value,
      );

      final bool exists = response['data']?['exists'] ?? false;
      final bool success = response['success'] == true;

      if (success || !success) {
        emit(UserVerified(isUserVerified: exists));
      }
    } catch (e) {
      emit(UserVerificationFailed(error: e.toString()));
    }
  }

  Future<void> _onResetVerification(ResetVerification event, Emitter<UserVerificationState> emit) async {
    emit(UserVerificationInitial());
  }
}