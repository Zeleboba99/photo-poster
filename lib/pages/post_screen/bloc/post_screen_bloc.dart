import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_state.dart';
import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_block.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_event.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_state.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_event.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_state.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_bloc.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_event.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_state.dart';
import 'package:mobile_apps/services/post_repository.dart';
import 'package:mobile_apps/services/user_repository.dart';

import '../../../main.dart';

class PostScreenBloc extends Bloc<PostScreenEvent, PostScreenState> {
  PostRepository _postRepository = PostRepository();

  @override
  PostScreenState get initialState => PostScreenInitialState();

  @override
  Stream<PostScreenState> mapEventToState(PostScreenEvent event) async* {
    print("start mapEventToState PostScreenBloc" + event.toString());
    if (event is PostScreenStartedEvent) {
      if (event.reloadComments != false) {
        event.postModel.comments = await _postRepository.getComments(
            event.postModel.uid, forPreviewMode: true);
        event.postModel.hasComments = event.postModel.comments != null && event.postModel.comments!.length > 0;
      }
      yield PostScreenShowPostState(postModel: event.postModel, commentModels: event.postModel.comments!);
      if (event.redirect == null || event.redirect == true) {
        Navigator.pushNamed(navigatorKey.currentState!.context, '/post');
      }
    } else if (event is PostScreenChangeLikeStatusEvent) {
      List<CommentModel> previewComments = (state is PostScreenShowPostState) ? (state as PostScreenShowPostState).postModel.comments! : [];

      LikeStatus oldLikeStatus = event.postModel.likeStatus!;
      LikeStatus newLikeStatus = oldLikeStatus == LikeStatus.inactive ? LikeStatus.active : LikeStatus.inactive;
      // BlocProvider.of<FeedBloc>(navigatorKey.currentState!.context).add(
      //     FeedChangeLikeStatusEvent(postModel: event.postModel, likeStatus: newLikeStatus));
      PostModel postModel = event.postModel;
      postModel.likeStatus = newLikeStatus;
      var currentUserUid =
          (BlocProvider.of<AuthenticationBloc>(navigatorKey.currentContext!).state as Authenticated).userModel.uid;
      if (newLikeStatus == LikeStatus.active &&
          !postModel.likedBy!.any((element) => element == currentUserUid)) {
        postModel.likedBy!.add(currentUserUid);
      } else {
        postModel.likedBy!.remove(currentUserUid);
        print(postModel.likedBy);
        print(postModel);
      }
      yield PostScreenShowPostState(postModel: postModel, commentModels: previewComments);
      BlocProvider.of<FeedBloc>(navigatorKey.currentState!.context).add(
          FeedChangeLikeStatusEvent(postModel: event.postModel, likeStatus: newLikeStatus));
    } else if (event is PostScreenRemovePostEvent) {
      _postRepository.removePost(event.postModel.uid);
      FeedShowPostsState feedState = (BlocProvider.of<FeedBloc>(navigatorKey.currentState!.context).state as FeedShowPostsState);
      List<PostModel> adjustedFeedPosts = feedState.loadedPosts;
      print(adjustedFeedPosts.length);

      adjustedFeedPosts.removeWhere((element) => element.uid == event.postModel.uid);

      BlocProvider.of<FeedBloc>(navigatorKey.currentContext).add(FeedAdjustPostsEvent(adjustedPosts: adjustedFeedPosts));
      print(adjustedFeedPosts.length);

      if (BlocProvider.of<ProfileBloc>(navigatorKey.currentState!.context).state is ProfileShowPostsState) {
        ProfileShowPostsState profileShowPostsState = (BlocProvider.of<ProfileBloc>(navigatorKey.currentState!.context).state as ProfileShowPostsState);
        List<PostModel> adjustedProfilePosts = profileShowPostsState.loadedPosts;
        adjustedProfilePosts.removeWhere((element) => element.uid == event.postModel.uid);
        BlocProvider.of<ProfileBloc>(navigatorKey.currentState!.context).add(ProfileAdjustPostsEvent(adjustedPosts: adjustedProfilePosts, userModel: profileShowPostsState.loadedUser));
      }

    } else {
      // FeedErrorState
      yield PostScreenErrorState();
    }
    print("end mapEventToState PostScreenBloc");
  }
}
