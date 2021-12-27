abstract class FeedState {}

class FeedInitialState extends FeedState {}

class FeedShowPostsState extends FeedState {
  List<dynamic> loadedPosts;
  FeedShowPostsState({required this.loadedPosts});
}

class FeedErrorState extends FeedState {}
