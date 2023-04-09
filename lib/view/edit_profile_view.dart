import 'package:feedmedia/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  final UserController _userController = Get.put(UserController());

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontFamily: 'Sofia'),
          ),
        ),
        body: Column(
          children: [
            TextField(
              controller: _firstNameController,
            ),
            TextField(
              controller: _lastNameController,
            ),
            TextButton(
              onPressed: () {
                final firstName = _firstNameController.text;
                final lastName = _lastNameController.text;

                _userController.updateFirstAndLastName(firstName: firstName, lastName: lastName);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
