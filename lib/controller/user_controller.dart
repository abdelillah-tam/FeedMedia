import 'package:feedmedia/services/user/local_user_provider.dart';
import 'package:feedmedia/services/user/local_user_service.dart';
import 'package:feedmedia/services/user/remote_user_provider.dart';
import 'package:feedmedia/services/user/remote_user_service.dart';
import 'package:get/state_manager.dart';

import '../model/user.dart';

class UserController extends GetxController {
  late final RemoteUserProvider _remoteUserProvider;
  late final LocalUserProvider _localUserProvider;

  late User? user;

  RxInt followersCount = 0.obs;

  @override
  void onInit() async {
    _remoteUserProvider = RemoteUserService();
    _localUserProvider = LocalUserService();
    await _localUserProvider.open();
    user = await getUser();
    super.onInit();
  }

  Future<User?> registerByGoogle(
      {required String email, required String accessToken}) async {
    final user = await _remoteUserProvider.register(
        email: email, accessToken: accessToken);

    await _localUserProvider.register(user: user);

    final userFromDb = await getUser();
    return userFromDb;
  }

  Future<User?> getUser() async {
    final user = await _localUserProvider.getUser();
    return user;
  }

  Future<User?> login(String email, String password) async {
    final userFromNet =
        await _remoteUserProvider.login(email: email, password: password);

    await _localUserProvider.login(userFromNet!);

    user = await getUser();

    return user;
  }

  Future<bool> createPassword(
      String objectId, String userToken, String password) async {
    final isPasswordCreated =
        await _remoteUserProvider.createPassword(objectId, password, userToken);

    final result =
        await _localUserProvider.createPassword(isPasswordCreated ? 1 : 0);

    _localUserProvider.clearTable();

    return result;
  }

  Future<bool> updateFirstAndLastName({
    required String firstName,
    required String lastName,
  }) async {
    final updatedUser = await _remoteUserProvider.updateFirstAndLastName(
      firstName: firstName,
      lastName: lastName,
      userToken: user!.userToken!,
      objectId: user!.objectId!,
    ) as User;

    final result = await _localUserProvider.updateFirstAndLastName(
        firstName: updatedUser.firstName,
        lastName: updatedUser.lastName,
        objectId: updatedUser.objectId!);

    final oldUser = user;
    result ? user = await getUser() : oldUser;

    return result;
  }

  Future<List<User?>> searchUsers(String value) async {
    final users = await _remoteUserProvider.search(value);
    users.removeWhere((element) => element?.objectId == user!.objectId);
    return users;
  }

  Future<User> getPublicUser(String objectId) async {
    final user = await _remoteUserProvider.getPublicUser(objectId);

    return user;
  }

  Future<bool> isFollower({
    required String targetedUserObjectId,
    required String userObjectId,
  }) async {
    final result = await _remoteUserProvider.isFollower(
        targetedUserObjectId: targetedUserObjectId, userObjectId: userObjectId);
    return result;
  }

  Future<void> follow({
    required String currentUserObjectId,
    required String userFollowersObjectId,
    required String userObjectId,
    required String currentFollowersObjectId,
    required String userToken,
  }
  ) async {
    await _remoteUserProvider.follow(
      currentUserObjectId: currentUserObjectId,
      userFollowersObjectId: userFollowersObjectId,
      userToken: userToken,
      userObjectId: userObjectId,
      currentFollowersObjectId: currentFollowersObjectId,
    );
    getFollowersCount(userFollowersObjectId);
  }

  Future<void> unfollow({
    required String currentUserObjectId,
    required String userFollowersObjectId,
    required String userObjectId,
    required String currentFollowersObjectId,
    required String userToken,
  }
  ) async {
    await _remoteUserProvider.unfollow(
      currentUserObjectId: currentUserObjectId,
      currentFollowersObjectId: currentFollowersObjectId,
      userFollowersObjectId: userFollowersObjectId,
      userObjectId: userObjectId,
      userToken: userToken,
    );

    getFollowersCount(userFollowersObjectId);
  }

  void getFollowersCount(String followersObjectId) async {
    followersCount.value = 0;
    final count = await _remoteUserProvider.followersCount(followersObjectId);
    followersCount.value = count;
  }
}
