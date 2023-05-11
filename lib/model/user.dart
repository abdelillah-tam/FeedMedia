import 'package:flutter/foundation.dart';

@immutable
class User {
  final String? id;
  final String? email;
  final String? name;
  final String? objectId;
  String? userToken;
  final String firstName;
  final String lastName;
  final int isPasswordCreated;
  final String followersObjectId;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.objectId,
    required this.userToken,
    required this.firstName,
    required this.lastName,
    required this.isPasswordCreated,
    required this.followersObjectId,
  });

  User.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.email = json['email'],
        this.name = json['name'],
        this.objectId = json['objectId'],
        this.userToken = json['user-token'],
        this.firstName = json['first_name'] ?? 'none',
        this.lastName = json['last_name'] ?? 'none',
        this.isPasswordCreated = json['isPasswordCreated'] == null
            ? -1
            : (json['isPasswordCreated'] as bool)
                ? 1
                : 0,
        this.followersObjectId = json['followersObjectId'] ?? 'none';

  User.fromJsonWithFollowers(
      Map<String, dynamic> json, Map<String, dynamic> jsonFollowers)
      : this.id = json['id'],
        this.email = json['email'],
        this.name = json['name'],
        this.objectId = json['objectId'],
        this.userToken = json['user-token'],
        this.firstName = json['first_name'] ?? 'none',
        this.lastName = json['last_name'] ?? 'none',
        this.isPasswordCreated = json['isPasswordCreated'] == null
            ? -1
            : (json['isPasswordCreated'] as bool)
                ? 1
                : 0,
        this.followersObjectId = jsonFollowers['objectId'];

  @override
  bool operator ==(covariant User other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
