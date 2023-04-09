import 'package:feedmedia/controller/user_controller.dart';
import 'package:feedmedia/view/enter_password_view.dart';
import 'package:feedmedia/view/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../move_to_page.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  final UserController userController = Get.put(UserController());

  final GoogleSignIn _googleSignIng = GoogleSignIn(scopes: [
    'email',
  ]);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(
                  height: (height < 720 ? 105.0 : 140.0),
                ),
                const Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 180.0,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Your Best Social Media Platform',
                    style: TextStyle(
                      color: const Color.fromRGBO(1, 10, 28, 1.0),
                      fontFamily: 'Sofia',
                      fontSize: (height < 720 ? 21 : 28.0),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: (height < 720 ? 18.75 : 25.0),
                ),
                SizedBox(
                  width: double.infinity,
                  height: (height < 720 ? 30 : 40.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        createRoute(const SignInView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(18, 91, 228, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(360.0),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Sofia',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: (height < 720 ? 11.25 : 15.0),
                ),
                SizedBox(
                  width: double.infinity,
                  height: (height < 720 ? 30.0 : 40.0),
                  child: OutlinedButton(
                    onPressed: () async {
                      await _handleSignIn(_googleSignIng);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(360.0),
                        side: const BorderSide(
                            color: Color.fromRGBO(106, 124, 159, 1.0),
                            width: 1.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Image(
                            image: AssetImage('assets/images/google.png'),
                            height: 16.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            'Sign Up with Google',
                            style: TextStyle(
                              color: Color.fromRGBO(1, 10, 28, 1.0),
                              fontFamily: 'Sofia',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: (height < 720 ? 67.5 : 90.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn(GoogleSignIn googleSignIng) async {
    try {
      final account = await googleSignIng.signIn();
      final auth = await account?.authentication;
      if (auth != null) {
        final user = await userController.registerByGoogle(
          email: account!.email,
          accessToken: auth.accessToken!,
        );

        if (mounted && user != null) {
          Navigator.of(context).push(createRoute(EnterPasswordView(
              objectId: user.objectId!, userToken: user.userToken!)));
        }
      }
    } catch (error) {
      return;
    }
  }
}

