import 'dart:convert';

import 'package:feedmedia/model/post.dart';
import 'package:feedmedia/services/post/remote_post_provider.dart';
import 'package:http/http.dart' as http;

class RemotePostService extends RemotePostProvider {
  @override
  Future<dynamic> post({required Post post, required String userToken}) async {
    final request = await http.post(
      Uri.parse('https://zestfulairplane.backendless.app/api/data/posts'),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
      body: jsonEncode(<String, String>{
        'userObjectId': post.objectId,
        'post': post.post,
      }),
    );

    final result = jsonDecode(request.body);

    result;
  }

  @override
  Future<List<Post>> getPosts({required String userToken}) async{
    final request = await http.post(Uri.parse('https://zestfulairplane.backendless.app/api/data/posts'));
    return List.empty();
  }
}
