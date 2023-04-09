import 'package:flutter/foundation.dart';

@immutable
class Post {
  final String? ownerId;
  final String objectId;
  final String post;

  const Post({this.ownerId, required this.objectId, required this.post});
}
