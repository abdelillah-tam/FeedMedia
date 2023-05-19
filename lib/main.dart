import 'package:feedmedia/constants.dart';
import 'package:feedmedia/firebase_options.dart';
import 'package:feedmedia/controller/post_controller.dart';
import 'package:feedmedia/view/authentication_view.dart';
import 'package:feedmedia/view/enter_first_last_name_view.dart';
import 'package:feedmedia/view/enter_password_view.dart';
import 'package:feedmedia/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controller/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    title: 'FeedMedia',
    home: const MainPage(),
    scrollBehavior: const ConstantScrollBehavior(),
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
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
          ),
          titleTextStyle: TextStyle(
              fontFamily: 'Sofia',
              color: darkBlue,
              fontSize: 20.0,
              fontWeight: FontWeight.normal),
          iconTheme: IconThemeData(color: darkBlue)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        unselectedItemColor: Color.fromRGBO(177, 188, 208, 1.0),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
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
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: lightBlue,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(360.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: red,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(360.0),

          ),
          errorStyle: const TextStyle(color: red),
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

class ConstantScrollBehavior extends ScrollBehavior {
  const ConstantScrollBehavior();

  @override
  Widget buildScrollbar(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  TargetPlatform getPlatform(BuildContext context) => TargetPlatform.macOS;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
