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
  final String userUID;

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
    required this.userUID,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        name = json['name'],
        objectId = json['objectId'],
        userToken = json['user-token'],
        firstName = json['first_name'] ?? 'none',
        lastName = json['last_name'] ?? 'none',
        isPasswordCreated = json['isPasswordCreated'] == null
            ? -1
            : (json['isPasswordCreated'] as bool)
                ? 1
                : 0,
        followersObjectId = json['followersObjectId'] ?? 'none',
        userUID = json['userUID'] ?? '';

  @override
  bool operator ==(covariant User other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
