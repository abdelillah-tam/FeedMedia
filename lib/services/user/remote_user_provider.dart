import 'package:feedmedia/model/user.dart';

abstract class RemoteUserProvider {
  Future<User?> register({
    String email,
    String accessToken,
  });

  Future<User?>? getUser() {
    return null;
  }

  Future<bool> createPassword(String objectId, String password, String userToken);

  Future<User?> login({String email, String password});

  Future<dynamic> updateFirstAndLastName({
    required String firstName,
    required String lastName,
    required String userToken,
    required String objectId,
  });

  Future<List<User?>> search(String value);

  Future<User> getPublicUser(String objectId);
}
