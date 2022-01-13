import 'package:flutter/services.dart';

class UserModel {
  String uid;
  String nickname;
  String? avatarUrl;
  ByteData? avatar;
  String email;

  UserModel({required this.uid, required this.nickname, required this.email, this.avatarUrl, this.avatar});
}