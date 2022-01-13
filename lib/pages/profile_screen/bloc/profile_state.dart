import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/models/user.dart';

abstract class ProfileState {
}

class ProfileLoadingState extends ProfileState {}

class ProfileShowPostsState extends ProfileState {
  List<PostModel> loadedPosts;
  UserModel loadedUser;
  Timestamp? lastCreatedAt;
  ProfileShowPostsState({required this.loadedPosts, this.lastCreatedAt, required this.loadedUser});
}

class ProfileErrorState extends ProfileState {}