import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/wallet_page/model/prepare_wallet_recharge_model.dart';
import 'package:hyper_local/screens/wallet_page/repo/wallet_repository.dart';

part 'wallet_transactions_event.dart';
part 'wallet_transactions_state.dart';

class WalletTransactionsBloc extends Bloc<WalletTransactionsEvent, WalletTransactionsState> {
  WalletTransactionsBloc() : super(WalletTransactionsInitial()) {
    on<FetchWalletTransactions>(_onFetchWalletTransactions);
    on<FetchMoreWalletTransactions>(_onFetchMoreWalletTransactions);
  }

  final repository = WalletRepository();

  int currentPage = 1;
  int perPage = 10;
  bool hasReachedMax = false;
  bool isLoadingMore = false;

  /// ✅ Initial fetch - resets pagination
  Future<void> _onFetchWalletTransactions(FetchWalletTransactions event, Emitter<WalletTransactionsState> emit) async {
    emit(WalletTransactionsLoading());

    try {
      currentPage = 1;
      hasReachedMax = false;
      isLoadingMore = false;

      final response = await repository.fetchWalletTransactions(
        page: currentPage,
        perPage: perPage,
      );

      final transactions = List<Transaction>.from(
          response['data']['data'].map((data) => Transaction.fromJson(data))
      );

      // ✅ Update pagination state
      final currentTotal = int.parse(response['data']['current_page'].toString());
      final lastPageNum = int.parse(response['data']['last_page'].toString());
      hasReachedMax = currentTotal >= lastPageNum || transactions.length < perPage;

      if (response['success'] == true) {
        emit(WalletTransactionsLoaded(
          transactions: transactions,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      } else {
        emit(WalletTransactionsFailure(error: response['message']));
      }
    } catch (e) {
      emit(WalletTransactionsFailure(error: e.toString()));
    }
  }

  /// ✅ Load more transactions
  Future<void> _onFetchMoreWalletTransactions(FetchMoreWalletTransactions event, Emitter<WalletTransactionsState> emit) async {
    if (hasReachedMax || isLoadingMore) return;

    final currentState = state;
    if (currentState is WalletTransactionsLoaded) {
      isLoadingMore = true;

      try {
        currentPage += 1;

        final response = await repository.fetchWalletTransactions(
          page: currentPage,
          perPage: perPage,
        );

        final newTransactions = List<Transaction>.from(
            response['data']['data'].map((data) => Transaction.fromJson(data))
        );

        final currentTotal = int.parse(response['data']['current_page'].toString());
        final lastPageNum = int.parse(response['data']['last_page'].toString());
        hasReachedMax = currentTotal >= lastPageNum || newTransactions.length < perPage;

        final updatedTransactions = List<Transaction>.from(currentState.transactions);

        for (final newTransaction in newTransactions) {
          if (!updatedTransactions.any((existing) => existing.id == newTransaction.id)) {
            updatedTransactions.add(newTransaction);
          }
        }

        emit(WalletTransactionsLoaded(
          transactions: updatedTransactions,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));

      } catch (e) {
        currentPage -= 1;
        emit(WalletTransactionsFailure(error: e.toString()));
      } finally {
        isLoadingMore = false;
      }
    }
  }
}