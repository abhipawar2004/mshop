import 'package:equatable/equatable.dart';

abstract class BannerEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchBanner extends BannerEvent {
  final String categorySlug;
  FetchBanner({required this.categorySlug});
  @override
  // TODO: implement props
  List<Object?> get props => [categorySlug];
}