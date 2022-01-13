import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/components/comment_item.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/components/post_card.dart';
import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/pages/comments_screen/bloc/comments_screen_bloc.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_block.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_bloc.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_state.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_bloc.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  PostModel? postModel;
  List<CommentModel>? commentModels = [];
  late PostScreenBloc _postScreenBloc;
  late FeedBloc _feedBloc;
  late ProfileBloc _profileBloc;
  late CommentsBloc _commentsBloc;

  @override
  void initState() {
    _feedBloc = BlocProvider.of<FeedBloc>(context);
    _postScreenBloc = BlocProvider.of<PostScreenBloc>(context);
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _commentsBloc = BlocProvider.of<CommentsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Scaffold(
          body: BlocBuilder<PostScreenBloc, PostScreenState>(
              builder: (context, state) {
                if (state is PostScreenShowPostState) {
                  return Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        _postBuilder(),
                        _commentsBuilder(state),
                        Divider(
                          color: Colors.black87,
                        )
                      ],
                    ),
                  );
                }
                return CircularProgressIndicator();
          }),
          bottomNavigationBar: const NavigationBar()),
    );
  }

  Widget _postBuilder() {
    if (_postScreenBloc.state is PostScreenShowPostState) {
      postModel = (_postScreenBloc.state as PostScreenShowPostState).postModel;
      return PostCard(
        isFullPostView: true,
        post: postModel,
        postScreenBloc: _postScreenBloc,
        feedBloc: _feedBloc,
        profileBloc: _profileBloc,
        commentsBloc: _commentsBloc,
      );
    }
    return PostCard(isFullPostView: true);
  }

  Widget _commentsBuilder(PostScreenState state) {
    List<CommentModel> comments = (state as PostScreenShowPostState).postModel.comments == null
        ? []
        : state.postModel.comments!;
    return Container(
        child: Expanded(
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.black54,
              thickness: 1,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (BuildContext context, int index) {
              return CommentItem(
                commentModel: comments[index],
                commentsBloc: _commentsBloc,
                postModel: (state as PostScreenShowPostState).postModel,
              );
            },
          ),
        ));
  }
}
