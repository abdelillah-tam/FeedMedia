import 'dart:convert';

import 'package:feedmedia/model/full_post.dart';
import 'package:feedmedia/model/post.dart';
import 'package:feedmedia/model/user.dart';
import 'package:feedmedia/services/post/remote_post_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RemotePostService extends RemotePostProvider {
  static const apiAddress = 'https://cozyproperty.backendless.app/api/data';

  @override
  Future<dynamic> post({required Post post, required String userToken}) async {
    final request = await http.post(
      Uri.parse('$apiAddress/posts'),
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
  }

  @override
  Future<List<Post>> getPosts({
    required String ownerId,
    required String userToken,
  }) async {
    final request = await http.get(
      Uri.parse(
          "$apiAddress/posts?where=ownerId='$ownerId'&sortBy=%60created%60%20desc"),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
    );
    final utf = utf8.decode(request.bodyBytes);
    final response = jsonDecode(utf) as List?;

    return response != null
        ? List.generate(
            response.length, (index) => Post.fromJson(response[index]))
        : List.empty();
  }

  @override
  Future<List<FullPost>> getFollowingPosts({
    required String userToken,
    required String currentFollowersObjectId,
    required String currentUserObjectId,
  }) async {
    final request = await http.get(
      Uri.parse(
          "$apiAddress/followers/$currentFollowersObjectId/following?property=objectId&property=last_name&property=first_name"),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
    );

    final response =
        (jsonDecode(request.body) as List).map((e) => User.fromJson(e));

    final objectsId = response.map((e) => "'${e.objectId}'");
    final fullUrl = StringBuffer("$apiAddress/posts?where=ownerId IN (");
    fullUrl.writeAll(objectsId, ',');
    fullUrl.write(
        ')&property=post&property=updated&property=created&property=objectId&property=ownerId&property=userObjectId&property=Count(%60likes%60)&groupBy=objectId');

    final postsRequest = await http.get(Uri.parse(fullUrl.toString()),
        headers: {'Content-Type': 'application/json', 'user-token': userToken});

    final utf = utf8.decode(postsRequest.bodyBytes);
    final postsResponse = (jsonDecode(utf) as List)
        .map((e) => FullPost(
              user: response
                  .firstWhere((element) => element.objectId == e['ownerId']),
              post: Post.fromJson(e),
              likesCount: e['count'],
              isLiker: false,
              likerObjectId: null,
            ))
        .toList();

    List<Future<Response>> isLikerFutures = List.empty(growable: true);
    for (var item in postsResponse) {
      final future = http.get(
        Uri.parse(
            "https://cozyproperty.backendless.app/api/data/posts/${item.post.objectId}/likes?where=objectId = '$currentUserObjectId'&property=objectId"),
        headers: {'Content-Type': 'application/json', 'user-token': userToken},
      );

      isLikerFutures.add(future);
    }

    final isLikerResults = await Future.wait(isLikerFutures);

    for (int i = 0; i < isLikerResults.length; i++) {
      final value = jsonDecode(isLikerResults[i].body) as List;
      if (value.isNotEmpty) {
        postsResponse[i].isLiker = true;
        postsResponse[i].likerObjectId = currentUserObjectId;
      }
    }

    return postsResponse;
  }

  @override
  Future<Map<String, dynamic>> like({
    required String postObjectId,
    required String likerObjectId,
    required String currentUserObjectId,
    required String userToken,
  }) async {
    final request = await http.put(
      Uri.parse('$apiAddress/posts/$postObjectId/likes'),
      headers: {'Content-Type': 'application/json', 'user-token': userToken},
      body: jsonEncode([likerObjectId]),
    );


    final count = http.get(
      Uri.parse(
          'https://cozyproperty.backendless.app/api/data/posts/$postObjectId?property=objectId&property=Count(%60likes%60)'),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
    );

    final isLiker = http.get(
      Uri.parse(
          "$apiAddress/posts/$postObjectId/likes?where=objectId = '$currentUserObjectId'"),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
    );

    final response = (await Future.wait([count, isLiker]))
        .map((e) => jsonDecode(e.body))
        .toList();

    return {
      'count': response[0]['count'],
      'postObjectId': response[0]['objectId'],
      'isLiker': response[1],
    };
  }

  @override
  Future<Map<String, dynamic>> unlike({
    required String postObjectId,
    required String likerObjectId,
    required String currentUserObjectId,
    required String userToken,
  }) async {
    final request = await http.delete(
      Uri.parse("$apiAddress/posts/$postObjectId/likes"),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
      body: jsonEncode([currentUserObjectId]),
    );

    final count = await http.get(
      Uri.parse(
          'https://cozyproperty.backendless.app/api/data/posts/$postObjectId?property=objectId&property=Count(%60likes%60)'),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
    );

    final requestResult = jsonDecode(request.body);
    final countResult = jsonDecode(count.body);

    return {
      'result': requestResult,
      'count': countResult,
    };
  }
}
