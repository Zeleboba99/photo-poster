import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/user.dart';

enum LikeStatus {
  active,
  inactive,
}

class PostModel {
  String uid;
  String authorUid;
  UserModel userModel;
  String? description;
  Timestamp createdAt;
  ByteData? image;
  String imageUrl = "";
  LikeStatus? likeStatus;
  bool hasComments;
  List<String>? likedBy = [];

  List<CommentModel>? comments = [];

  PostModel(
      {required this.uid,
      required this.authorUid,
      required this.userModel,
      this.description,
      required this.createdAt,
      required this.imageUrl,
      this.image,
      this.likeStatus,
      this.likedBy,
      required this.hasComments,
      this.comments});

  factory PostModel.empty() {
    return PostModel(
        uid: "",
        authorUid: "",
        userModel: UserModel(uid: "", nickname: "", email: ""),
        createdAt: Timestamp.now(),
        hasComments: false,
        imageUrl: "");
  }

  @override
  String toString() {
    return 'PostModel{uid: $uid, authorUid: $authorUid, description: $description, createdAt: $createdAt, image: $image, imageUrl: $imageUrl, likeStatus: $likeStatus, likedBy: $likedBy, comments: $comments}';
  }
}
