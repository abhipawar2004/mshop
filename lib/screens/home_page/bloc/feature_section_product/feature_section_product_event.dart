import 'package:equatable/equatable.dart';

abstract class FeatureSectionProductEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchFeatureSectionProducts extends FeatureSectionProductEvent {
  final String slug;
  FetchFeatureSectionProducts({required this.slug});
  @override
  // TODO: implement props
  List<Object?> get props => [slug];
}

class FetchMoreFeatureSectionProducts extends FeatureSectionProductEvent {
  final String slug;
  FetchMoreFeatureSectionProducts({required this.slug});
  @override
  // TODO: implement props
  List<Object?> get props => [slug];
}

class ClearFeatureSectionProducts extends FeatureSectionProductEvent {}

class RefreshFeatureSectionProducts extends FeatureSectionProductEvent {}