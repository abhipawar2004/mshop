part of 'seller_feedback_bloc.dart';

abstract class SellerFeedbackState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SellerFeedbackInitial extends SellerFeedbackState {}

class SellerFeedbackLoading extends SellerFeedbackState {}

class SellerFeedbackLoaded extends SellerFeedbackState {}

class SellerFeedbackFailure extends SellerFeedbackState {
  final String error;
  SellerFeedbackFailure({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}