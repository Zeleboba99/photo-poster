import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_state.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_event.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_state.dart';
import 'package:mobile_apps/services/post_repository.dart';
import 'package:mobile_apps/services/user_repository.dart';

import '../../../main.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  PostRepository _postRepository = PostRepository();

  @override
  FeedState get initialState => FeedInitialState();

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    print("start mapEventToState FeedBlock" + event.toString());
    if (event is FeedLoadEvent) {
      List<PostModel> loadedPostsList = [];
      if (state is FeedShowPostsState && event.reloadAll == true) {
        var currentState = (state as FeedShowPostsState);
        yield FeedShowPostsState(loadedPosts: currentState.loadedPosts,
            loadingInProcess: true, lastCreatedAt: currentState.lastCreatedAt);
      }
      if (state is FeedShowPostsState && event.reloadAll != true) {
        print("state is FeedShowPostsState");
        loadedPostsList = (state as FeedShowPostsState).loadedPosts;
        loadedPostsList.addAll(await _postRepository.getPosts(
            after: (state as FeedShowPostsState).lastCreatedAt));

      } else {
        loadedPostsList = await _postRepository.getPosts();
      }
      yield FeedShowPostsState(
          loadedPosts: loadedPostsList,
          lastCreatedAt: loadedPostsList.last.createdAt,
          loadingInProcess: false);
    } else if (event is FeedChangeLikeStatusEvent) {
      String postUid = event.postModel.uid;
      List<PostModel> loadedPostsList = [];
      if (state is FeedShowPostsState) {
        loadedPostsList = (state as FeedShowPostsState).loadedPosts;
        loadedPostsList.forEach((element) {
          if (element.uid == postUid) {
            element.likeStatus = event.likeStatus;
            var currentUserUid = (BlocProvider.of<AuthenticationBloc>(navigatorKey.currentContext!).state as Authenticated).userModel.uid;
            _postRepository.likePost(element.likeStatus!, element, currentUserUid);
            }
        });
      }

      yield FeedShowPostsState(
          loadedPosts: loadedPostsList,
          lastCreatedAt: loadedPostsList.last.createdAt,
          loadingInProcess: false);
    } else if (event is FeedAdjustPostsEvent) {
      var currentState = (state as FeedShowPostsState);
      yield FeedShowPostsState(loadedPosts: event.adjustedPosts,
          loadingInProcess: false, lastCreatedAt: currentState.lastCreatedAt);
    } else {
      // FeedErrorState
      yield FeedErrorState();
    }
    print("end mapEventToState FeedBlock");
  }
}
