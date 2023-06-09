import 'package:feedmedia/constants.dart';
import 'package:feedmedia/controller/user_controller.dart';
import 'package:feedmedia/utilities/dialogs/loading_screen.dart';
import 'package:feedmedia/view/enter_password_view.dart';
import 'package:feedmedia/view/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../move_to_page.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  final UserController userController = Get.find();

  final GoogleSignIn _googleSignIng = GoogleSignIn(scopes: [
    'email',
  ]);

  @override
  void initState() {
    LoadingScreen().hide();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        leadingWidth: 0.1,
        elevation: 0.0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
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
                    color: darkBlue,
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
                    backgroundColor: blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(360.0),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
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
                            color: darkBlue,
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
    );
  }

  Future<void> _handleSignIn(GoogleSignIn googleSignIng) async {
    try {
      final account = await googleSignIng.signIn();
      final auth = await account?.authentication;

      if (auth != null) {
        if (mounted) {
          LoadingScreen().show(context: context, text: '');
        }
        ;
        final user = await userController.registerByGoogle(
          email: account!.email,
          accessToken: auth.accessToken!,
        );
        if (mounted && user != null && user.isPasswordCreated == 0) {
          Navigator.of(context).push(createRoute(EnterPasswordView(
              objectId: user.objectId!, userToken: user.userToken!)));
        } else {
          Navigator.of(context).push(createRoute(const SignInView()));
        }
      }
    } catch (error) {
      LoadingScreen().hide();
      return;
    }
  }
}
