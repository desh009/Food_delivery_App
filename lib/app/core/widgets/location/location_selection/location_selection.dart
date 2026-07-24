import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';  // ← এই লাইনটি ডিলিট করুন
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class LocationPicker extends StatefulWidget {
  final Function(LatLng? location, String? address)? onLocationSelected;

  const LocationPicker({super.key, this.onLocationSelected});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  String _currentAddress = "লোকেশন নির্বাচন করুন";
  bool _isLoading = false;
  LatLng? _selectedLocation;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _selectedLocation = LatLng(position.latitude, position.longitude);
        
        // geocoding ছাড়া সরাসরি লোকেশন দেখান
        setState(() {
          _currentAddress = 
              "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}";
        });
      } catch (e) {
        print("Location error: $e");
        setState(() {
          _currentAddress = "লোকেশন পাওয়া যায়নি";
        });
      }
    } else {
      setState(() {
        _currentAddress = "পারমিশন নেই";
      });
    }
    setState(() => _isLoading = false);
  }

  void _openLocationPicker() async {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "লোকেশন নির্বাচন করুন",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              // Address Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_pin, color: Colors.green, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _currentAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_isLoading)
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Google Map
              Expanded(
                child: GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation ?? const LatLng(23.8103, 90.4125),
                    zoom: 14,
                  ),
                  onTap: (LatLng tappedLocation) async {
                    setState(() {
                      _selectedLocation = tappedLocation;
                      _currentAddress = 
                          "Lat: ${tappedLocation.latitude.toStringAsFixed(6)}, Lng: ${tappedLocation.longitude.toStringAsFixed(6)}";
                    });
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _selectedLocation != null
                      ? {
                          Marker(
                            markerId: const MarkerId("selected"),
                            position: _selectedLocation!,
                            infoWindow: const InfoWindow(title: "আপনার লোকেশন"),
                          ),
                        }
                      : {},
                ),
              ),
              // Confirm Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_selectedLocation != null) {
                        if (widget.onLocationSelected != null) {
                          widget.onLocationSelected!(
                            _selectedLocation,
                            _currentAddress,
                          );
                        }
                        Get.back();
                      }
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text(
                      "এই লোকেশন কনফর্ম করুন",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openLocationPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: Colors.green,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Delivery Location",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _currentAddress,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}