import 'package:equatable/equatable.dart';

abstract class ClearCartEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ClearCartRequest extends ClearCartEvent{}