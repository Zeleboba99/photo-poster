import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/models/user.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_block.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_event.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_state.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_event.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_state.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_event.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_state.dart';
import 'package:mobile_apps/services/post_repository.dart';
import 'package:mobile_apps/services/user_repository.dart';

import '../../../main.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UsersRepository _usersRepository = UsersRepository();
  PostRepository _postRepository = PostRepository();

  @override
  ProfileState get initialState => ProfileLoadingState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    print("start mapEventToState PostScreenBloc" + event.toString());

    List<PostModel> feedPosts = [];
    FeedState feedState = BlocProvider.of<FeedBloc>(navigatorKey.currentState!.context).state;
    if (feedState is FeedShowPostsState) {
      feedPosts = (feedState as FeedShowPostsState).loadedPosts;
    }

    if (event is ProfileInitialEvent) {
      yield ProfileLoadingState();
      Future<UserModel> futureUserModel = _usersRepository.getUser(userUid: event.userUid);
      String userUid = event.userUid;
      print(ModalRoute.of(navigatorKey.currentContext!));
      List<PostModel> posts = await _postRepository.getPostsForUser(event.userUid);
      syncWithFeed(posts, feedPosts);
      yield ProfileShowPostsState(loadedPosts: posts, loadedUser: await futureUserModel);
    } else if (event is ProfileLoadEvent) {
      Future<UserModel> futureUserModel = _usersRepository.getUser(userUid: event.userUid);
      List<PostModel> posts = [];
      if (state is ProfileShowPostsState && event.reloadAll != true) {
        Future<UserModel> futureUserModel = _usersRepository.getUser(userUid: event.userUid);
        posts = (state as ProfileShowPostsState).loadedPosts;
        posts.addAll(await _postRepository.getPostsForUser(event.userUid, after: (state as ProfileShowPostsState).lastCreatedAt));
      } else {
        posts = await _postRepository.getPostsForUser(event.userUid);
      }
      syncWithFeed(posts, feedPosts);
      yield ProfileShowPostsState(loadedPosts: posts, loadedUser: await futureUserModel);
    } else if (event is ProfileAdjustPostsEvent) {
      yield ProfileShowPostsState(loadedPosts: event.adjustedPosts, loadedUser: event.userModel);
    } else {
      // FeedErrorState
      yield ProfileErrorState();
    }
    print("end mapEventToState PostScreenBloc");
  }

  syncWithFeed(List<PostModel> posts, List<PostModel> feedPosts) {
    for(PostModel post in posts) {
      print("syncWithFeed");
      if (feedPosts.any((element) => element.uid == post.uid)) {
        PostModel feedPost = feedPosts.firstWhere((element) =>
        element.uid == post.uid);
        post.likeStatus = feedPost.likeStatus;
      }
    }
  }
}