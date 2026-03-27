part of 'delivery_boy_feedback_bloc.dart';

abstract class DeliveryBoyFeedbackState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DeliveryBoyFeedbackInitial extends DeliveryBoyFeedbackState {}

class DeliveryBoyFeedbackLoading extends DeliveryBoyFeedbackState {}

class DeliveryBoyFeedbackLoaded extends DeliveryBoyFeedbackState {}

class DeliveryBoyFeedbackFailure extends DeliveryBoyFeedbackState {
  final String error;
  DeliveryBoyFeedbackFailure({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
