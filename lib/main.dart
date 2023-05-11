import 'package:feedmedia/constants.dart';
import 'package:feedmedia/controller/post_controller.dart';
import 'package:feedmedia/view/authentication_view.dart';
import 'package:feedmedia/view/enter_first_last_name_view.dart';
import 'package:feedmedia/view/enter_password_view.dart';
import 'package:feedmedia/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/user_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'FeedMedia',
    home: const MainPage(),
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: darkBlue,
      ),
      fontFamily: 'Sofia',
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: 'Sofia',
            color: darkBlue,
            fontSize: 20.0,
            fontWeight: FontWeight.normal),
        iconTheme: IconThemeData(color: darkBlue)
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromRGBO(236, 248, 255, 1.0),
        unselectedItemColor: Color.fromRGBO(177, 188, 208, 1.0),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(fontFamily: 'Sofia', color: lightBlue),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: lightBlue,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(360.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: lightBlue,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(360.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          prefixIconColor: lightBlue),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(360.0),
        ),
      ),
    ),
  ));
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final UserController _userController = Get.put(UserController());
  final PostController _postController = Get.put(PostController());

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

  @override
  void dispose() {
    _userController.dispose();
    super.dispose();
  }
}
