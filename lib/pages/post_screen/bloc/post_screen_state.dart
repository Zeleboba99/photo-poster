import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/post.dart';

abstract class PostScreenState {
}

class PostScreenInitialState extends PostScreenState {}

class PostScreenShowPostState extends PostScreenState {
  PostModel postModel;
  List<CommentModel> commentModels;
  PostScreenShowPostState({required this.postModel, required this.commentModels});
}

class PostScreenErrorState extends PostScreenState {}
