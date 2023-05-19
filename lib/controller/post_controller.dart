import 'dart:async';
import 'package:feedmedia/model/full_post.dart';
import 'package:feedmedia/model/post.dart';
import 'package:feedmedia/services/user/local_user_provider.dart';
import 'package:feedmedia/services/user/local_user_service.dart';
import 'package:feedmedia/services/post/remote_post_provider.dart';
import 'package:feedmedia/services/post/remote_post_service.dart';
import 'package:get/state_manager.dart';

import '../model/user.dart';

class PostController extends GetxController {
  late final RemotePostProvider remotePostProvider;
  late final LocalUserProvider localUserProvider;

  RxList<FullPost> homePosts = RxList(List.empty(growable: true));
  final Map<int, _Reaction> _reaction = {};


  @override
  void onInit() {
    remotePostProvider = RemotePostService();
    localUserProvider = LocalUserService();
    super.onInit();
  }

  void post({
    required String postText,
  }) async {
    final user = await localUserProvider.getUser();

    final post = Post(objectId: user!.objectId!, post: postText);

    await remotePostProvider.post(post: post, userToken: user.userToken!);
  }

  Future<List<Post>> getPosts(User user, String userToken) async {
    final posts = await remotePostProvider.getPosts(
        ownerId: user.objectId!, userToken: userToken);
    return posts;
  }

  Future<dynamic> getFollowingPosts({
    required String userToken,
    required String currentFollowersObjectId,
    required String currentUserObjectId,
  }) async {
    final posts = await remotePostProvider.getFollowingPosts(
      userToken: userToken,
      currentFollowersObjectId: currentFollowersObjectId,
      currentUserObjectId: currentUserObjectId,
    );
    if(posts != null) {
      homePosts.value = posts;
    }else{
      return null;
    }
    return '';
  }

  Future<void> _like({
    required String postObjectId,
    required String likerObjectId,
    required String userToken,
    required int index,
  }) async {
    final result = await remotePostProvider.like(
      postObjectId: postObjectId,
      likerObjectId: likerObjectId,
      userToken: userToken,
      currentUserObjectId: likerObjectId,
    );

    if ((result['isLiker'] as List).isEmpty) {
      homePosts.value[index].isLiker = false;
      homePosts.value[index].likesCount -= 1;
      homePosts.value[index].likerObjectId = null;
      homePosts.refresh();
    }
  }

  Future<void> _unlike({
    required String postObjectId,
    required String likerObjectId,
    required String userToken,
    required int index,
  }) async {
    final result = await remotePostProvider.unlike(
      postObjectId: postObjectId,
      likerObjectId: likerObjectId,
      currentUserObjectId: likerObjectId,
      userToken: userToken,
    );

    if (result['result'] > 0) {
      homePosts.value[index].isLiker = false;
      homePosts.value[index].likesCount = result['count']['count'];
      homePosts.refresh();
    }
  }

  Future<void> react({
    required String postObjectId,
    required String likerObjectId,
    required String userToken,
    required int index,
    required bool likeBool,
  }) async {
    _reaction[index]?.timer.cancel();

    if (likeBool) {
      _reaction[index] = _Reaction(
        timer: Timer(const Duration(seconds: 3), () async {
          _reaction[index]!.future = _like(
              postObjectId: postObjectId,
              likerObjectId: likerObjectId,
              userToken: userToken,
              index: index);
          await _reaction[index]!.future;
        }),
      );
    } else {
      _reaction[index] = _Reaction(
        timer: Timer(const Duration(seconds: 3), () async {
          _reaction[index]!.future = _unlike(
              postObjectId: postObjectId,
              likerObjectId: likerObjectId,
              userToken: userToken,
              index: index);
          await _reaction[index]!.future;
        }),
      );
    }
  }

}

class _Reaction {
  Timer timer;
  Future<void>? future;

  _Reaction({required this.timer});
}
