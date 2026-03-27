import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/promo_code/promo_code_event.dart';
import 'package:hyper_local/screens/cart_page/bloc/promo_code/promo_code_state.dart';
import '../../model/promo_code_model.dart';
import '../../repo/promo_code_repository.dart';

class PromoCodeBloc extends Bloc<PromoCodeEvent, PromoCodeState> {
  PromoCodeBloc() : super(PromoCodeInitial()){
    on<FetchPromoCode>(_onFetchPromoCode);
    on<SelectPromoCode>(_onSelectPromoCode);
    on<RemovePromoCode>(_onRemovePromoCode);
  }

  int currentPage = 0;
  int perPage = 0;
  int? lastPage;
  bool _hasReachedMax = false;
  bool loadMore = false;
  final PromoCodeRepository repository = PromoCodeRepository();
  String? selectedPromoCode;

  Future<void> _onFetchPromoCode(FetchPromoCode event, Emitter<PromoCodeState> emit) async {
    emit(PromoCodeLoading());
    try{
      List<PromoCodeData> promoCodeData = [];
      perPage = 18;
      currentPage = 1;
      _hasReachedMax = false;
      loadMore = false;
      final response = await repository.fetchPromoCode();
      promoCodeData = List<PromoCodeData>.from(response['data'].map((data) => PromoCodeData.fromJson(data)));
      currentPage += 1;
      _hasReachedMax = promoCodeData.length < perPage;
      if(response['success'] == true){
        emit(PromoCodeLoaded(
          message: response['message'],
          promoCodeData: promoCodeData,
          hasReachedMax: _hasReachedMax
        ));
      } else if (response['error'] == true){
        emit(PromoCodeFailed(error: response['message']));
      }
    }catch(e){
      emit(PromoCodeFailed(error: e.toString()));
    }
  }

  Future<void> _onSelectPromoCode(SelectPromoCode event, Emitter<PromoCodeState> emit) async {
    emit(PromoCodeApplying());
    await Future.delayed(const Duration(milliseconds: 500), () {
      selectedPromoCode = event.promoCode;
      emit(PromoCodeSelected(promoCode: event.promoCode));
    });
  }

  Future<void> _onRemovePromoCode(RemovePromoCode event, Emitter<PromoCodeState> emit) async {
    emit(PromoCodeRemoving());
    await Future.delayed(const Duration(milliseconds: 500));
    selectedPromoCode = '';
    emit(PromoCodeRemoved(promoCode: ''));
  }
}