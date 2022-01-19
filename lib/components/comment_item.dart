import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/pages/comments_screen/bloc/comments_screen_bloc.dart';
import 'package:mobile_apps/pages/comments_screen/bloc/comments_screen_event.dart';
import 'package:mobile_apps/services/converters/date_converter.dart';

class CommentItem extends StatelessWidget {
  CommentModel commentModel;
  PostModel postModel;
  CommentsBloc commentsBloc;

  CommentItem({Key? key, required this.commentModel, required this.postModel, required this.commentsBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          commentModel.userModel.avatar != null
              ? CircleAvatar(backgroundImage: Image.memory(commentModel.userModel.avatar!.buffer.asUint8List()).image, radius: 18,)
              : const Icon(
              Icons.account_circle_outlined,
              color: Colors.black87,
              size: 36
          ),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          commentModel.userModel.nickname,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: 210,
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          commentModel.text,
                          textAlign: TextAlign.left,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  Column(children: [
                    Row(
                      children: [
                        Text(DateConverter.convertToShortDate(commentModel.createdAt)),
                        ModalRoute.of(context)!.settings.name == '/comments' ?
                        IconButton(
                            icon: Icon(Icons.delete, size: 25,),
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete comment?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => {},
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      commentsBloc.add(CommentRemoved(commentModel: commentModel, postModel: postModel));
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            )
                        ):
                            Container()
                      ],
                    )
                  ],)
                ],
              ))
        ],
      ),
    );
  }
}
