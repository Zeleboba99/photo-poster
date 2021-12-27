import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_event.dart';
import 'package:mobile_apps/components/bottom_sheet_menu.dart';
import 'package:mobile_apps/components/photo_grid.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/services/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthenticationBloc _authenticationBloc;

  @override
  void didChangeDependencies() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _profileHeaderBuilder(),
          _menuBuilder(),
          _userGalleryBuilder(),
        ],
      ),
      bottomNavigationBar: const NavigationBar(),
    );
  }

  Widget _profileHeaderBuilder() => Positioned(
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
                  child: const Icon(Icons.account_circle_outlined, color: Colors.black87, size: 50,),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Column(
                    children: const [
                      Text("Nickname",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 30,
                              fontWeight: FontWeight.w300
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              // width: double.infinity,
              children:[ OutlinedButton(
                onPressed: () {},
                child: Text('EDIT PROFILE'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
              )]
            )
          ],
        )
    ),
  );

  Widget _menuBuilder() => Builder(
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
                          onTap: () {print("qwertyu;");},
                        ),
                        GestureDetector(
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration( //                    <-- BoxDecoration
                              border: Border(bottom: BorderSide()),
                            ),
                            child: ListTile(
                              title: Row(
                                children: const [
                                  Icon(Icons.delete, size: 25),
                                  Text(" Delete profile", style: TextStyle(fontSize: 18),)
                                ],
                              ),
                            ),),
                          onTap: () {print("12345;");},
                        ),
                        GestureDetector(
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

                            Navigator.popUntil(context, (route) {
                              print(route.settings.name);
                              if (route.settings.name == '/') {
                                print("eq");
                                return true;
                              }
                              print("neq");
                              return false;
                            });

                            // Navigator.of(context).pop();
                            // print(Navigator.of(context).restorationId);
                            // Navigator.of(context).pop();
                            // print(Navigator.of(context).restorationId);

                            // Navigator.of(context).popUntil(ModalRoute.withName("/login"));
                            // Navigator.of(context).pushReplacementNamed('/login');
                            // Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                          },
                        ),
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

  Widget _userGalleryBuilder() => Positioned(
    // top: 10,
    child: Container(
      margin: EdgeInsets.only(top: 130),
      child: PhotoGrid(null),
    ),
  );
}
