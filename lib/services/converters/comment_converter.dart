import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/user.dart';


class CommentConverter{

  static const POST_UID = "postUid";
  static const AUTHOR_UID = "authorUid";
  static const CREATED_AT = "createdAt";
  static const TEXT = "text";

  static Future<CommentModel> convertToComment(String commentUid, var data) async {
    String postUid = data[POST_UID];
    String authorUid = data[AUTHOR_UID];
    Timestamp createdAt = data[CREATED_AT];
    String text = data[TEXT];

    CommentModel commentModel = CommentModel(
      uid: commentUid,
      authorUid: authorUid,
      postUid: postUid,
      createdAt: createdAt,
      text: text,
      userModel: UserModel(uid: "", email: "", nickname: ""),
    );

    return commentModel;
  }

  static Map<String, dynamic> convertToMap(CommentModel commentModel) {
    Map<String, dynamic> data = <String, dynamic>{
      POST_UID: commentModel.postUid,
      AUTHOR_UID: commentModel.authorUid,
      TEXT: commentModel.text,
      CREATED_AT: commentModel.createdAt,
    };
    return data;
  }
}