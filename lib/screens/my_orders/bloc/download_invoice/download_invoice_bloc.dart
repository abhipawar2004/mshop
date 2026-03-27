import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/order_repo.dart';

part 'download_invoice_event.dart';
part 'download_invoice_state.dart';

class DownloadInvoiceBloc extends Bloc<DownloadInvoiceEvent, DownloadInvoiceState> {
  DownloadInvoiceBloc() : super(DownloadInvoiceInitial()) {
    on<DownloadInvoice>(_onDownloadInvoice);
  }
  final OrderRepository orderRepository = OrderRepository();

  Future<void> _onDownloadInvoice(
      DownloadInvoice event,
      Emitter<DownloadInvoiceState> emit,
      ) async {
    emit(DownloadInvoiceLoading());
    try {
      final filePath = await orderRepository.downloadInvoicePdf(event.invoiceUrl);
      emit(DownloadInvoiceSuccess(filePath: filePath));
      emit(DownloadInvoiceInitial());
    } catch (e) {
      emit(DownloadInvoiceFailure(error: e.toString()));
    }
  }
}
