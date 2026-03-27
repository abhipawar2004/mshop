part of 'attachment_bloc.dart';

abstract class AttachmentState extends Equatable {
  const AttachmentState();

  Map<int, CartItemAttachment?> get attachments => {};
}

class AttachmentInitial extends AttachmentState {
  const AttachmentInitial();

  @override
  List<Object> get props => [];
}

class AttachmentLoaded extends AttachmentState {
  @override
  final Map<int, CartItemAttachment?> attachments;

  const AttachmentLoaded({required this.attachments});

  @override
  List<Object> get props => [attachments];
}