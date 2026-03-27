part of 'attachment_bloc.dart';

abstract class AttachmentEvent extends Equatable {
  const AttachmentEvent();

  @override
  List<Object?> get props => [];
}

class AddOrUpdateAttachment extends AttachmentEvent {
  final int productId;
  final CartItemAttachment? attachment;

  const AddOrUpdateAttachment({
    required this.productId,
    this.attachment,
  });

  @override
  List<Object?> get props => [productId, attachment];
}

class RemoveAttachment extends AttachmentEvent {
  final int productId;

  const RemoveAttachment({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ClearAllAttachments extends AttachmentEvent {}