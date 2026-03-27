import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/wallet_page/repo/wallet_repository.dart';

part 'prepare_recharge_event.dart';
part 'prepare_recharge_state.dart';

class PrepareRechargeBloc extends Bloc<PrepareRechargeEvent, PrepareRechargeState> {
  PrepareRechargeBloc() : super(PrepareRechargeInitial()) {
    on<PrepareRecharge>(_onPrepareRecharge);
  }

  final WalletRepository repository = WalletRepository();

  Future<void> _onPrepareRecharge(PrepareRecharge event, Emitter<PrepareRechargeState> emit) async {
    emit(PrepareRechargeLoading());
    try{
      final response = await repository.prepareRecharge(
        amount: event.amount,
        paymentMethod: event.paymentMethod,
        description: event.description
      );

      if(response.first.success!){
        emit(PrepareRechargeSuccess(
          orderId: response.first.data!.paymentResponse!.id!,
          amount: response.first.data!.paymentResponse!.amountDue.toString(),
          currency: response.first.data!.paymentResponse!.currency ?? ''
        ));
      } else {
        emit(PrepareRechargeFailure(error: response.first.message ?? ''));
      }
    }catch(e) {
      emit(PrepareRechargeFailure(error: e.toString()));
    }
  }
}
