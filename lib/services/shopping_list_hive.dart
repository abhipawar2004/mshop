import 'package:hive_flutter/hive_flutter.dart';

class ShoppingListHiveHelper {
  static const String _boxName = 'shopping_history';
  static const String _key = 'last_shopping_list';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<dynamic>(_boxName);
    }
  }

  static Future<void> saveCurrentList(List<String> itemNames) async {
    final box = Hive.box<dynamic>(_boxName);
    final keywords = itemNames.join(',');
    await box.put(_key, keywords);
  }

  static Future<List<String>> getLastList() async {
    final box = Hive.box<dynamic>(_boxName);
    final data = box.get(_key, defaultValue: '');
    if (data is String && data.isNotEmpty) {
      return data.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }

  static Future<void> clearLastList() async {
    final box = Hive.box<dynamic>(_boxName);
    await box.delete(_key);
  }
}