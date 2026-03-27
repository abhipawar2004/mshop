part of 'download_invoice_bloc.dart';

abstract class DownloadInvoiceState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DownloadInvoiceInitial extends DownloadInvoiceState {}

class DownloadInvoiceLoading extends DownloadInvoiceState {}

class DownloadInvoiceSuccess extends DownloadInvoiceState {
  final String filePath;
  DownloadInvoiceSuccess({required this.filePath});
  @override
  // TODO: implement props
  List<Object?> get props => [filePath];
}

class DownloadInvoiceFailure extends DownloadInvoiceState {
  final String error;
  DownloadInvoiceFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}