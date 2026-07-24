// // app/core/widgets/location/location_service/location_service.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:food_hjoiopk/app/core/widgets/location/location_model/location_model.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocationService extends GetxService {
//   final RxList<LocationModel> savedLocations = <LocationModel>[].obs;
//   final Rx<LocationModel?> currentLocation = Rx<LocationModel?>(null);
//   final RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadSavedLocations();
//   }

//   // Load saved locations from SharedPreferences
//   Future<void> _loadSavedLocations() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? locationsJson = prefs.getString('saved_locations');
      
//       if (locationsJson != null) {
//         final List<dynamic> decoded = json.decode(locationsJson);
//         savedLocations.value = decoded
//             .map((item) => LocationModel.fromJson(item))
//             .toList();
        
//         // Set default location if available
//         final defaultLocation = savedLocations.firstWhereOrNull((loc) => loc.isDefault);
//         if (defaultLocation != null) {
//           currentLocation.value = defaultLocation;
//         } else if (savedLocations.isNotEmpty) {
//           currentLocation.value = savedLocations.first;
//         }
//       } else {
//         // Add default locations if no saved locations
//         _addDefaultLocations();
//       }
//     } catch (e) {
//       print('Error loading locations: $e');
//       _addDefaultLocations();
//     }
//   }

//   // Add default locations
//   void _addDefaultLocations() {
//     final defaultLocations = [
//       LocationModel(
//         id: '1',
//         name: 'Home',
//         address: '221B Baker Street, London',
//         landmark: 'Near Baker Street Station',
//         latitude: 51.5237,
//         longitude: -0.1585,
//         isDefault: true,
//       ),
//       LocationModel(
//         id: '2',
//         name: 'Office',
//         address: '10 Downing Street, London',
//         landmark: 'Near Parliament',
//         latitude: 51.5034,
//         longitude: -0.1276,
//         isDefault: false,
//       ),
//     ];
//     savedLocations.value = defaultLocations;
//     currentLocation.value = defaultLocations.first;
//     _saveLocations();
//   }

//   // ========== PUBLIC METHOD ==========
//   // Save locations to storage (Public method for external use)
//   Future<void> saveLocationsToStorage() async {
//     await _saveLocations();
//   }
//   // =================================

//   // Save locations to SharedPreferences (Private method)
//   Future<void> _saveLocations() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final jsonList = savedLocations.map((loc) => loc.toJson()).toList();
//       await prefs.setString('saved_locations', json.encode(jsonList));
//     } catch (e) {
//       print('Error saving locations: $e');
//     }
//   }

//   // Add new location
//   Future<void> addLocation(LocationModel location) async {
//     savedLocations.add(location);
//     await _saveLocations();
//   }

//   // Remove location
//   Future<void> removeLocation(String id) async {
//     savedLocations.removeWhere((loc) => loc.id == id);
//     if (currentLocation.value?.id == id) {
//       currentLocation.value = savedLocations.isNotEmpty ? savedLocations.first : null;
//     }
//     await _saveLocations();
//   }

//   // Set default location
//   Future<void> setDefaultLocation(String id) async {
//     // Find the location to set as default
//     final locationToSet = savedLocations.firstWhereOrNull((loc) => loc.id == id);
//     if (locationToSet == null) return;

//     // Update all locations - set isDefault to false for all
//     final updatedLocations = savedLocations.map((loc) {
//       return loc.id == id 
//           ? loc.copyWith(isDefault: true)  // Set selected as default
//           : loc.copyWith(isDefault: false); // Set others as non-default
//     }).toList();

//     // Update the list
//     savedLocations.value = updatedLocations;
    
//     // Update current location
//     currentLocation.value = locationToSet.copyWith(isDefault: true);
    
//     // Save to storage
//     await _saveLocations();
//   }

//   // Update current location
//   void updateCurrentLocation(LocationModel location) {
//     currentLocation.value = location;
//   }

//   // Get current location using GPS
//   Future<LocationModel?> getCurrentLocation() async {
//     try {
//       isLoading.value = true;
      
//       // Check if location services are enabled
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         Get.snackbar(
//           'Location Error',
//           'Please enable location services',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         isLoading.value = false;
//         return null;
//       }

//       // Check location permissions
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           Get.snackbar(
//             'Permission Denied',
//             'Location permission is required',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//           isLoading.value = false;
//           return null;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         Get.snackbar(
//           'Permission Denied',
//           'Location permission is permanently denied',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         isLoading.value = false;
//         return null;
//       }

//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       // Create new location
//       final newLocation = LocationModel(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         name: 'Current Location',
//         address: '${position.latitude}, ${position.longitude}',
//         latitude: position.latitude,
//         longitude: position.longitude,
//         isDefault: false,
//       );

//       savedLocations.add(newLocation);
//       currentLocation.value = newLocation;
//       await _saveLocations();

//       isLoading.value = false;
      
//       Get.snackbar(
//         'Success',
//         'Current location added successfully!',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
      
//       return newLocation;
//     } catch (e) {
//       print('Error getting current location: $e');
//       isLoading.value = false;
//       Get.snackbar(
//         'Error',
//         'Failed to get current location',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return null;
//     }
//   }

//   // Search locations (Mock implementation)
//   Future<List<LocationModel>> searchLocations(String query) async {
//     if (query.isEmpty) return [];
    
//     // Simulate API call
//     await Future.delayed(const Duration(milliseconds: 500));
    
//     final mockResults = [
//       LocationModel(
//         id: 'search_1',
//         name: 'Search Result 1',
//         address: 'London, UK',
//         latitude: 51.5074,
//         longitude: -0.1278,
//         isDefault: false,
//       ),
//       LocationModel(
//         id: 'search_2',
//         name: 'Search Result 2',
//         address: 'Manchester, UK',
//         latitude: 53.4808,
//         longitude: -2.2426,
//         isDefault: false,
//       ),
//     ];
    
//     return mockResults.where(
//       (loc) => loc.name.toLowerCase().contains(query.toLowerCase()) ||
//               loc.address.toLowerCase().contains(query.toLowerCase())
//     ).toList();
//   }
// }