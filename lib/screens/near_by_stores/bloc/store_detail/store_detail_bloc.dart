import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/near_by_stores/repo/near_by_store_repo.dart';

import '../../model/near_by_store_model.dart';

part 'store_detail_event.dart';
part 'store_detail_state.dart';

class StoreDetailBloc extends Bloc<StoreDetailEvent, StoreDetailState> {
  StoreDetailBloc() : super(StoreDetailInitial()) {
    on<FetchStoreDetail>(_onFetchStoreDetail);
  }

  final NearByStoreRepo repository = NearByStoreRepo();

  Future<void> _onFetchStoreDetail(FetchStoreDetail event, Emitter<StoreDetailState> emit) async {
    emit(StoreDetailLoading());
    try{
      final storeData = await repository.fetchStoreDetail(storeSlug: event.storeSlug);

      if(storeData.isNotEmpty && storeData.first.success == true) {
        if(storeData.first.data?.name != null) {
          emit(StoreDetailLoaded(
            storeData: storeData.first.data!
          ));
        } else {
          emit(StoreDetailFailed(error: storeData.first.message ?? ''));
        }
      } else {
        emit(StoreDetailFailed(error: storeData.first.message ?? ''));
      }
    }catch(e) {
      emit(StoreDetailFailed(error: e.toString()));
    }
  }
}
