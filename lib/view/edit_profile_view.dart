import 'dart:io';

import 'package:feedmedia/controller/user_controller.dart';
import 'package:feedmedia/utilities/dialogs/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  final UserController _userController = Get.find();

  File? file;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _firstNameController.text = _userController.user!.firstName;
    _lastNameController.text = _userController.user!.lastName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final smallHeight = (height < 720);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
          ),
        ),
        body: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(360.0),
              child: file == null && _userController.user!.profileImageUrl != null
                  ? Image.network(
                      _userController.user!.profileImageUrl!,
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.fitWidth,
                    )
                  : _userController.user!.profileImageUrl == null
                      ? Image.asset(
                          'assets/images/profile.png',
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.fitWidth,
                        )
                      : Image.file(
                          file!,
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.fitWidth,
                        ),
            ),
            TextButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();

                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  file = File(image!.path);
                });
              },
              child: const Text('Choose picture'),
            ),
            Padding(
              padding: EdgeInsets.only(top: smallHeight ? 8.0 : 16.0, left: smallHeight ? 8.0 : 16.0, right: smallHeight ? 8.0 : 16.0),
              child: TextField(
                controller: _firstNameController,
                cursorWidth: 1.0,
                cursorHeight: (height < 720 ? 15.0 : 20.0),
                cursorRadius: const Radius.circular(18.0),
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: smallHeight ? 8.0 : 16.0,
                left: smallHeight ? 8.0 : 16.0,
                right: smallHeight ? 8.0 : 16.0,
              ),
              child: TextField(
                controller: _lastNameController,
                cursorWidth: 1.0,
                cursorHeight: (height < 720 ? 15.0 : 20.0),
                cursorRadius: const Radius.circular(18.0),
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final firstName = _firstNameController.text;
                final lastName = _lastNameController.text;
                LoadingScreen().show(context: context, text: '');
                if (firstName != _userController.user!.firstName || lastName != _userController.user!.lastName) {
                  await _userController.updateFirstAndLastName(firstName: firstName, lastName: lastName);
                }
                if (file != null) {
                  await _userController.updateProfilePicture(
                    file: file!,
                    userObjectId: _userController.user!.objectId!,
                    userToken: _userController.user!.userToken!,
                  );
                }
                LoadingScreen().hide();
              },
              child: const Text('Save', style: TextStyle(color: Colors.black)),
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
