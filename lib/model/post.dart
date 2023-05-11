import 'package:flutter/foundation.dart';

@immutable
class Post {
  final String? ownerId;
  final String objectId;
  final String post;

  const Post({this.ownerId, required this.objectId, required this.post});

  Post.fromJson(Map<String, dynamic> json)
      : this.ownerId = json['ownerId'],
        this.objectId = json['objectId'],
        this.post = json['post'];
}
