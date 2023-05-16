import 'dart:convert';
import 'package:feedmedia/model/user.dart';
import 'package:feedmedia/services/user/local_user_service.dart';
import 'package:feedmedia/services/user/remote_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:http/http.dart' as http;

class RemoteUserService extends RemoteUserProvider {
  static const _apiAddress = 'https://poeticstamp.backendless.app/api';

  @override
  Future<User?> register({
    String? email,
    String? accessToken,
  }) async {
    final request = await http.post(
      Uri.parse('$_apiAddress/users/oauth/googleplus/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'accessToken': accessToken!,
        'email': email!,
      }),
    );

    final response = jsonDecode(request.body);
    final followersRequest = await http.post(
      Uri.parse('$_apiAddress/data/followers'),
      headers: {
        'Content-Type': 'application/json',
        'user-token': response['user-token'],
      },
      body: jsonEncode(<String, dynamic>{}),
    );
    final followersResponse = jsonDecode(followersRequest.body);

    final addFollowersObjectId = await http.put(
      Uri.parse('$_apiAddress/users/${response['objectId']}'),
      headers: {
        'Content-Type': 'application/json',
        'user-token': response['user-token'],
      },
      body: jsonEncode(<String, dynamic>{
        followersObjectIdFieldName: followersResponse['objectId'],
      }),
    );

    final finalResponse = jsonDecode(addFollowersObjectId.body);
    final user = User.fromJson(finalResponse);
    user.userToken = response['user-token'].toString();
    return user;
  }

  @override
  Future<bool> createPassword(
    String objectId,
    String password,
    String userToken,
    String email,
  ) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final request = await http.put(
      Uri.parse('$_apiAddress/users/$objectId'),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
      body: jsonEncode(<String, dynamic>{
        'password': password,
        'isPasswordCreated': true,
        userUidFieldName: FirebaseAuth.instance.currentUser!.uid,
      }),
    );

    final response = jsonDecode(request.body);
    return response['isPasswordCreated'];
  }

  @override
  Future<User?> login({String? email, String? password}) async {
    final request = await http.post(
      Uri.parse('$_apiAddress/users/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'login': email!,
        'password': password!,
      }),
    );

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final response = jsonDecode(request.body);

    return User.fromJson(response);
  }

  @override
  Future<User?> updateFirstAndLastName({
    required String firstName,
    required String lastName,
    required String userToken,
    required String objectId,
  }) async {
    final request = await http.put(
      Uri.parse('$_apiAddress/users/$objectId'),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
      body: jsonEncode(<String, String>{
        'first_name': firstName,
        'last_name': lastName,
      }),
    );

    final response = jsonDecode(request.body);

    return User.fromJson(response);
  }

  @override
  Future<List<User?>> search(String value) async {
    final request = await http.get(
      Uri.parse(
          "$_apiAddress/data/Users?where=first_name LIKE '$value%'&property=first_name&property=last_name&property=objectId"),
    );

    final response = jsonDecode(request.body) as List;

    return response.map((e) => User.fromJson(e)).toList();
  }

  @override
  Future<User> getPublicUser(String objectId) async {
    final request = await http.get(
        Uri.parse('$_apiAddress/data/Users/$objectId'),
        headers: {'Content-Type': 'application/json'});

    final result = jsonDecode(request.body);

    return User.fromJson(result);
  }

  @override
  Future<void> follow({
    required String currentUserObjectId,
    required String currentFollowersObjectId,
    required String userFollowersObjectId,
    required String userObjectId,
    required String userToken,
  }) async {
    final follower = http.put(
      Uri.parse("$_apiAddress/data/followers/$userFollowersObjectId/follower"),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
      body: jsonEncode([currentUserObjectId]),
    );

    final following = http.put(
      Uri.parse(
          '$_apiAddress/data/followers/$currentFollowersObjectId/following'),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
      body: jsonEncode([userObjectId]),
    );

    await Future.wait([follower, following]);
  }

  @override
  Future<int> followersCount(String followersObjectId) async {
    final request = await http.get(
      Uri.parse(
          "$_apiAddress/data/followers/$followersObjectId?property=Count(%60follower%60)"),
      headers: {'Content-Type': 'application/json'},
    );

    final response = jsonDecode(request.body);

    final count = response['count'];

    return count;
  }

  @override
  Future<bool> isFollower({
    required String targetedUserObjectId,
    required String userObjectId,
  }) async {
    final request = await http.get(
      Uri.parse(
          "$_apiAddress/data/followers/$userObjectId/follower?where=objectId='$targetedUserObjectId'"),
      headers: {'Content-Type': 'application/json'},
    );

    final response = jsonDecode(request.body) as List;

    return response.isNotEmpty;
  }

  @override
  Future<void> unfollow({
    required String currentUserObjectId,
    required String currentFollowersObjectId,
    required String userFollowersObjectId,
    required String userObjectId,
    required String userToken,
  }) async {
    final follower = http.delete(
      Uri.parse('$_apiAddress/data/followers/$userFollowersObjectId/follower'),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
      body: jsonEncode([currentUserObjectId]),
    );

    final following = http.delete(
      Uri.parse(
          '$_apiAddress/data/followers/$currentFollowersObjectId/following'),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
      body: jsonEncode([userObjectId]),
    );

    await Future.wait([follower, following]);
  }

  @override
  Future<dynamic> logout({required String userToken}) async {
    final result = await http.get(
      Uri.parse('$_apiAddress/users/logout'),
      headers: {
        'Content-Type':'application/json',
        'user-token': userToken,
      },
    );
   if(result.statusCode == 200 && result.bodyBytes.isEmpty){
      return true;
    }else{
      return false;
    }
  }
}
