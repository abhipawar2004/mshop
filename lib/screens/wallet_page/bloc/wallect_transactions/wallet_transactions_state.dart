part of 'wallet_transactions_bloc.dart';

abstract class WalletTransactionsState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WalletTransactionsInitial extends WalletTransactionsState {}

class WalletTransactionsLoading extends WalletTransactionsState {}

class WalletTransactionsLoaded extends WalletTransactionsState {
  final List<Transaction> transactions;
  final bool hasReachedMax;
  final bool isLoadingMore;

  WalletTransactionsLoaded({
    required this.transactions,
    required this.hasReachedMax,
    required this.isLoadingMore,
  });

  @override
  List<Object> get props => [transactions, hasReachedMax, isLoadingMore];
}

class WalletTransactionsFailure extends WalletTransactionsState {
  final String error;
  WalletTransactionsFailure({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
