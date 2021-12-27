import 'package:cloud_firestore/cloud_firestore.dart';

enum LikeStatus{
  active,
  inactive,
}

class Post {
  String id;
  String name;
  String date;
  String imageUrl;
  LikeStatus? likeStatus;

  Post({required this.id, required this.name, required this.date, required this.imageUrl, this.likeStatus});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      imageUrl: json['imageUrl'],
      likeStatus: json['likeStatus'],
    );
  }
}