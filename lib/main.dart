import 'package:feedmedia/view/authentication_view.dart';
import 'package:feedmedia/view/enter_first_last_name_view.dart';
import 'package:feedmedia/view/enter_password_view.dart';
import 'package:feedmedia/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/user_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title: 'FeedMedia',
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userController.getUser(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data != null &&
                snapshot.data!.isPasswordCreated == 1 &&
                snapshot.data!.firstName != 'none') {
              return const MainView();
            } else if (snapshot.data != null &&
                snapshot.data!.isPasswordCreated == 0) {
              return EnterPasswordView(
                objectId: snapshot.data!.objectId!,
                userToken: snapshot.data!.userToken!,
              );
            } else if (snapshot.data != null &&
                snapshot.data!.firstName == 'none') {
              return EnterFirstLastNameView(
                  objectId: snapshot.data!.objectId!,
                  userToken: snapshot.data!.userToken!);
            } else {
              return const AuthenticationView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
