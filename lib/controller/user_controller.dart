import 'package:feedmedia/services/user/local_user_provider.dart';
import 'package:feedmedia/services/user/local_user_service.dart';
import 'package:feedmedia/services/user/remote_user_provider.dart';
import 'package:feedmedia/services/user/remote_user_service.dart';
import 'package:get/state_manager.dart';

import '../model/user.dart';

class UserController extends GetxController {
  late final RemoteUserProvider _remoteUserProvider;
  late final LocalUserProvider _localUserProvider;

  late final User? user;

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
    final isPasswordCreated = await _remoteUserProvider.createPassword(objectId, password, userToken);

    final result = await _localUserProvider.createPassword(isPasswordCreated ? 1 : 0);

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

  Future<List<User?>> searchUsers(String value) async{
    final users = await _remoteUserProvider.search(value);
    users.removeWhere((element) => element?.objectId == user!.objectId);
    return users;
  }

  Future<User> getPublicUser(String objectId) async {
    final user = await _remoteUserProvider.getPublicUser(objectId);

    return user;
  }

  @override
  void onClose() async {
    (_localUserProvider as LocalUserService);
    super.onClose();
  }
}
