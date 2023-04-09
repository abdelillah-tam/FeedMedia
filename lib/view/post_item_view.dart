import 'package:flutter/material.dart';

class PostItemView extends StatefulWidget {
  final String post;

  const PostItemView({Key? key, required this.post}) : super(key: key);

  @override
  State<PostItemView> createState() => _PostItemViewState();
}

class _PostItemViewState extends State<PostItemView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.post),
      ],
    );
  }
}
