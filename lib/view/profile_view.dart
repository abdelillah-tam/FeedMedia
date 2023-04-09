import 'package:feedmedia/constants.dart';
import 'package:feedmedia/move_to_page.dart';
import 'package:feedmedia/view/edit_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';
import '../model/user.dart';

class ProfileView extends StatefulWidget {
  final String? objectId;

  const ProfileView({Key? key, this.objectId}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(fontFamily: 'Sofia', color: darkBlue),
        ),
        leading: widget.objectId != null
            ? InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: darkBlue,
                ),
              )
            : null,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return ProfileBody(
                  isNull: widget.objectId == null ? true : false,
                  user: snapshot.data!);
            default:
              return const CircularProgressIndicator();
          }
        },
        future: widget.objectId != null
            ? _userController.getPublicUser(widget.objectId!)
            : _userController.getUser(),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class ProfileBody extends StatefulWidget {
  final bool isNull;
  final User user;

  const ProfileBody({
    Key? key,
    required this.isNull,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [],
        ),
        Text(
          '${widget.user.firstName} ${widget.user.lastName}',
          style: const TextStyle(
              fontFamily: 'Sofia', fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        Text(''),
        widget.isNull
            ? TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(
                      const EditProfileView(),
                    ),
                  );
                },
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontFamily: 'Sofia'),
                ),
              )
            : TextButton(
                onPressed: () {},
                child: const Text('Follow'),
              ),
      ],
    );
  }
}
