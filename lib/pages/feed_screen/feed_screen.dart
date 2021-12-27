import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mobile_apps/bloc/user_bloc.dart';
import 'package:mobile_apps/bloc/user_event.dart';
import 'package:mobile_apps/bloc/user_state.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/components/post_card.dart';
import 'package:mobile_apps/services/database.dart';
import 'package:mobile_apps/services/user_repository.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  final UsersRepository usersRepository = UsersRepository();
  late UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    print("feed didChangeDependencies");
    _userBloc = BlocProvider.of<UserBloc>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Database.getPostByUid(postUid: '1234');
    print("rebuild feed");
    // Database.addUser(nickname: "qwer_nick", email: "qwe@mail.com");
    // usersRepository.getFirebaseUser().then((value) =>
    //     Database.addPost(description: "photo descr", date: "date", authorUid: value.uid)
    // );

    return Scaffold(
        backgroundColor: Colors.black87,
        body:
        Scaffold(
            body: _showImagesBuilder(),
            bottomNavigationBar: const NavigationBar()
        ),
    );
  }

  Widget _showImagesBuilder() {
    // return LazyLoadScrollView(
    //   onEndOfPage: () {  },

    return BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserEmptyState) {
            _userBloc.add(UserLoadEvent());
            return Center(
              child: Text(
                'No data received. Press button "Load"',
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }

          if (state is UserLoadingState) {

            return Center(child: CircularProgressIndicator());
          }

          if (state is UserErrorState) {
            return Center(
              child: Text(
                'Error fetching users',
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }

          if (state is UserLoadedState) {
            return Scrollbar(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black54, thickness: 1,),
                  // padding: EdgeInsets.all(16),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemCount: state.loadedUser.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PostCard(
                      user: state.loadedUser[index]
                    );
                  },
                )
            );
          }
            return null;
        }
    );


      // return Scrollbar(
      //     child: ListView.separated(
      //       separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black54, thickness: 1,),
      //       // padding: EdgeInsets.all(16),
      //       shrinkWrap: true,
      //       scrollDirection: Axis.vertical,
      //       physics: BouncingScrollPhysics(),
      //       itemCount: 3,
      //       itemBuilder: (BuildContext context, int index) {
      //         return PostCard(
      //         );
      //       },
      //     )
      // );
  }
}
