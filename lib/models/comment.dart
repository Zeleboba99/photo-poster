import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_apps/models/user.dart';

class CommentModel {
  String uid;
  String authorUid;
  String postUid;
  UserModel userModel;
  String text;
  Timestamp createdAt;

  CommentModel(
      {required this.uid,
      required this.authorUid,
      required this.postUid,
      required this.text,
      required this.createdAt,
      required this.userModel});
}
