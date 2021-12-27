import 'dart:convert';

import 'package:mobile_apps/models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider {
// http://jsonplaceholder.typicode.com/users

  Future<List<UserModel>> getUser() async {
    final response = await http.get('http://jsonplaceholder.typicode.com/users');

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);
      return userJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching users');
    }
  }
}