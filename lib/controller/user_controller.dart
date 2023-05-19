import 'dart:io';

import 'package:feedmedia/services/user/local_user_provider.dart';
import 'package:feedmedia/services/user/local_user_service.dart';
import 'package:feedmedia/services/user/remote_user_provider.dart';
import 'package:feedmedia/services/user/remote_user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user.dart';

class UserController extends GetxController {
  late final RemoteUserProvider _remoteUserProvider;
  late final LocalUserProvider _localUserProvider;

  late User? user;

  RxInt followersCount = 0.obs;
  RxInt followingCount = 0.obs;

  @override
  void onInit() async {
    _remoteUserProvider = RemoteUserService();
    _localUserProvider = LocalUserService();
    await _localUserProvider.open();
    user = await getUser();
    super.onInit();
  }

  Future<User?> registerByGoogle({required String email, required String accessToken}) async {
    final registeredUser = await _remoteUserProvider.register(email: email, accessToken: accessToken);

    await _localUserProvider.register(user: registeredUser);

    user = await getUser();
    return user;
  }

  Future<User?> getUser() async {
    final user = await _localUserProvider.getUser();
    return user;
  }

  Future<User?> login(String email, String password) async {
    final userFromNet = await _remoteUserProvider.login(email: email, password: password);

    await _localUserProvider.login(userFromNet!);

    user = await getUser();

    return user;
  }

  Future<bool> createPassword(
    String objectId,
    String userToken,
    String password,
    String email,
  ) async {
    final isPasswordCreated = await _remoteUserProvider.createPassword(objectId, password, userToken, email);

    final result = await _localUserProvider.createPassword(isPasswordCreated ? 1 : 0);
    FirebaseAuth.instance.signOut();
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
        firstName: updatedUser.firstName, lastName: updatedUser.lastName, objectId: updatedUser.objectId!);

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
    final result = await _remoteUserProvider.isFollower(targetedUserObjectId: targetedUserObjectId, userObjectId: userObjectId);
    return result;
  }

  Future<void> follow({
    required String currentUserObjectId,
    required String userFollowersObjectId,
    required String userObjectId,
    required String currentFollowersObjectId,
    required String userToken,
  }) async {
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
  }) async {
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

  void getFollowingCount(String followersObjectId) async {
    followingCount.value = 0;
    final count = await _remoteUserProvider.followingCount(followersObjectId);
    followingCount.value = count;
  }

  Future<bool> logout() async {
    final result = await _remoteUserProvider.logout(userToken: user!.userToken!);
    if (result) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      _localUserProvider.clearTable();
      return true;
    }

    return false;
  }

  Future<void> updateProfilePicture({
    required File file,
    required String userObjectId,
    required String userToken,
  }) async {
    final result = await _remoteUserProvider.updateProfilePicture(
      file: file,
      userObjectId: userObjectId,
      userToken: userToken,
    );

    final userUpdated = await _localUserProvider.updateProfilePictureUrl(url: result, userObjectId: userObjectId);

    if(userUpdated){
      user = await getUser();
    }
  }
}
