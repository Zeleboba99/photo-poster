import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_block.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_event.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_state.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_bloc.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_event.dart';
import 'package:mobile_apps/services/post_repository.dart';
import 'package:mobile_apps/services/validators.dart';

import '../../../main.dart';
import 'comments_screen_event.dart';
import 'comments_screen_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  PostRepository _postRepository = PostRepository();

  @override
  CommentsState get initialState => CommentsLoadingState(true, [], PostModel.empty());

  @override
  Stream<CommentsState> mapEventToState(CommentsEvent event) async* {
    if (event is CommentBodyChanged) {
      yield* _mapCommentBodyChangedToState(event.commentBody);
    } else if (event is CommentSubmitted) {
      yield* _mapCommentSubmittedToState(
        postModel: event.postModel,
        commentModel: event.commentModel,
      ); 
    } else if (event is CommentRemoved) {
      yield* _mapCommentRemovedToState(
        postModel: event.postModel,
        commentModel: event.commentModel,
      );
    } else if (event is CommentsLoadEvent) {
      yield* _mapCommentsLoadToState(
        postModel: event.postModel,
      );
    }
  }

  Stream<CommentsState> _mapCommentBodyChangedToState(String commentBody) async* {
    state.isBodyValid = Validators.isValidCommentBody(commentBody);
    yield state;
  }

  Stream<CommentsState> _mapCommentSubmittedToState({
    required PostModel postModel,
    required CommentModel commentModel,
  }) async* {
    print("_mapCommentSubmittedToState start");
    yield CommentsSubmittingState(state.isBodyValid, state.loadedComments, state.postModel);
    try {
      //todo
      await _postRepository.leaveComment(commentModel);
      state.postModel.comments!.insert(0, commentModel);
      state.postModel.hasComments = state.postModel.comments!.length > 0 ? true : false;
      var postScreenBloc = BlocProvider.of<PostScreenBloc>(navigatorKey.currentContext!);
      postScreenBloc.add(PostScreenStartedEvent(postModel: state.postModel, redirect: false));
      var feedBloc = BlocProvider.of<FeedBloc>(navigatorKey.currentContext!);
      print(state.postModel.hasComments);
      (feedBloc.state as FeedShowPostsState).loadedPosts.where((element) => element.uid == state.postModel.uid).first.hasComments = state.postModel.hasComments;
      feedBloc.add(FeedAdjustPostsEvent(adjustedPosts: (feedBloc.state as FeedShowPostsState).loadedPosts));

      yield CommentsShowState(state.isBodyValid, state.loadedComments, state.postModel);
    } catch (_) {
      yield CommentsSubmittingErrorState(state.isBodyValid, state.loadedComments, state.postModel);
    }
    print("_mapCommentSubmittedToState end");
  }
  
  Stream<CommentsState> _mapCommentRemovedToState({
    required PostModel postModel,
    required CommentModel commentModel,
  }) async* {
    print("_mapCommentSubmittedToState start");
    yield CommentsSubmittingState(state.isBodyValid, state.loadedComments, state.postModel);
    try {
      await _postRepository.removeComment(commentModel.uid);
      state.postModel.comments!.removeWhere((element) => element.uid == commentModel.uid);
      state.postModel.hasComments = state.postModel.comments!.length > 0 ? true : false;
      var postScreenBloc = BlocProvider.of<PostScreenBloc>(navigatorKey.currentContext!);
      print(state.postModel.comments!.length);
      postScreenBloc.add(PostScreenStartedEvent(postModel: state.postModel, redirect: false, reloadComments: false));
      var feedBloc = BlocProvider.of<FeedBloc>(navigatorKey.currentContext!);
      (feedBloc.state as FeedShowPostsState).loadedPosts.where((element) => element.uid == state.postModel.uid).first.hasComments = state.postModel.hasComments;
      feedBloc.add(FeedAdjustPostsEvent(adjustedPosts: (feedBloc.state as FeedShowPostsState).loadedPosts));
      yield CommentsShowState(state.isBodyValid, state.loadedComments, state.postModel);
    } catch (_) {
      yield CommentsSubmittingErrorState(state.isBodyValid, state.loadedComments, state.postModel);
    }
    print("_mapCommentSubmittedToState end");
  }

  Stream<CommentsState> _mapCommentsLoadToState({
    required PostModel postModel,
  }) async* {
    print("_mapCommentSubmittedToState start");
    yield CommentsLoadingState(state.isBodyValid, state.loadedComments, postModel);
    List<CommentModel> loadedComments = await _postRepository.getComments(postModel.uid);
    postModel.comments = loadedComments;
    postModel.hasComments = postModel.comments != null && postModel.comments!.length > 0;
    yield CommentsShowState(state.isBodyValid, loadedComments, postModel);
    print("_mapCommentSubmittedToState end");
  }
}