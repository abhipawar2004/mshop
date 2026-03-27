import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/product_detail_bloc/product_detail_event.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/product_detail_bloc/product_detail_state.dart';
import 'package:hyper_local/screens/product_detail_page/model/product_detail_model.dart';
import 'package:hyper_local/screens/product_detail_page/repo/product_detail_repo.dart';


class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(ProductDetailInitial()) {
    on<FetchProductDetail>(_onFetchProductDetail);
  }

  final ProductDetailRepository repository = ProductDetailRepository();

  Future<void> _onFetchProductDetail(FetchProductDetail event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoading());
    try {
      final response = await repository.fetchProductDetail(productSlug: event.productSlug);

      final productDetailModel = ProductDetailModel.fromJson(response);

      if (productDetailModel.success == true && productDetailModel.data != null) {
        emit(ProductDetailLoaded(
          message: productDetailModel.message,
          productData: [productDetailModel.data!],
        ));
      } else {
        emit(ProductDetailFailed(error: productDetailModel.message));
      }
    } catch (e) {
      emit(ProductDetailFailed(error: e.toString()));
    }
  }
}