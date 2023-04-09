import 'package:feedmedia/controller/post_controller.dart';
import 'package:feedmedia/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({Key? key}) : super(key: key);

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  late final TextEditingController _postTextController;
  final PostController _postController = Get.put(PostController());


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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  color: Color.fromRGBO(1, 10, 28, 1.0), fontFamily: 'Sofia'),
              keyboardType: TextInputType.text,
              autocorrect: false,
            ),
            TextButton(onPressed: () {
              final post = _postTextController.text;
              _postController.post(postText: post);
            }, child: const Text('Post')),
          ],
        ),
      ),
    );
  }
}
