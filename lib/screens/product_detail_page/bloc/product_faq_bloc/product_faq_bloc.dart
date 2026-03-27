
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/product_faq_model.dart';
import '../../repo/product_faq_repo.dart';

part 'product_faq_event.dart';
part 'product_faq_state.dart';

class ProductFAQBloc extends Bloc<ProductFAQEvent, ProductFAQState> {
  ProductFAQBloc() : super(ProductFAQInitial()) {
    on<FetchProductFAQ>(_onFetchProductFAQ);
  }

  final ProductFAQRepository repository = ProductFAQRepository();

  Future<void> _onFetchProductFAQ(FetchProductFAQ event, Emitter<ProductFAQState> emit) async {
    try{
      final response = await repository.fetchProductFAQ(productSlug: event.productSlug);

      final productFAQModel = ProductFAQModel.fromJson(response);

      if (productFAQModel.success == true) {
        emit(ProductFAQLoaded(
          message: productFAQModel.message,
          productData: [productFAQModel.data],
        ));
      } else {
        emit(ProductFAQFailure(error: productFAQModel.message));
      }
    }catch(e) {
      emit(ProductFAQFailure(error: e.toString()));
    }
  }
}
