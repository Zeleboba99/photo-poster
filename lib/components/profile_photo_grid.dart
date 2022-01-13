import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/new_post_bloc/new_post_bloc.dart';
import 'package:mobile_apps/new_post_bloc/new_post_event.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_bloc.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_event.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_bloc.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_state.dart';
import 'package:mobile_apps/services/database.dart';

class ProfilePhotoGrid extends StatelessWidget {
  ProfileBloc _profileBloc;
  PostScreenBloc _postScreenBloc;

  ProfilePhotoGrid(this._profileBloc, this._postScreenBloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: _getPhotos(context));
  }

  List<Widget> _getPhotos(BuildContext context) {
    List<Widget> list = <Widget>[];
    if (_profileBloc.state is ProfileShowPostsState) {
      List<PostModel> posts = (_profileBloc.state as ProfileShowPostsState).loadedPosts;
      for (int i = 0; i < posts.length; i++) {
        list.add(GestureDetector(
          onTap: () {
            _postScreenBloc.add(PostScreenStartedEvent(postModel: posts[i]));
            print("On picture click");
          },
          child: Container(
            child: Image(
              image: Image.memory(posts[i].image!.buffer.asUint8List()).image,
              fit: BoxFit.cover,
            ),
            color: Colors.teal[100],
          ),
        ));
      }
    }

    return list;
  }
}
