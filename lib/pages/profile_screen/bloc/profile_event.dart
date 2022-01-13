import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/models/user.dart';

abstract class ProfileEvent{
}

class ProfileInitialEvent extends ProfileEvent {
  bool reloadAll = true;
  String userUid;
  ProfileInitialEvent({required this.userUid});
}

class ProfileLoadEvent extends ProfileEvent {
  bool reloadAll;
  String userUid;
  ProfileLoadEvent({required this.reloadAll, required this.userUid});
}

class ProfileAdjustPostsEvent extends ProfileEvent {
  List<PostModel> adjustedPosts;
  UserModel userModel;

  ProfileAdjustPostsEvent({required this.adjustedPosts,  required this.userModel});
}