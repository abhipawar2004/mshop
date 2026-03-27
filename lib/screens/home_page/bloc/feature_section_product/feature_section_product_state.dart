import 'package:equatable/equatable.dart';
import '../../model/featured_section_product_model.dart';

abstract class FeatureSectionProductState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FeatureSectionProductInitial extends FeatureSectionProductState {}

class FeatureSectionProductLoading extends FeatureSectionProductState {}

class FeatureSectionProductLoaded extends FeatureSectionProductState {
  final List<FeatureSectionData> featureSectionProductData;
  final String message;
  final bool hasReachedMax;

  FeatureSectionProductLoaded({
    required this.featureSectionProductData,
    required this.message,
    required this.hasReachedMax
  });

  @override
  // TODO: implement props
  List<Object?> get props => [featureSectionProductData, message, hasReachedMax];
}

class FeatureSectionProductFailed extends FeatureSectionProductState {
  final String error;
  FeatureSectionProductFailed({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}