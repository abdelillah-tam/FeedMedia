import 'package:flutter/foundation.dart';

@immutable
class User {
  final String? id;
  final String? email;
  final String? name;
  final String? objectId;
  final String? userToken;
  final String firstName;
  final String lastName;
  final int isPasswordCreated;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.objectId,
    required this.userToken,
    required this.firstName,
    required this.lastName,
    required this.isPasswordCreated,
  });

  User.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.email = json['email'],
        this.name = json['name'],
        this.objectId = json['objectId'],
        this.userToken = json['user-token'],
        this.firstName = json['first_name'],
        this.lastName = json['last_name'],
        this.isPasswordCreated = json['isPasswordCreated'] == null
            ? -1
            : (json['isPasswordCreated'] as bool)
                ? 1
                : 0;

  @override
  bool operator ==(covariant User other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
