import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_state.dart';
import 'package:mobile_apps/components/comment_item.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/main.dart';
import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/models/user.dart';
import 'package:mobile_apps/pages/comments_screen/bloc/comments_screen_state.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_bloc.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_state.dart';

import 'bloc/comments_screen_bloc.dart';
import 'bloc/comments_screen_event.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late CommentsBloc _commentsBloc;
  late PostScreenBloc _postScreenBloc;
  late AuthenticationBloc _authenticationBloc;

  final TextEditingController _commentBodyController = TextEditingController();

  @override
  void initState() {
    _commentsBloc = BlocProvider.of<CommentsBloc>(context);
    _postScreenBloc = BlocProvider.of<PostScreenBloc>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    _commentBodyController.addListener(_onCommentBodyChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Scaffold(
          body: BlocBuilder<CommentsBloc, CommentsState>(
              builder: (context, state) {
            return Container(
              margin: EdgeInsets.only(top: 25),
              child: Column(
                children: [
                  _commentsHeaderBuilder(context, state),
                  _commentsBuilder(context, state),
                  Divider(
                    color: Colors.black87,
                  ),
                  _commentTextFieldBuilder(context, state)
                ],
              ),
              // child: _buildOptionsIcon(context),
            );
          }),
          bottomNavigationBar: const NavigationBar()),
    );
  }

  Widget _commentsBuilder(BuildContext context, CommentsState state) {
    if (state is CommentsLoadingState) {
      return CircularProgressIndicator();
    } else if (state is CommentsLoadingErrorState) {
      return Text("Error occurred during loading");
    } else {
      return Container(
          child: Expanded(
              child: Scrollbar(
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(
            color: Colors.black54,
            thickness: 1,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemCount: state.postModel.comments!.length,
          itemBuilder: (BuildContext context, int index) {
            return CommentItem(commentModel: state.postModel.comments![index], commentsBloc: _commentsBloc, postModel: state.postModel,);
          },
        ),
      )));
    }
  }

  Widget _commentsHeaderBuilder(BuildContext context, CommentsState state) =>
      Container(
        child: Row(
          children: [
            IconButton(
                icon: const Icon(
                  Icons.keyboard_backspace,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            const Spacer(
              flex: 2,
            ),
            Container(
              // alignment: Alignment.topCenter,
              child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: const Text("Comments",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 40,
                              fontWeight: FontWeight.w300)))),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      );

  _commentTextFieldBuilder(BuildContext context, CommentsState state) {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        child: TextFormField(
          controller: _commentBodyController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Your comment",
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _onCommentSubmit(state);
                },
              )),
          autovalidate: true,
          autocorrect: false,
        ));
  }

  void _onCommentBodyChanged() {

    CommentsState commentState = BlocProvider.of<CommentsBloc>(navigatorKey.currentState!.context).state;
    PostModel postModel = commentState.postModel;
    // }
    _commentsBloc.add(CommentBodyChanged(
        commentBody: _commentBodyController.text, postModel: postModel));
  }

  void _onCommentSubmit(CommentsState state) {
    print("start _onCommentSubmit");
    print(_postScreenBloc.state);

    PostModel postModel = state.postModel;
    UserModel author =
        (_authenticationBloc.state as Authenticated).userModel;
    CommentModel commentModel = CommentModel(
        uid: "",
        authorUid: author.uid,
        postUid: postModel.uid,
        text: _commentBodyController.text,
        createdAt: Timestamp.now(),
        userModel: author);
    _commentsBloc
        .add(CommentSubmitted(commentModel: commentModel, postModel: postModel));
    _commentBodyController.text = "";
  }
}
