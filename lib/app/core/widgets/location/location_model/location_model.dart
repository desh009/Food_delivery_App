// // app/core/models/location_model.dart

// class LocationModel {
//   final String id;
//   final String name;
//   final String address;
//   final String? landmark;
//   final double latitude;
//   final double longitude;
//   bool isDefault;

//   LocationModel({
//     required this.id,
//     required this.name,
//     required this.address,
//     this.landmark,
//     required this.latitude,
//     required this.longitude,
//     this.isDefault = false,
//   });

//   // ========== COPYWITH METHOD ==========
//   LocationModel copyWith({
//     String? id,
//     String? name,
//     String? address,
//     String? landmark,
//     double? latitude,
//     double? longitude,
//     bool? isDefault,
//   }) {
//     return LocationModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       address: address ?? this.address,
//       landmark: landmark ?? this.landmark,
//       latitude: latitude ?? this.latitude,
//       longitude: longitude ?? this.longitude,
//       isDefault: isDefault ?? this.isDefault,
//     );
//   }
//   // =====================================

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'address': address,
//     'landmark': landmark,
//     'latitude': latitude,
//     'longitude': longitude,
//     'isDefault': isDefault,
//   };

//   factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
//     id: json['id'],
//     name: json['name'],
//     address: json['address'],
//     landmark: json['landmark'],
//     latitude: json['latitude']?.toDouble() ?? 0.0,
//     longitude: json['longitude']?.toDouble() ?? 0.0,
//     isDefault: json['isDefault'] ?? false,
//   );
// }