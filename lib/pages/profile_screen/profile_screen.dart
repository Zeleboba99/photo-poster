import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_event.dart';
import 'package:mobile_apps/authentication_bloc/authentication_state.dart';
import 'package:mobile_apps/components/bottom_sheet_menu.dart';
import 'package:mobile_apps/components/photo_grid.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/components/profile_photo_grid.dart';
import 'package:mobile_apps/main.dart';
import 'package:mobile_apps/pages/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:mobile_apps/pages/edit_profile/bloc/edit_profile_event.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_bloc.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_event.dart';
import 'package:mobile_apps/services/user_repository.dart';

import 'bloc/profile_bloc.dart';
import 'bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthenticationBloc _authenticationBloc;
  late ProfileBloc _profileBloc;
  late PostScreenBloc _postScreenBloc;
  late EditProfileBloc _editProfileBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _postScreenBloc = BlocProvider.of<PostScreenBloc>(context);
    _editProfileBloc = BlocProvider.of<EditProfileBloc>(context);
  }

  @override
  void didChangeDependencies() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _profileBloc = BlocProvider.of<ProfileBloc>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoadingState) {
              return Center(child: CircularProgressIndicator());
          } else if (state is ProfileShowPostsState) {
            return RefreshIndicator(
              onRefresh: _refreshProfileGallery,
              child: Stack(
                children: <Widget>[ListView(),
                  _profileHeaderBuilder(context, state),
                  _menuBuilder(context, state),
                  _userGalleryBuilder(context),
                ],
              ),
            );

            // return Stack(
            //   children: [
            //     _profileHeaderBuilder(context, state),
            //     _menuBuilder(context, state),
            //     _userGalleryBuilder(context),
            //   ],
            // );
          } else {
            return Text("Something goes wrong during loading profile");
          }
        }),
      bottomNavigationBar: const NavigationBar(),
    );
  }

  Widget _profileHeaderBuilder(BuildContext context, ProfileState state) => Positioned(
    top: 30,
    child: Container(
        // width: double.infinity,
        padding: const EdgeInsets.fromLTRB(10, 10, 10 ,0),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                      ),
                      child:
                          (state as ProfileShowPostsState).loadedUser.avatar! != null
                              ? CircleAvatar(
                                  backgroundImage: Image.memory((state).loadedUser.avatar!.buffer
                                          .asUint8List())
                                      .image,
                                  radius: 28,
                                )
                              : const Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.black87,
                                  size: 50,
                                ),
                    ),
                    Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Column(
                    children: [
                      Text((state as ProfileShowPostsState).loadedUser.nickname,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 30,
                              fontWeight: FontWeight.w300
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
            (_authenticationBloc.state as Authenticated).userModel.uid == state.loadedUser.uid
            ? Row(
              // width: double.infinity,
              children:[ OutlinedButton(
                onPressed: () {
                  _editProfileBloc.add(EditProfileInitialEvent(userModel: (_authenticationBloc.state as Authenticated).userModel));
                  // Navigator.pushNamed(context, '/edit-profile');
                },
                child: Text('EDIT PROFILE'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
              )]
            )
            : Container()
          ],
        )
    ),
  );

  Widget _menuBuilder(BuildContext context, ProfileState state) => Builder(
      builder: (context) => Positioned(
        top: 40,
        right: 20,
        child: IconButton(
          icon: const Icon(Icons.menu, size: 40,),
          onPressed: () {
            Scaffold.of(context).showBottomSheet<void>(
                  (BuildContext context) {
                return Container(
                  height: 200,
                  color: Color.fromRGBO(219, 214, 214, 1),
                  child: Center(
                    child:
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(),),
                            ),
                            child: ListTile(
                              title: Row(
                                children: const [
                                  Icon(Icons.mobile_screen_share_outlined, size: 25),
                                  Text(" Share profile", style: TextStyle(fontSize: 18),),
                                ],
                              )
                            ),
                          ),
                          onTap: () async {
                            print(await _createDynamicLink((state as ProfileShowPostsState).loadedUser.uid));
                            String link = await _createDynamicLink((state as ProfileShowPostsState).loadedUser.uid);
                            Clipboard.setData(ClipboardData(text: link)).then((_){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Link copied to clipboard")));
                            });
                          },
                        ),
                        // (_authenticationBloc.state as Authenticated).userModel.uid == (state as ProfileShowPostsState).loadedUser.uid
                        // ? GestureDetector(
                        //   child: Container(
                        //     height: 50,
                        //     decoration: const BoxDecoration( //                    <-- BoxDecoration
                        //       border: Border(bottom: BorderSide()),
                        //     ),
                        //     child: ListTile(
                        //       title: Row(
                        //         children: const [
                        //           Icon(Icons.delete, size: 25),
                        //           Text(" Delete profile", style: TextStyle(fontSize: 18),)
                        //         ],
                        //       ),
                        //     ),),
                        //   onTap: () {print("12345;");},
                        // )
                        // : Container(),
                        (_authenticationBloc.state as Authenticated).userModel.uid == (state as ProfileShowPostsState).loadedUser.uid
                        ? GestureDetector(
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration( //                    <-- BoxDecoration
                              border: Border(bottom: BorderSide()),
                            ),
                            child: ListTile(
                              title: Row(
                                children: const [
                                  Icon(Icons.exit_to_app, size: 25),
                                  Text(" Sign out", style: TextStyle(fontSize: 18),)
                                ],
                              ),
                            ),),
                          onTap: () {
                            print("12345;");
                            _authenticationBloc.add(LoggedOut());

                            Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

                            // Navigator.popUntil(context, (route) {
                            //   print(route.settings.name);
                            //   if (route.settings.name == '/') {
                            //     print("eq");
                            //     return true;
                            //   }
                            //   print("neq");
                            //   return false;
                            // });

                            // Navigator.of(context).pop();
                            // print(Navigator.of(context).restorationId);
                            // Navigator.of(context).pop();
                            // print(Navigator.of(context).restorationId);

                            // Navigator.of(context).popUntil(ModalRoute.withName("/login"));
                            // Navigator.of(context).pushReplacementNamed('/login');
                            // Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                          },
                        )
                        : Container(),
                        // ElevatedButton(
                        //     child: const Text('Close BottomSheet'),
                        //     onPressed: () {
                        //       Navigator.pop(context);
                        //     })
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      )
  );

  Widget _userGalleryBuilder(BuildContext context) => Positioned(
    // top: 10,
    child: Container(
      margin: EdgeInsets.only(top: 130),
      child: ProfilePhotoGrid(_profileBloc, _postScreenBloc),
    ),
  );


  Future<String> _createDynamicLink(String userUid) async {
    print("create dyn link start");
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: "https://photoposter.page.link",
        link: Uri.parse('https://photoposter.page.link/profile/$userUid'),
        androidParameters: AndroidParameters(
            packageName: 'ru.vsu.cs.poster.mobile_apps',
            minimumVersion: 0
        ));
    Uri url = await parameters.buildUrl();
    return url.toString();
  }

  Future<Null> _refreshProfileGallery() async {
    print('refreshing');
    BlocProvider.of<ProfileBloc>(navigatorKey.currentContext).add(
        ProfileLoadEvent(
            reloadAll: true,
            userUid: (BlocProvider.of<ProfileBloc>(navigatorKey.currentContext)
                    .state as ProfileShowPostsState)
                .loadedUser
                .uid));
  }
}
