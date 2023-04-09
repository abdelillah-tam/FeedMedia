import 'dart:convert';
import 'package:feedmedia/model/user.dart';
import 'package:feedmedia/services/user/remote_user_provider.dart';
import 'package:http/http.dart' as http;

class RemoteUserService extends RemoteUserProvider {
  @override
  Future<User?> register({
    String? email,
    String? accessToken,
  }) async {
    final request = await http.post(
      Uri.parse(
          'https://zestfulairplane.backendless.app/api/users/oauth/googleplus/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'accessToken': accessToken!,
        'email': email!,
      }),
    );

    final response = jsonDecode(request.body);

    return User.fromJson(response);
  }

  @override
  Future<bool> createPassword(
      String objectId, String password, String userToken) async {
    final request = await http.put(
      Uri.parse('https://zestfulairplane.backendless.app/api/users/$objectId'),
      headers: {
        'Content-Type': 'application/json',
        'user-token': userToken,
      },
      body: jsonEncode(<String, dynamic>{
        'password': password,
        'isPasswordCreated': true,
      }),
    );

    final response = jsonDecode(request.body);
    return response['isPasswordCreated'];
  }

  @override
  Future<User?> login({String? email, String? password}) async {
    final request = await http.post(
      Uri.parse('https://zestfulairplane.backendless.app/api/users/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'login': email!,
        'password': password!,
      }),
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
      Uri.parse('https://zestfulairplane.backendless.app/api/users/$objectId'),
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
          "https://zestfulairplane.backendless.app/api/data/Users?where=first_name LIKE '$value%'&property=first_name&property=last_name&property=objectId"),
    );

    final response = jsonDecode(request.body) as List;

    return response.map((e) => User.fromJson(e)).toList();
  }

  @override
  Future<User> getPublicUser(String objectId) async {
    final request = await http.get(
      Uri.parse(
          'https://zestfulairplane.backendless.app/api/data/Users/$objectId'),
      headers: {
        'Content-Type':'application/json'
      }
    );

    final result = jsonDecode(request.body);

    return User.fromJson(result);
  }
}
