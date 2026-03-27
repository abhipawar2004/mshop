part of 'validate_promo_code_bloc.dart';

abstract class ValidatePromoCodeState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ValidatePromoCodeInitial extends ValidatePromoCodeState {}

class ValidatePromoCodeLoading extends ValidatePromoCodeState {}

class ValidatePromoCodeLoaded extends ValidatePromoCodeState {}

class ValidatePromoCodeFailed extends ValidatePromoCodeState {
  final String error;
  ValidatePromoCodeFailed({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}