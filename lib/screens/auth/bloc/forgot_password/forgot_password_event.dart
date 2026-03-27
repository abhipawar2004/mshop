part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
}

final class UserForgotPassword extends ForgotPasswordEvent {
  final String email;

  const UserForgotPassword({required this.email});

  @override
  List<Object?> get props => [email];
}
