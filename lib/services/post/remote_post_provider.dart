import 'package:feedmedia/model/post.dart';

abstract class RemotePostProvider{

  Future<dynamic> post({required Post post, required String userToken});
  Future<List<Post>> getPosts({required String userToken});
}