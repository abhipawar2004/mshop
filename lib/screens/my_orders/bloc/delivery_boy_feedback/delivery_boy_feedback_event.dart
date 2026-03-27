part of 'delivery_boy_feedback_bloc.dart';

abstract class DeliveryBoyFeedbackEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddDeliveryBoyFeedback extends DeliveryBoyFeedbackEvent {
  final int deliveryBoyId;
  final int orderId;
  final String title;
  final String description;
  final int rating;

  AddDeliveryBoyFeedback({
    required this.deliveryBoyId,
    required this.orderId,
    required this.title,
    required this.description,
    required this.rating,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    deliveryBoyId,
    orderId,
    title,
    description,
    rating
  ];
}

class UpdateDeliveryBoyFeedback extends DeliveryBoyFeedbackEvent {
  final int feedbackId;
  final String title;
  final String description;
  final int rating;

  UpdateDeliveryBoyFeedback({
    required this.feedbackId,
    required this.title,
    required this.description,
    required this.rating,
  });

  @override
  List<Object?> get props => [
    feedbackId,
    title,
    description,
    rating
  ];
}

class DeleteDeliveryBoyFeedback extends DeliveryBoyFeedbackEvent {
  final int feedbackId;

  DeleteDeliveryBoyFeedback({
    required this.feedbackId,
  });

  @override
  List<Object?> get props => [feedbackId];
}