part of 'seller_feedback_bloc.dart';

abstract class SellerFeedbackEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddSellerFeedback extends SellerFeedbackEvent {
  final int sellerId;
  final int orderItemId;
  final String title;
  final String description;
  final int rating;

  AddSellerFeedback({
    required this.sellerId,
    required this.orderItemId,
    required this.title,
    required this.description,
    required this.rating,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    sellerId,
    orderItemId,
    title,
    description,
    rating
  ];
}

class UpdateSellerFeedback extends SellerFeedbackEvent {
  final int feedbackId;
  final String title;
  final String description;
  final int rating;

  UpdateSellerFeedback({
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

class DeleteSellerFeedback extends SellerFeedbackEvent {
  final int feedbackId;

  DeleteSellerFeedback({
    required this.feedbackId,
  });

  @override
  List<Object?> get props => [feedbackId];
}

class ResetSellerFeedback extends SellerFeedbackEvent {}