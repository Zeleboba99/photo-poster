import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      BlocProvider.of<FeedBloc>(navigatorKey.currentState!.context).add(
          FeedChangeLikeStatusEvent(postModel: event.postModel, likeStatus: newLikeStatus)
      );
      PostModel postModel = event.postModel;
      postModel.likeStatus = newLikeStatus;
      yield PostScreenShowPostState(postModel: postModel, commentModels: previewComments);
    } else if (event is PostScreenRemovePostEvent) {
      _postRepository.removePost(event.postModel.uid);
      FeedShowPostsState feedState = (BlocProvider.of<FeedBloc>(navigatorKey.currentState!.context).state as FeedShowPostsState);
      List<PostModel> adjustedPosts = feedState.loadedPosts;
      print(adjustedPosts.length);

      adjustedPosts.removeWhere((element) => element.uid == event.postModel.uid);

      BlocProvider.of<FeedBloc>(navigatorKey.currentContext).add(FeedAdjustPostsEvent(adjustedPosts: adjustedPosts));
      print(adjustedPosts.length);

      if (BlocProvider.of<ProfileBloc>(navigatorKey.currentState!.context).state is ProfileShowPostsState) {
        ProfileShowPostsState profileShowPostsState = (BlocProvider.of<ProfileBloc>(navigatorKey.currentState!.context).state as ProfileShowPostsState);
        BlocProvider.of<ProfileBloc>(navigatorKey.currentState!.context).add(ProfileAdjustPostsEvent(adjustedPosts: adjustedPosts, userModel: profileShowPostsState.loadedUser));
      }

    } else {
      // FeedErrorState
      yield PostScreenErrorState();
    }
    print("end mapEventToState PostScreenBloc");
  }
}
