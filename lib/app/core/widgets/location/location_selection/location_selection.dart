import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ========== কারেন্ট লোকেশন বের করা ==========
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    // পারমিশন চেক
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        
        setState(() {
          _selectedLocation = LatLng(position.latitude, position.longitude);
          _currentAddress = 
              "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}";
        });

        // ম্যাপের ক্যামেরা মুভ করুন
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _selectedLocation!,
                zoom: 16,
              ),
            ),
          );
        }

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

  // ========== ম্যাপে ট্যাপ করলে ==========
  void _onMapTapped(LatLng tappedLocation) {
    setState(() {
      _selectedLocation = tappedLocation;
      _currentAddress = 
          "Lat: ${tappedLocation.latitude.toStringAsFixed(6)}, Lng: ${tappedLocation.longitude.toStringAsFixed(6)}";
    });
    
    print("Selected Location: ${tappedLocation.latitude}, ${tappedLocation.longitude}");
  }

  // ========== ম্যাপ ডায়ালগ ওপেন ==========
  void _openLocationPicker() {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.all(10.r),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16.0.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "লোকেশন নির্বাচন করুন",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              // Address Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_pin, color: Colors.green, size: 24.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        _currentAddress,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_isLoading)
                      SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: CircularProgressIndicator(strokeWidth: 2.r),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              
              // ========== Google Map ==========
              Expanded(
                child: GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                    
                    // ম্যাপ তৈরি হলে কারেন্ট লোকেশনে ক্যামেরা মুভ করুন
                    if (_selectedLocation != null) {
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _selectedLocation!,
                            zoom: 16,
                          ),
                        ),
                      );
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation ?? LatLng(23.8103, 90.4125),
                    zoom: 14,
                  ),
                  onTap: _onMapTapped,  // ← ম্যাপে ট্যাপ করলে লোকেশন সিলেক্ট হবে
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.hybrid,  // ← স্যাটেলাইট ছবি
                  markers: _selectedLocation != null
                      ? {
                          Marker(
                            markerId: MarkerId("selected"),
                            position: _selectedLocation!,
                            infoWindow: InfoWindow(
                              title: "আপনার লোকেশন",
                              snippet: "এখানে ডেলিভারি নিন",
                            ),
                          ),
                        }
                      : {},
                ),
              ),
              
              // Confirm Button
              Padding(
                padding: EdgeInsets.all(16.0.r),
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
                        Get.snackbar(
                          '✅ লোকেশন সেভ হয়েছে',
                          _currentAddress,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: Duration(seconds: 3),
                        );
                      } else {
                        Get.snackbar(
                          '⚠️ সতর্কতা',
                          'দয়া করে একটি লোকেশন নির্বাচন করুন',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                      }
                    },
                    icon: Icon(Icons.check_circle),
                    label: Text(
                      "এই লোকেশন কনফর্ম করুন",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openLocationPicker,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              color: Colors.green,
              size: 22.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Delivery Location",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _currentAddress,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}