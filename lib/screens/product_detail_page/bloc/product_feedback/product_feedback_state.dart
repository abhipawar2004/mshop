part of 'product_feedback_bloc.dart';

abstract class ProductFeedbackState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductFeedbackInitial extends ProductFeedbackState {}

class ProductFeedbackLoading extends ProductFeedbackState {}

class ProductFeedbackLoaded extends ProductFeedbackState {}

class ProductFeedbackFailure extends ProductFeedbackState {
  final String error;
  ProductFeedbackFailure({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}