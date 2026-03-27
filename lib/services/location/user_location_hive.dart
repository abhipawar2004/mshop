
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hyper_local/config/constant.dart';
import '../../model/user_location/user_location_model.dart';

class HiveLocationHelper {
  static String boxName = AppConstant.localUserLocationHiveBoxName;
  static String currentLocationKey = AppConstant.localUserLocationHiveBoxKey;
  static const String recentLocationsKey = 'recent_user_locations';
  static const int _maxRecentLocations = 10;

  /// Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(UserLocationAdapter().typeId)) {
      Hive.registerAdapter(UserLocationAdapter());
    }

    // Open as dynamic box — this allows storing List<UserLocation>
    await Hive.openBox<dynamic>(boxName);
    await Hive.openBox<dynamic>(recentLocationsKey);
  }

  /// Current location
  static Future<void> setCurrentUserLocation(UserLocation location) async {
    final box = Hive.box<dynamic>(boxName);
    await box.put(currentLocationKey, location);
  }

  static UserLocation? getCurrentUserLocation() {
    final box = Hive.box<dynamic>(boxName);
    return box.get(currentLocationKey) as UserLocation?;
  }

  /// Recent locations list
  static Future<void> addToRecentLocations(UserLocation location) async {
    final box = Hive.box<dynamic>(boxName);

    // Safely get the list
    List<UserLocation> recent = List<UserLocation>.from(
      box.get(recentLocationsKey, defaultValue: <UserLocation>[]) as List,
    );

    recent.removeWhere((existing) =>
        _isSameLocation(existing, location)
    );

    recent.insert(0, location);

    if (recent.length > _maxRecentLocations) {
      recent = recent.sublist(0, _maxRecentLocations);
    }

    await box.put(recentLocationsKey, recent);
  }

  static List<UserLocation> getRecentLocations() {
    final box = Hive.box<dynamic>(boxName);
    final data = box.get(recentLocationsKey, defaultValue: <UserLocation>[]);

    return List<UserLocation>.from(data as List);
  }

  static Future<void> clearRecentLocations() async {
    final box = Hive.box<dynamic>(boxName);
    await box.delete(recentLocationsKey);
  }

  static Future<void> removeFromRecentLocations(UserLocation location) async {
    final box = Hive.box<dynamic>(boxName);
    final List<UserLocation> recent = List<UserLocation>.from(
      box.get(recentLocationsKey, defaultValue: <UserLocation>[]) as List,
    );

    recent.removeWhere((e) => e.id == location.id);

    await box.put(recentLocationsKey, recent);
  }

  static bool _isSameLocation(UserLocation a, UserLocation b) {
    const epsilon = 0.00001;
    final latDiff = (a.latitude - b.latitude).abs();
    final lngDiff = (a.longitude - b.longitude).abs();

    final coordsMatch = latDiff < epsilon && lngDiff < epsilon;

    return coordsMatch;
  }
}

