import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_state.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_bloc.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_event.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_state.dart';

import '../main.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  late AuthenticationBloc _authenticationBloc;


  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return _navigationBarV2Builder(context);
  }

  Widget _navigationBarV2Builder(BuildContext context) => BottomAppBar(
    // shape: shape,
    color: Colors.white,
    child: IconTheme(
      data: IconThemeData(color: Colors.black87),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.only(left: 20),
            iconSize: 36,
            icon: const Icon(Icons.home_outlined, color: Colors.black87,),
            onPressed: () {
              print(ModalRoute.of(context)!.settings.name);
              if (ModalRoute.of(context)!.settings.name != '/feed') {
                Navigator.pushNamedAndRemoveUntil(context, '/feed', (route) => false);
              }
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              if (ModalRoute.of(context)!.settings.name != '/new-post-choose-photo') {
                Navigator.pushNamed(context, '/new-post-choose-photo');
              }
            }, child: Icon(Icons.add),
          ),
          IconButton(
            padding: EdgeInsets.only(right: 20),
            icon: const Icon(Icons.person_outline, color: Colors.black87,),
            iconSize: 36,
            onPressed: () {
              if (_authenticationBloc.state is Authenticated) {
                String userUid = (_authenticationBloc.state as Authenticated)
                    .userModel.uid;
                print("args " + ModalRoute.of(context)!.settings.toString());
                print("args " + ModalRoute.of(context)!.settings.name.toString());
                if (ModalRoute.of(context)!.settings.name != '/profile'
                    || ModalRoute.of(context)!.settings.arguments != userUid) {
                  if (BlocProvider.of<ProfileBloc>(context).state is ProfileShowPostsState) {
                    if ((BlocProvider.of<ProfileBloc>(context).state as ProfileShowPostsState).loadedUser.uid != userUid) {
                      BlocProvider.of<ProfileBloc>(context).add(
                          ProfileInitialEvent(userUid: userUid)
                      );
                    }
                  }
                  Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false, arguments: userUid);
                }
              }
            },
          ),
        ],
      ),
    ),
  );
}
