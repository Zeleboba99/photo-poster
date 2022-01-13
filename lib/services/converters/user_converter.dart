import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_apps/models/user.dart';


class UserConverter{

  static const UID = "uid";
  static const NICKNAME = "nickname";
  static const AVATAR_URL = "avatarUrl";
  static const EMAIL = "email";

  static Future<UserModel> convertToUser(String uid, var data) async {
    String nickname = data[NICKNAME];
    String avatarUrl = data[AVATAR_URL];
    String email = data[EMAIL];

    ByteData? image = null;
    if (avatarUrl.isNotEmpty) {
      http.Response response = await http.get(avatarUrl);
      image = response.bodyBytes.buffer.asByteData();
    }

    UserModel userModel = UserModel(
        uid: uid,
        nickname: nickname,
        avatarUrl: avatarUrl,
        avatar: image,
        email: email,
    );

    return userModel;
  }

  static Map<String, dynamic> convertToMap(UserModel userModel) {
    Map<String, dynamic> data = <String, dynamic>{
      NICKNAME: userModel.nickname,
      AVATAR_URL: userModel.avatarUrl,
      EMAIL: userModel.email,
    };
    return data;
  }
}