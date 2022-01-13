import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mobile_apps/bloc/user_bloc.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/components/post_card.dart';
import 'package:mobile_apps/pages/comments_screen/bloc/comments_screen_bloc.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_block.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_event.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_state.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_bloc.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_bloc.dart';
import 'package:mobile_apps/services/user_repository.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  final UsersRepository usersRepository = UsersRepository();
  late UserBloc _userBloc;
  late FeedBloc _feedBloc;
  late PostScreenBloc _postScreenBloc;
  late ProfileBloc _profileBloc;
  late CommentsBloc _commentsBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _feedBloc = BlocProvider.of<FeedBloc>(context);
    _postScreenBloc = BlocProvider.of<PostScreenBloc>(context);
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _commentsBloc = BlocProvider.of<CommentsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild feed");

    return Scaffold(
        backgroundColor: Colors.black87,
        body:
        Scaffold(
            body: _showImagesBuilder2(),
            bottomNavigationBar: const NavigationBar()
        ),
    );
  }

  Widget _showImagesBuilder2() {
    return BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state is FeedInitialState) {
            print("FeedLoadEvent added from _showImagesBuilder2");
            _feedBloc.add(FeedLoadEvent());
            return Center(
              child: new CircularProgressIndicator(),
            );
          }

          if (state is FeedErrorState) {
            return RefreshIndicator(
              onRefresh: _refreshLocalGallery,
              child: Stack(
                children: <Widget>[ListView(), Center(
            child: Text(
            'Error loading feed',
                style: TextStyle(fontSize: 20.0),
          ),
          )],
              ),
            );
          }

          if (state is FeedShowPostsState) {

              print("redraw feed");
              return LazyLoadScrollView(
                  child: RefreshIndicator(child:
                  BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 50,
                        sigmaY: 50,
                      ),
                      child: Container(
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(color: Colors.black54, thickness: 1,),
                          // padding: EdgeInsets.all(16),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemCount: state.loadedPosts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PostCard(
                              isFullPostView: false,
                              post: state.loadedPosts[index],
                              feedBloc: _feedBloc,
                              postScreenBloc: _postScreenBloc,
                              profileBloc: _profileBloc,
                              commentsBloc: _commentsBloc,
                            );
                          },
                        ),)
                  ),
                    onRefresh: _refreshLocalGallery,),
                  scrollOffset: 300,
                  onEndOfPage: () {
                    print("FeedLoadEvent added from onEndOfPage");
                    _feedBloc.add(FeedLoadEvent());
                  }
              );
            }

          return null;
        }
    );
  }

  Future<Null> _refreshLocalGallery() async{
    print('refreshing');
    _feedBloc.add(FeedLoadEvent(reloadAll: true));
  }
}
