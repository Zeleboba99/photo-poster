import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_apps/models/post.dart';

abstract class FeedState {
}

class FeedInitialState extends FeedState {}

class FeedShowPostsState extends FeedState {
  List<PostModel> loadedPosts;
  Timestamp? lastCreatedAt;
  bool loadingInProcess;
  FeedShowPostsState({required this.loadedPosts, this.lastCreatedAt, required this.loadingInProcess});
}

class FeedErrorState extends FeedState {}
