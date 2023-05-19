import '../../model/user.dart';

abstract class LocalUserProvider {
  Future<dynamic> register({required User? user});

  Future<User?> getUser();

  Future<bool> createPassword(int isPasswordCreated);

  Future<User?> login(User user);

  Future<bool> updateFirstAndLastName({
    required String firstName,
    required String lastName,
    required String objectId,
  });

  Future<void> open();

  void clearTable();

  Future<bool> updateProfilePictureUrl({
    required String url,
    required String userObjectId,
  });
}
