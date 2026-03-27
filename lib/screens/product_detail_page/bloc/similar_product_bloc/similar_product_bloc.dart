import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/product_detail_page/repo/product_detail_repo.dart';

import '../../model/product_detail_model.dart';

part 'similar_product_event.dart';
part 'similar_product_state.dart';

class SimilarProductBloc extends Bloc<SimilarProductEvent, SimilarProductState> {
  SimilarProductBloc() : super(SimilarProductInitial()) {
    on<FetchSimilarProduct>(_onFetchSimilarProduct);
  }

  final ProductDetailRepository repository = ProductDetailRepository();
  int currentPage = 0;
  int perPage = 0;
  int? lastPage;
  bool _hasReachedMax = false;
  bool loadMore = false;

  Future<void> _onFetchSimilarProduct(FetchSimilarProduct event, Emitter<SimilarProductState> emit) async {
    emit(SimilarProductLoading());
    try{
      List<ProductData> categoryProduct = [];
      perPage = 20;
      currentPage = 1;
      _hasReachedMax = false;
      loadMore = false;

      final response = await repository.fetchSimilarProduct(excludeProductSlug: event.excludeProductSlug);
      categoryProduct = List<ProductData>.from(
          response['data']['data'].map((data) => ProductData.fromJson(data))
      );
      currentPage += 1;
      _hasReachedMax = categoryProduct.length < perPage;

      if (response['success'] == true) {
        emit(SimilarProductLoaded(
          message: response['message'],
          similarProduct: categoryProduct,
          hasReachedMax: _hasReachedMax,
        ));
      } else if (response['error'] == true) {
        emit(SimilarProductFailure(error: response['message']));
      }

    }catch(e){
      emit(SimilarProductFailure(error: e.toString()));
    }
  }
}
