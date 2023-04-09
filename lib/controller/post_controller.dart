import 'package:feedmedia/model/post.dart';
import 'package:feedmedia/services/user/local_user_provider.dart';
import 'package:feedmedia/services/user/local_user_service.dart';
import 'package:feedmedia/services/post/remote_post_provider.dart';
import 'package:feedmedia/services/post/remote_post_service.dart';
import 'package:get/state_manager.dart';

class PostController extends GetxController {
  late final RemotePostProvider remotePostProvider;
  late final LocalUserProvider localUserProvider;

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

    remotePostProvider.post(post: post, userToken: user.userToken!);
  }

  Future<List<Post>> getPosts() async {
    final user = await localUserProvider.getUser();
    return List.empty();

  }
}
