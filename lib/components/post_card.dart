import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/models/user.dart';
import 'package:mobile_apps/pages/comments_screen/bloc/comments_screen_bloc.dart';
import 'package:mobile_apps/pages/comments_screen/bloc/comments_screen_event.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_block.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_event.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_bloc.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_event.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_state.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_bloc.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_event.dart';
import 'package:intl/intl.dart';
import 'package:mobile_apps/services/converters/date_converter.dart';


class PostCard extends StatelessWidget {
  final UserModel? user;
  final PostModel? post;
  final FeedBloc? feedBloc;
  final PostScreenBloc? postScreenBloc;
  final ProfileBloc? profileBloc;
  final CommentsBloc? commentsBloc;
  final bool isFullPostView;

  const PostCard(
      {Key? key,
      this.user,
      this.post,
      this.feedBloc,
      this.postScreenBloc,
      this.profileBloc,
      this.commentsBloc,
      required this.isFullPostView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("rebuild PostCard");
    return Container(
      color: Colors.white,
      height: 400,
      child: Column(
        children: [
          Container(child: _buildPostHeader(context)),
          Expanded(
            child: _buildImage(context),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(child: _buildLikeIcon(context)),
                      Container(child: _buildCommentIcon(context)),
                    ],
                  ),
                  Row(
                    children: [
                      // todo remove author
                      Expanded(child: Text(post!.description != null
                          ? post!.description!
                          : "",
                        softWrap: true,
                        maxLines: 4,
                      ))
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  EdgeInsets get _bottomMargin => EdgeInsets.only(
        bottom: 30,
      );

  Decoration get _boxDecoration => BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      );

  Widget _buildImage(BuildContext context) => Container(
          child: GestureDetector(
        child: Image(
          image: Image.memory(post!.image!.buffer.asUint8List()).image,
        ),
        onTap: () {
          postScreenBloc!.add(PostScreenStartedEvent(postModel: post!));
          // Navigator.pushNamed(context, '/post');
        },
      ));

  Widget _buildLikeIcon(BuildContext context) => Container(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: IconButton(
        icon: Icon(
          post!.likeStatus == LikeStatus.inactive
              ? Icons.favorite_border_outlined
              : Icons.favorite,
          color: post!.likeStatus == LikeStatus.inactive
              ? Colors.black87
              : Colors.redAccent,
          size: 36,
        ),
        onPressed: () {
          print("on like tap from post card isFullPostView = " +
              isFullPostView.toString());
          if (isFullPostView) {
            postScreenBloc!
                .add(PostScreenChangeLikeStatusEvent(postModel: post!));
          } else {
            LikeStatus newLikeStatus = post!.likeStatus == LikeStatus.inactive ? LikeStatus.active : LikeStatus.inactive;
            feedBloc!.add(FeedChangeLikeStatusEvent(postModel: post!, likeStatus: newLikeStatus));
          }
        },
      )
      );

  Widget _buildCommentIcon(BuildContext context) => Container(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: IconButton(
        icon: Icon(
          post!.hasComments == true
              ? Icons.comment
              : Icons.comment_outlined,
          color: Colors.black87,
          size: 36,
        ),
        onPressed: () {
          commentsBloc!.add(CommentsLoadEvent(postModel: post!));
          Navigator.pushNamed(context, '/comments');
        },
      ));

  Widget _buildOptionsIcon(BuildContext context) {
    List<PopupMenuEntry> popupMenuItems = [];
    popupMenuItems.add(PopupMenuItem(
      child: Text("Complain"),
      value: 1,
      onTap: () {
        final snackBar = SnackBar(
          content: const Text('Your complain has been accepted'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    ));
    popupMenuItems.add(PopupMenuItem(
      child: Text("Share post"),
      value: 1,
      onTap: () {
        final snackBar = SnackBar(
          content: const Text('Copied'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    ));
    if (isFullPostView == true) {
      popupMenuItems.add(PopupMenuItem(
        child: GestureDetector(
          child: Text("Delete post"),
          onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete post?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, '');
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    print("pressed");
                    postScreenBloc!.add(PostScreenRemovePostEvent(postModel: post!));
                    Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false, arguments: post!.authorUid);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          ),
        ),
        value: 2,
      ));
    }
    return Container(
        padding: EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black87,
              size: 36,
            ),
            itemBuilder: (context) => popupMenuItems
        ));
  }
  Widget _buildPostHeader(BuildContext context) => Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              profileBloc!.add(ProfileInitialEvent(userUid: post!.authorUid));
              Navigator.pushNamed(context, '/profile', arguments: post!.authorUid);
            },
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: post!.userModel.avatar != null
                      ? CircleAvatar(backgroundImage: Image.memory(post!.userModel.avatar!.buffer.asUint8List()).image, radius: 18,)
                      : const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.black87,
                    size: 36
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post != null
                          ? post!.userModel.nickname
                          : "Nickname" /*user!.name*/),
                      Text(post != null
                          ? DateConverter.convertToLongDate(post!.createdAt)
                          : "Date")
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildOptionsIcon(context)
        ],
      ));
}
