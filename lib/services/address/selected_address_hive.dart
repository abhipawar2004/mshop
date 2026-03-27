import 'package:hive_flutter/hive_flutter.dart';
import 'package:hyper_local/config/constant.dart';
import '../../model/selected_address/selected_address_model.dart';
import '../../screens/address_list_page/model/get_address_list_model.dart';

class HiveSelectedAddressHelper {
  static String boxName = AppConstant.selectedAddressHiveBoxName;
  static String key = AppConstant.selectedAddressHiveBoxKey;

  /// Initialize Hive, register adapter, and open the box
  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SelectedAddressAdapter());
    }
    await Hive.openBox<SelectedAddress>(boxName);
  }

  /// Save selected address to Hive
  static Future<void> setSelectedAddress(AddressListData address) async {
    var box = Hive.box<SelectedAddress>(boxName);
    final selectedAddress = SelectedAddress.fromAddressListData(address);
    await box.put(key, selectedAddress);
  }

  /// Get selected address from Hive
  static SelectedAddress? getSelectedAddress() {
    try {
      var box = Hive.box<SelectedAddress>(boxName);
      return box.get(key);
    } catch (e) {
      return null;
    }
  }

  /// Clear selected address from Hive
  static Future<void> clearSelectedAddress() async {
    var box = Hive.box<SelectedAddress>(boxName);
    await box.delete(key);
  }

  /// Check if selected address exists
  static bool hasSelectedAddress() {
    try {
      var box = Hive.box<SelectedAddress>(boxName);
      return box.containsKey(key);
    } catch (e) {
      return false;
    }
  }
}