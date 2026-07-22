// lib/app/models/user.dart
class User {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? profileImage;
  String? password;

  User({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.profileImage,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'name': name ?? '',
      'phone': phone ?? '',
      'email': email ?? '',
      'profileImage': profileImage ?? '',
      'password': password ?? '',
    };
  }

  // Copy With
  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? profileImage,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      password: password ?? this.password,
    );
  }
}