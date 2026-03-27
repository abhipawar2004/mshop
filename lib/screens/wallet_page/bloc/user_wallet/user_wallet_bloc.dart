import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/wallet_page/model/prepare_wallet_recharge_model.dart';
import 'package:hyper_local/screens/wallet_page/repo/wallet_repository.dart';

part 'user_wallet_event.dart';
part 'user_wallet_state.dart';

class UserWalletBloc extends Bloc<UserWalletEvent, UserWalletState> {
  UserWalletBloc() : super(UserWalletInitial()) {
    on<FetchUserWallet>(_onFetchUserWallet);
  }

  final repository = WalletRepository();

  Future<void> _onFetchUserWallet(FetchUserWallet event, Emitter<UserWalletState> emit) async {
    emit(UserWalletLoading());
    try{
      final response = await repository.fetchUserWallet();
      emit(UserWalletLoaded(userWallet: response));
    }catch(e) {
      emit(UserWalletFailure(error: e.toString()));
    }
  }
}
