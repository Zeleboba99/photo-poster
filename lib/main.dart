import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_bloc.dart';
import 'package:mobile_apps/bloc/user_bloc.dart';
import 'package:mobile_apps/pages/comments_screen/bloc/comments_screen_bloc.dart';
import 'package:mobile_apps/pages/comments_screen/comments_screen.dart';
import 'package:mobile_apps/pages/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:mobile_apps/pages/edit_profile/edit_profile_screen.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_block.dart';
import 'package:mobile_apps/pages/feed_screen/feed_screen.dart';
import 'package:mobile_apps/pages/home.dart';
import 'package:mobile_apps/pages/login_screen/bloc/login_block.dart';
import 'package:mobile_apps/pages/login_screen/bloc/register_bloc.dart';
import 'package:mobile_apps/pages/login_screen/login_screen.dart';
import 'package:mobile_apps/pages/new_post_add_description_screen/new_post_add_description_screen.dart';
import 'package:mobile_apps/pages/new_post_choose_photo_sceen/new_post_choose_photo_screen.dart';
import 'package:mobile_apps/pages/new_post_publish_screen/new_post_publish_screen.dart';
import 'package:mobile_apps/pages/onboarding_screen/onboarding_screen.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_bloc.dart';
import 'package:mobile_apps/pages/post_screen/post_screen.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_bloc.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_event.dart';
import 'package:mobile_apps/pages/profile_screen/profile_screen.dart';
import 'package:mobile_apps/pages/splash_screen/splash_screen.dart';
import 'package:mobile_apps/services/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'authentication_bloc/bloc.dart';
import 'new_post_bloc/new_post_bloc.dart';

final navigatorKey = GlobalKey<NavigatorState>();
int? initScreen;
Uri? url;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late UsersRepository _userRepository;
  late AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    initDynamicLinks_2();
    _userRepository = UsersRepository();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.add(AppStarted());
  }

  @override
  void didChangeDependencies() {
    debugPrint('didChangeDependencies called');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild main");
    Timer(Duration(seconds: 3), () {
      print("Yeah, this line is printed after 3 seconds");
    });
    return MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (BuildContext context) => UserBloc(usersRepository: _userRepository),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) => _authenticationBloc,
          ),
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(usersRepository: _userRepository),
          ),
          BlocProvider<RegisterBloc>(
            create: (BuildContext context) => RegisterBloc(usersRepository: _userRepository),
          ),
          BlocProvider<NewPostBloc>(
            create: (BuildContext context) => NewPostBloc(),
          ),
          BlocProvider<FeedBloc>(
            create: (BuildContext context) => FeedBloc(),
          ),
          BlocProvider<PostScreenBloc>(
            create: (BuildContext context) => PostScreenBloc(),
          ),
          BlocProvider<ProfileBloc>(
            create: (BuildContext context) => ProfileBloc(),
          ),
          BlocProvider<CommentsBloc>(
            create: (BuildContext context) => CommentsBloc(),
          ),
          BlocProvider<EditProfileBloc>(
            create: (BuildContext context) => EditProfileBloc(),
          ),
        ],
        child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.blue,
                backgroundColor: Colors.amber
            ),
            routes: {
              // '/': (context) => MainScreen(),
              // '/todo': (context) => Home(),
              '/feed': (context) => FeedScreen(),
              '/login': (context) => LoginScreen(),
              '/profile': (context) => ProfileScreen(),
              '/new-post-choose-photo': (context) => NewPostChoosePhotoScreen(),
              '/new-post-add-description': (context) => NewPostAddDescriptionScreen(),
              '/new-post-publish': (context) => NewPostPublishScreen(),
              '/post': (context) => PostScreen(),
              '/comments': (context) => CommentsScreen(),
              '/splash': (context) => SplashScreen(),
              '/edit-profile': (context) => EditProfileScreen(),
              '/onboarding': (context) => OnboardingScreen(),
            },
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                bloc: _authenticationBloc,
                builder: (context, state) {
                  if (state is Uninitialized) {
                    print("main pg Uninitialized");
                    return SplashScreen();
                  }
                  if (state is Unauthenticated) {
                    print("main pg Unauthenticated");
                    return initScreen == 0 || initScreen == null
                        ? OnboardingScreen()
                        : LoginScreen();
                  }
                  if (state is Authenticated) {
                    print("main pg Authenticated");
                    return FeedScreen();
                  } else {
                    print("main pg default");
                    return Container(child: Text("qwerty"));
                  }
                })
        ));
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }

  initDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    Uri? deeplink = data != null ? data.link : null;

    if(deeplink != null) {
      print(deeplink.path);
      if(deeplink.path == 'profile') {
        Navigator.pushNamed(context, deeplink.path);
      }
    }

  }

  initDynamicLinks_2() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          Uri? deepLink = dynamicLink.link;
          print("deeplink found " + deepLink.toString());
          print(deepLink.path);
          print(deepLink.path.contains('profile').toString());
          if (deepLink != null) {
            if (deepLink.path.contains('/profile')) {
              print(deepLink.path);
              var ind = deepLink.path.lastIndexOf('/') + 1;
              print(ind);
              String userUid = deepLink.path.substring(ind);
              print(userUid);
              var profileBloc = BlocProvider.of<ProfileBloc>(navigatorKey.currentContext!);
              profileBloc.add(ProfileInitialEvent(userUid: userUid));

              Navigator.of(navigatorKey.currentContext!).pushNamed('/profile', arguments: userUid);
            }
          }
        }, onError: (OnLinkErrorException e) async {
      print("deeplink error");
      print(e.message);
    });
  }
}