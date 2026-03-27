import 'package:hive_flutter/hive_flutter.dart';

part 'cart_sync_action.g.dart';

@HiveType(typeId: 11)
enum CartSyncAction {
  @HiveField(0)
  none,

  @HiveField(1)
  add,

  @HiveField(2)
  update,

  @HiveField(3)
  delete,
}
