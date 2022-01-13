import 'package:mobile_apps/models/post.dart';

abstract class FeedEvent{
  bool? reloadAll = false;
  FeedEvent({this.reloadAll});
}

class FeedLoadEvent extends FeedEvent {
  FeedLoadEvent({reloadAll}) : super(reloadAll: reloadAll);

  @override
  String toString() {
    return 'FeedLoadEvent{}';
  }
}

class FeedAdjustPostsEvent extends FeedEvent {
  List<PostModel> adjustedPosts;
  FeedAdjustPostsEvent({required this.adjustedPosts}) : super(reloadAll: false);

  @override
  String toString() {
    return 'FeedAdjustPostsEvent{}';
  }
}

class FeedChangeLikeStatusEvent extends FeedEvent {
  PostModel postModel;
  LikeStatus likeStatus;
  FeedChangeLikeStatusEvent({required this.postModel, required this.likeStatus}) : super(reloadAll: false);

  @override
  String toString() {
    return 'FeedChangeLikeStatusEvent{}';
  }
}

class FeedSharePostEvent extends FeedEvent {
  FeedSharePostEvent({reloadAll}) : super(reloadAll: reloadAll);

  @override
  String toString() {
    return 'FeedSharePostEvent{}';
  }
}