import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/post.dart';

abstract class CommentsState {
  bool isBodyValid = true;
  List<CommentModel> loadedComments = [];
  PostModel postModel = PostModel.empty();

  CommentsState(this.isBodyValid, this.loadedComments, this.postModel);
}

class CommentsShowState extends CommentsState {
  CommentsShowState(bool isBodyValid, List<CommentModel> loadedComments, PostModel postUid) : super(isBodyValid, loadedComments, postUid);
}

class CommentsLoadingState extends CommentsState{
  CommentsLoadingState(bool isBodyValid, List<CommentModel> loadedComments, PostModel postUid) : super(isBodyValid, loadedComments, postUid);
}

class CommentsSubmittingState extends CommentsState {
  CommentsSubmittingState(bool isBodyValid, List<CommentModel> loadedComments, PostModel postUid) : super(isBodyValid, loadedComments, postUid);
}
class CommentsSubmittingErrorState extends CommentsState {
  CommentsSubmittingErrorState(bool isBodyValid, List<CommentModel> loadedComments, PostModel postUid) : super(isBodyValid, loadedComments, postUid);
}
class CommentsLoadingErrorState extends CommentsState {
  CommentsLoadingErrorState(bool isBodyValid, List<CommentModel> loadedComments, PostModel postUid) : super(isBodyValid, loadedComments, postUid);
}
