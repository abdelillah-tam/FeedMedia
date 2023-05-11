import 'package:feedmedia/model/full_post.dart';
import 'package:feedmedia/model/post.dart';

import '../../model/user.dart';

abstract class RemotePostProvider {
  Future<dynamic> post({
    required Post post,
    required String userToken,
  });

  Future<List<Post>> getPosts({
    required String ownerId,
    required String userToken,
  });

  Future<List<FullPost>> getFollowingPosts({
    required String userToken,
    required String currentFollowersObjectId,
    required String currentUserObjectId,
  });

  Future<Map<String, dynamic>> like({
    required String postObjectId,
    required String likerObjectId,
    required String currentUserObjectId,
    required String userToken,
  });

  Future<Map<String, dynamic>> unlike({
    required String postObjectId,
    required String likerObjectId,
    required String currentUserObjectId,
    required String userToken,
  });
}
