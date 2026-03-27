import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/cart_product_item.dart';

part 'attachment_event.dart';
part 'attachment_state.dart';

class AttachmentBloc extends Bloc<AttachmentEvent, AttachmentState> {
  AttachmentBloc() : super(const AttachmentInitial()) {
    on<AddOrUpdateAttachment>(_onAddOrUpdate);
    on<RemoveAttachment>(_onRemove);
    on<ClearAllAttachments>(_onClearAll);
  }

  Future<void> _onAddOrUpdate(
      AddOrUpdateAttachment event,
      Emitter<AttachmentState> emit,
      ) async {
    final current = state.attachments;
    final updated = Map<int, CartItemAttachment?>.from(current)
      ..[event.productId] = event.attachment;

    emit(AttachmentLoaded(attachments: updated));
  }

  Future<void> _onRemove(
      RemoveAttachment event,
      Emitter<AttachmentState> emit,
      ) async {
    final current = state.attachments;
    final updated = Map<int, CartItemAttachment?>.from(current)
      ..remove(event.productId);

    emit(AttachmentLoaded(attachments: updated));
  }

  Future<void> _onClearAll(
      ClearAllAttachments event,
      Emitter<AttachmentState> emit,
      ) async {
    emit(const AttachmentLoaded(attachments: {}));
  }
}