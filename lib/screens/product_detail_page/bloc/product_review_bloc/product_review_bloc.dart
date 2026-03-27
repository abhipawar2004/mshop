import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/product_review_model.dart';
import '../../repo/product_review_repo.dart';

part 'product_review_event.dart';
part 'product_review_state.dart';

class ProductReviewBloc extends Bloc<ProductReviewEvent, ProductReviewState> {
  ProductReviewBloc() : super(ProductReviewInitial()) {
    on<FetchProductReview>(_onFetchProductReview);
  }

  final ProductReviewRepository repository = ProductReviewRepository();

  Future<void> _onFetchProductReview(FetchProductReview event, Emitter<ProductReviewState> emit) async {
    try{
      final response = await repository.fetchProductReview(productSlug: event.productSlug);
      final productReviewModel = ProductReviewModel.fromJson(response);
      if (productReviewModel.success == true) {
        emit(ProductReviewLoaded(
          message: productReviewModel.message,
          productReview: [productReviewModel.data],
        ));
      } else {
        emit(ProductReviewFailure(error: productReviewModel.message));
      }
    }catch(e) {
      emit(ProductReviewFailure(error: e.toString()));
    }
  }
}
