import 'package:feedmedia/move_to_page.dart';
import 'package:feedmedia/view/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';

class EnterPasswordView extends StatefulWidget {
  final String objectId;
  final String userToken;

  const EnterPasswordView({
    Key? key,
    required this.objectId,
    required this.userToken,
  }) : super(key: key);

  @override
  State<EnterPasswordView> createState() => _EnterPasswordViewState();
}

class _EnterPasswordViewState extends State<EnterPasswordView> {
  late final TextEditingController _passwordTextController;
  late final TextEditingController _reEnterPasswordTextController;

  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    _passwordTextController = TextEditingController();
    _reEnterPasswordTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
      child: Scaffold(
        appBar: !isKeyboard
            ? AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded)),
                backgroundColor: const Color.fromRGBO(18, 91, 228, 1.0),
                elevation: 0.0,
              )
            : null,
        backgroundColor: const Color.fromRGBO(18, 91, 228, 1.0),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: (isKeyboard
                    ? 0
                    : height < 720
                        ? 105
                        : 140.0),
              ),
              Image(
                image: const AssetImage('assets/images/logo.png'),
                color: Colors.white,
                width: (isKeyboard
                    ? 0
                    : height < 720
                        ? 135.0
                        : 180.0),
              ),
              const Spacer(),
              Container(
                height: (isKeyboard
                    ? 252.5
                    : height < 720
                        ? 262.5
                        : 350),
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18.0),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: (height < 720 ? 15.0 : 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create ',
                            style: TextStyle(
                              color: const Color.fromRGBO(1, 10, 28, 1.0),
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.bold,
                              fontSize: (height < 720 ? 12 : 16.0),
                            ),
                          ),
                          Text(
                            'Password',
                            style: TextStyle(
                              color: const Color.fromRGBO(18, 91, 228, 1.0),
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.bold,
                              fontSize: (height < 720 ? 12 : 16.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: (height < 720 ? 22.5 : 30),
                      ),
                      SizedBox(
                        height: (height < 720 ? 30.0 : 40.0),
                        child: TextField(
                          controller: _passwordTextController,
                          cursorColor: const Color.fromRGBO(1, 10, 28, 1.0),
                          cursorWidth: 1.0,
                          cursorHeight: (height < 720 ? 15.0 : 20.0),
                          cursorRadius: const Radius.circular(18.0),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontFamily: 'Sofia',
                              fontSize: (height < 720 ? 12 : 16.0),
                              color: const Color.fromRGBO(106, 124, 159, 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(106, 124, 159, 1.0),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(360.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(106, 124, 159, 1.0),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(360.0),
                            ),
                          ),
                          style: const TextStyle(
                              color: Color.fromRGBO(1, 10, 28, 1.0),
                              fontFamily: 'Sofia'),
                          autocorrect: false,
                          autofocus: true,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                        ),
                      ),
                      SizedBox(
                        height: (height < 720 ? 12.5 : 25.0),
                      ),
                      SizedBox(
                        height: (height < 720 ? 30.0 : 40.0),
                        child: TextField(
                          controller: _reEnterPasswordTextController,
                          cursorColor: const Color.fromRGBO(1, 10, 28, 1.0),
                          cursorWidth: 1.0,
                          cursorHeight: (height < 720 ? 15 : 20.0),
                          cursorRadius: const Radius.circular(18.0),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            labelText: 'Re-Enter Password',
                            labelStyle: TextStyle(
                              fontFamily: 'Sofia',
                              fontSize: (height < 720 ? 12 : 16.0),
                              color: const Color.fromRGBO(106, 124, 159, 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(106, 124, 159, 1.0),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(360.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(106, 124, 159, 1.0),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(360.0),
                            ),
                          ),
                          style: const TextStyle(
                              color: Color.fromRGBO(1, 10, 28, 1.0),
                              fontFamily: 'Sofia'),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          autocorrect: false,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: (height < 720 ? 30.0 : 40.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final password = _passwordTextController.text;
                            final result = await userController.createPassword(
                                widget.objectId, widget.userToken, password);

                            if (mounted && result) {
                              Navigator.of(context).pushReplacement(
                                createRoute(const SignInView()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(18, 91, 228, 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(360.0),
                            ),
                          ),
                          child: const Text(
                            'Create Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Sofia',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (isKeyboard
                            ? 20.0
                            : height < 720
                                ? 45.0
                                : 60.0),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
