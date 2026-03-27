import 'dart:async';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'user_location_hive.dart';
import '../../model/user_location/user_location_model.dart';

class LocationService {
  
  // In lib/utils/location/location_service.dart
  static Future<bool> ensureServiceAndPermission() async {
    bool servicesOn = await Geolocator.isLocationServiceEnabled();
    if (!servicesOn) {
      await Geolocator.openLocationSettings();
      servicesOn = await Geolocator.isLocationServiceEnabled();
      if (!servicesOn) return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      await openAppSettings();
      permission = await Geolocator.checkPermission();
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  static Future<UserLocation?> requestAndStoreLocationWithRetry() async {
    bool ready = await ensureServiceAndPermission();
    if (!ready) return null;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          timeLimit: Duration(seconds: 10)
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
      );
      final p = placemarks.isNotEmpty ? placemarks[0] : Placemark();
      final fullAddress = [
        p.street, p.subLocality, p.locality, p.administrativeArea,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      final userLocation = UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        fullAddress: fullAddress.isEmpty ? "" : fullAddress,
        area: p.subLocality ?? '',
        city: p.locality ?? '',
        state: p.administrativeArea ?? '',
        country: p.country ?? '',
        pincode: p.postalCode ?? '',
        landmark: p.name ?? '',
      );

      await HiveLocationHelper.setCurrentUserLocation(userLocation);
      return userLocation;
    } catch (_) {
      // One controlled retry
      final readyAgain = await ensureServiceAndPermission();
      if (!readyAgain) return null;
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0,
            timeLimit: Duration(seconds: 15),
          ),
        );
        final placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
        );
        final p = placemarks.isNotEmpty ? placemarks[0] : Placemark();
        final fullAddress = [
          p.street, p.subLocality, p.locality, p.administrativeArea,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        final userLocation = UserLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          fullAddress: fullAddress.isEmpty ? "" : fullAddress,
          area: p.subLocality ?? '',
          city: p.locality ?? '',
          state: p.administrativeArea ?? '',
          country: p.country ?? '',
          pincode: p.postalCode ?? '',
          landmark: p.name ?? '',
        );

        await HiveLocationHelper.setCurrentUserLocation(userLocation);
        return userLocation;
      } catch (_) {
        return null;
      }
    }
  }

  static Future<UserLocation?> storeLocationFromCoordinates(
      {required String latitude, required String longitude}) async {
    try {
      final double lat = double.tryParse(latitude) ?? 0.0;
      final double lng = double.tryParse(longitude) ?? 0.0;

      // Geocoding: Get address details from coordinates
      final placemarks = await placemarkFromCoordinates(lat, lng);
      final p = placemarks.isNotEmpty ? placemarks[0] : Placemark();

      // Combine address parts for fullAddress field
      final fullAddress = [
        p.street, p.subLocality, p.locality, p.administrativeArea,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      final userLocation = UserLocation(
        latitude: lat,
        longitude: lng,
        fullAddress: fullAddress.isEmpty ? "Default Location" : fullAddress, // Use "Default Location" if geocoding fails to give an address
        area: p.subLocality ?? '',
        city: p.locality ?? '',
        state: p.administrativeArea ?? '',
        country: p.country ?? '',
        pincode: p.postalCode ?? '',
        // Use p.name for a potential landmark, or just leave it empty
        landmark: p.name ?? '',
      );

      // Store the determined location
      await HiveLocationHelper.setCurrentUserLocation(userLocation);
      return userLocation;

    } catch (e) {
      // Handle any errors during parsing or geocoding
      log("Error storing location from coordinates: $e");
      return null;
    }
  }

  /// Get stored location from Hive
  static UserLocation? getStoredLocation() {
    return HiveLocationHelper.getCurrentUserLocation();
  }

  /// Check if location is stored
  static bool hasStoredLocation() {
    return getStoredLocation() != null;
  }

  /// Store a specific location in Hive
  static Future<void> storeLocation(UserLocation location) async {
    await HiveLocationHelper.setCurrentUserLocation(location);
    await HiveLocationHelper.addToRecentLocations(location);
  }
} 