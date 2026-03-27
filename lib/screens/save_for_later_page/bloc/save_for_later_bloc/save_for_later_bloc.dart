import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/save_for_later_page/bloc/save_for_later_bloc/save_for_later_event.dart';
import 'package:hyper_local/screens/save_for_later_page/bloc/save_for_later_bloc/save_for_later_state.dart';
import '../../model/save_for_later_model.dart';
import '../../repo/save_for_later_repo.dart';

class SaveForLaterBloc extends Bloc<SaveForLaterEvent, SaveForLaterState> {
  SaveForLaterBloc() : super(SaveForLaterInitial()) {
    on<FetchSavedProducts>(_onFetchSavedProducts);
    on<SaveForLaterRequest>(_onSaveForLaterRequest);
  }

  final SaveForLaterRepository repository = SaveForLaterRepository();
  int currentPage = 0;
  int perPage = 50;
  int? lastPage;
  bool hasReachedMax = false;
  bool isLoadingMore = false;
  bool loadMore = false;

  Future<void> _onFetchSavedProducts(FetchSavedProducts event, Emitter<SaveForLaterState> emit) async {
    emit(SaveForLaterLoading());
    try{
      List<SavedItems> savedItems = [];
      currentPage = 1;
      hasReachedMax = false;
      isLoadingMore = false;
      final response = await repository.fetchSavedProduct(
          perPage: perPage,
          currentPage: currentPage,
      );
      savedItems = List<SavedItems>.from(response['data']['items'].map((data) => SavedItems.fromJson(data)));
      final totalProducts = int.parse(response['data']['items_count'].toString());
      if(response['success'] == true){
        emit(SaveForLaterLoaded(
          message: response['message'],
          savedItems: savedItems,
          hasReachedMax: hasReachedMax,
          totalProducts: totalProducts
        ));
      } else if (response['error'] == true){
        emit(SaveForLaterFailed(error: response['message']));
      }
    }catch(e) {
      emit(SaveForLaterFailed(error: e.toString()));
    }
  }

  Future<void> _onSaveForLaterRequest(SaveForLaterRequest event, Emitter<SaveForLaterState> emit) async {
    emit(SaveForLaterLoading());
    try{
      final response = await repository.saveForLaterProduct(
          cartItemId: event.cartItemId,
      );
      if(response['success'] == true){
        if(response['data'] != null && response['data']['items'] != null) {
          emit(ProductSavedSuccess(productName: event.cartItemName));
          add(FetchSavedProducts());
        }
      } else if (response['error'] == true){
        emit(SaveForLaterFailed(error: response['message']));
      }
    } catch(e) {
      emit(SaveForLaterFailed(error: e.toString()));
    }
  }
}