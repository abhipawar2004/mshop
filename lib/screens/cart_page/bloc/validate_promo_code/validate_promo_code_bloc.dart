import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/cart_page/repo/promo_code_repository.dart';

part 'validate_promo_code_event.dart';
part 'validate_promo_code_state.dart';

class ValidatePromoCodeBloc extends Bloc<ValidatePromoCodeEvent, ValidatePromoCodeState> {
  ValidatePromoCodeBloc() : super(ValidatePromoCodeInitial()) {
    on<ValidatePromoCodeRequest>(_onValidatePromoCodeRequest);
  }

  final PromoCodeRepository repository = PromoCodeRepository();
  String selectedPromoCode = '';

  Future<void> _onValidatePromoCodeRequest(ValidatePromoCodeRequest event, Emitter<ValidatePromoCodeState> emit) async {
    emit(ValidatePromoCodeLoading());
    try{
      final response = await repository.validatePromoCode(
        cartAmount: event.cartAmount!,
        deliveryCharges: event.deliveryCharges!,
        promoCode: event.promoCode!
      );
      if(response['success']){
        emit(ValidatePromoCodeLoaded());
      } else {
        emit(ValidatePromoCodeFailed(error: response['message'].toString()));
      }

    }catch(e) {
      emit(ValidatePromoCodeFailed(error: e.toString()));
    }
  }
}
