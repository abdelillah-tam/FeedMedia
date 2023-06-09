import 'package:feedmedia/controller/post_controller.dart';
import 'package:feedmedia/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({Key? key}) : super(key: key);

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  late final TextEditingController _postTextController;
  final PostController _postController = Get.find();

  @override
  void initState() {
    _postTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create post'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _postTextController,
              cursorColor: const Color.fromRGBO(1, 10, 28, 1.0),
              cursorWidth: 1.0,
              cursorHeight: (height < 720 ? 15 : 20.0),
              cursorRadius: const Radius.circular(18.0),
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  fontSize: (height < 720 ? 12 : 16.0),
                ),
              ),
              style: const TextStyle(
                color: Color.fromRGBO(1, 10, 28, 1.0),
              ),
              keyboardType: TextInputType.text,
              autocorrect: false,
            ),
            TextButton(
                onPressed: () {
                  final post = _postTextController.text;
                  _postController.post(postText: post);
                },
                child: const Text('Post')),
          ],
        ),
      ),
    );
  }
}
