import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/shopping_list_page/repo/shopping_list_repo.dart';

import '../../model/shopping_list_model.dart';

part 'shopping_list_event.dart';
part 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  ShoppingListBloc() : super(ShoppingListInitial()) {
    on<CreateShoppingList>(_onCreateShoppingList);
  }

  final ShoppingListRepository repository = ShoppingListRepository();
  int currentPage = 0;
  int perPage = 0;
  int? lastPage;
  bool _hasReachedMax = false;
  bool loadMore = false;

  Future<void> _onCreateShoppingList(CreateShoppingList event, Emitter<ShoppingListState> emit) async {
    emit(ShoppingListLoading());
    try{
      List<ShoppingListData> shoppingListData = [];
      perPage = 40;
      currentPage = 1;
      _hasReachedMax = false;
      loadMore = false;
      final response = await repository.createShoppingList(keywords: event.keywords);
      shoppingListData = List<ShoppingListData>.from(response['data'].map((data) => ShoppingListData.fromJson(data)));
      currentPage += 1;
      _hasReachedMax = shoppingListData.length < perPage;
      if(response['success'] == true){
        emit(ShoppingListLoaded(
            message: response['message'],
            shoppingListData: shoppingListData,
            hasReachedMax: _hasReachedMax
        ));
      } else if (response['error'] == true){
        emit(ShoppingListFailed(error: response['message']));
      }
    }catch(e) {
      emit(ShoppingListFailed(error: e.toString()));
    }
  }
}
