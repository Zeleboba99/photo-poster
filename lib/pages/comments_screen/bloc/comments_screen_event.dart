import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/post.dart';

@immutable
abstract class CommentsEvent extends Equatable {
  CommentsEvent([List props = const []]) : super(props);
}

class CommentsInitialEvent extends CommentsEvent {
  PostModel postModel;

  CommentsInitialEvent({required this.postModel}) : super([postModel]);

  @override
  String toString() => 'CommentsInitialEvent { postUid :$postModel }';
}

class CommentsLoadEvent extends CommentsEvent {
  PostModel postModel;

  CommentsLoadEvent({required this.postModel}) : super([postModel]);

  @override
  String toString() => 'CommentsLoadEvent { postUid :$postModel }';
}

class CommentBodyChanged extends CommentsEvent {
  final String commentBody;
  PostModel postModel;

  CommentBodyChanged({required this.commentBody, required this.postModel}) : super([commentBody, postModel]);

  @override
  String toString() => 'CommentBodyChanged { commentBody :$commentBody }';
}

class CommentSubmitted extends CommentsEvent {
  final CommentModel commentModel;
  PostModel postModel;

  CommentSubmitted({required this.commentModel, required this.postModel}) : super([commentModel, postModel]);

  @override
  String toString() {
    return 'CommentSubmitted { commentModel: $commentModel, postUid: $postModel }';
  }
}

class CommentRemoved extends CommentsEvent {
  final CommentModel commentModel;
  PostModel postModel;

  CommentRemoved({required this.commentModel, required this.postModel}) : super([commentModel, postModel]);

  @override
  String toString() {
    return 'CommentRemoved { commentModel: $commentModel, postUid: $postModel }';
  }
}