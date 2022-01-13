import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/services/post_provider.dart';


class PostRepository{
  final PostProvider _postProvider = PostProvider();

  Future<List<PostModel>> getPostsForUser(String userUid, {Timestamp? after}) async => _postProvider.getPostsByUserUid(userUid, after: after);
  Future<List<PostModel>> getPost(String postUid) => _postProvider.getPost(postUid);
  Future<List<PostModel>> getPosts({Timestamp? after}) => _postProvider.getPosts(after: after);

  Future<List<CommentModel>> getComments(String postUid, {Timestamp? after, bool? forPreviewMode}) => _postProvider.getComments(postUid, after: after, forPreviewMode: forPreviewMode);
  bool hasComments(PostModel postModel) => _postProvider.hasComments(postModel);

  Future<void> likePost(LikeStatus newLikeStatus, PostModel postModel, String userUid) => _postProvider.setLike(newLikeStatus, postModel, userUid);

  Future<void> publishPost(PostModel postModel) async => _postProvider.publishPost(postModel);
  Future<void> leaveComment(CommentModel commentModel) => _postProvider.leaveComment(commentModel);

  Future<void> removePost(String postUid) => _postProvider.removePost(postUid);
  Future<void> removeComment(String commentUid) async => _postProvider.removeComment(commentUid);

  Future<void> complain(String postUid) => _postProvider.complain(postUid);
}