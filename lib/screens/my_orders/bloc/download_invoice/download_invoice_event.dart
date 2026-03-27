part of 'download_invoice_bloc.dart';

abstract class DownloadInvoiceEvent extends Equatable {}

class DownloadInvoice extends DownloadInvoiceEvent{
  final String invoiceUrl;
  DownloadInvoice({required this.invoiceUrl});
  @override
  // TODO: implement props
  List<Object?> get props => [invoiceUrl];
}