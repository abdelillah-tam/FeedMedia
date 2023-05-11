import 'package:feedmedia/model/post.dart';
import 'package:feedmedia/model/user.dart';
import 'package:flutter/foundation.dart';

class FullPost {
  final User user;
  final Post post;
  int likesCount;
  bool isLiker;
  String? likerObjectId;

  FullPost({
    required this.user,
    required this.post,
    required this.likesCount,
    required this.isLiker,
    required this.likerObjectId,
  });
}
