import 'package:feedmedia/model/user.dart';

abstract class RemoteUserProvider {
  Future<User?> register({
    String email,
    String accessToken,
  });

  Future<User?>? getUser() {
    return null;
  }

  Future<bool> createPassword(
    String objectId,
    String password,
    String userToken,
  );

  Future<User?> login({
    String email,
    String password,
  });

  Future<dynamic> updateFirstAndLastName({
    required String firstName,
    required String lastName,
    required String userToken,
    required String objectId,
  });

  Future<List<User?>> search(String value);

  Future<User> getPublicUser(String objectId);

  Future<void> follow({
    required String currentUserObjectId,
    required String currentFollowersObjectId,
    required String userFollowersObjectId,
    required String userObjectId,
    required String userToken,
  }
  );

  Future<int> followersCount(String objectId);

  Future<bool> isFollower({
    required String targetedUserObjectId,
    required String userObjectId,
  });

  Future<void> unfollow({
    required String currentUserObjectId,
    required String currentFollowersObjectId,
    required String userFollowersObjectId,
    required String userObjectId,
    required String userToken,
  });


}
