import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_apps/models/user.dart';


class PostConverter{

  static const AUTHOR_UID = "authorUid";
  static const CREATED_AT = "createdAt";
  static const DESCRIPTION = "description";
  static const URL = "url";
  static const LIKED_BY = "likedBy";
  static const COMMENTS = "comments";

  static Future<PostModel> convertToPost(String postUid, var data, String currentUserUid) async {
    String authorUid = data[AUTHOR_UID];
    Timestamp createdAt = data[CREATED_AT];
    String description = data[DESCRIPTION];
    String url = data[URL];
    List<dynamic> likedByDynamic = data[LIKED_BY];
    var comments = data[COMMENTS];

    http.Response response = await http.get(url);
    ByteData image = response.bodyBytes.buffer.asByteData(); //Uint8List

    print("likedBy " + likedByDynamic.toString());
    List<String> likedBy = likedByDynamic == null ? [] : likedByDynamic.cast<String>();

    PostModel postModel = PostModel(
        uid: postUid,
        authorUid: authorUid,
        createdAt: createdAt,
        description: description,
        image: image,
        imageUrl: url,
        likeStatus: likedBy.any((element) => element == currentUserUid) ? LikeStatus.active : LikeStatus.inactive,
        comments: comments,
        likedBy: likedBy,
        hasComments: false,
        userModel: UserModel(uid: "", email: "", nickname: ""),
    );

    return postModel;
  }

  static Map<String, dynamic> convertToMap(PostModel postModel) {
    Map<String, dynamic> data = <String, dynamic>{
      AUTHOR_UID: postModel.authorUid,
      DESCRIPTION: postModel.description,
      CREATED_AT: postModel.createdAt,
      URL: postModel.imageUrl,
      COMMENTS: postModel.comments,
      LIKED_BY: postModel.likedBy == null ? [] :postModel.likedBy
    };
    return data;
  }
}