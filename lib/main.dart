import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_bloc.dart';
import 'package:mobile_apps/bloc/user_bloc.dart';
import 'package:mobile_apps/new_post_bloc/new_post_state.dart';
import 'package:mobile_apps/pages/comments_screen/comments_screen.dart';
import 'package:mobile_apps/pages/feed_screen/feed_screen.dart';
import 'package:mobile_apps/pages/home.dart';
import 'package:mobile_apps/pages/login_screen/bloc/login_block.dart';
import 'package:mobile_apps/pages/login_screen/bloc/register_bloc.dart';
import 'package:mobile_apps/pages/login_screen/login_screen.dart';
import 'package:mobile_apps/pages/main_screen.dart';
import 'package:mobile_apps/pages/new_post_add_description_screen/new_post_add_description_screen.dart';
import 'package:mobile_apps/pages/new_post_choose_photo_sceen/new_post_choose_photo_screen.dart';
import 'package:mobile_apps/pages/new_post_publish_screen/new_post_publish_screen.dart';
import 'package:mobile_apps/pages/post_screen/post_screen.dart';
import 'package:mobile_apps/pages/profile_screen/profile_screen.dart';
import 'package:mobile_apps/pages/splash_screen/splash_screen.dart';
import 'package:mobile_apps/services/database.dart';
import 'package:mobile_apps/services/user_repository.dart';

import 'authentication_bloc/bloc.dart';
import 'new_post_bloc/new_post_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    // _initializeFirebase();
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
        ],
        child: MaterialApp(
            theme: ThemeData(
                primaryColor: Colors.blue,
                backgroundColor: Colors.amber
            ),
            // // home: MainScreen(),
            // // initialRoute: '/splash',
            routes: {
              // '/': (context) => MainScreen(),
              '/todo': (context) => Home(),
              '/feed': (context) => FeedScreen(),
              '/login': (context) => LoginScreen(),
              '/profile': (context) => ProfileScreen(),
              '/new-post-choose-photo': (context) => NewPostChoosePhotoScreen(),
              '/new-post-add-description': (context) => NewPostAddDescriptionScreen(),
              '/new-post-publish': (context) => NewPostPublishScreen(),
              '/post': (context) => PostScreen(),
              '/comments': (context) => CommentsScreen(),
              '/splash': (context) => SplashScreen(),
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
                    return LoginScreen();
                  }
                  if (state is Authenticated) {
                    print("main pg Authenticated");
                    return FeedScreen();
                  } else {
                    print("main pg default");
                    return Container(child: Text("qwerty"));
                  }
                  // return MaterialApp(
                    /*theme: ThemeData(
                      primaryColor: Colors.blue,
                      backgroundColor: Colors.amber
                  ),*/
                    // home: MainScreen(),
                    // initialRoute: '/splash',
                    /*routes: {
                    '/': (context) => MainScreen(),
                    '/todo': (context) => Home(),
                    '/feed': (context) => FeedScreen(),
                    '/login': (context) => LoginScreen(),
                    '/profile': (context) => ProfileScreen(),
                    '/new-post-choose-photo': (context) => NewPostChoosePhotoScreen(),
                    '/new-post-add-description': (context) => NewPostAddDescriptionScreen(),
                    '/new-post-publish': (context) => NewPostPublishScreen(),
                    '/post': (context) => PostScreen(),
                    '/comments': (context) => CommentsScreen(),
                    '/splash': (context) => SplashScreen(),
                  },*/
                  // );
                })
    ));
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }
}






// void main() {
//   runApp(MaterialApp(
//     home: UserPanel(),
//   ));
// }
//
// class UserPanel extends StatefulWidget {
//   const UserPanel({Key? key}) : super(key: key);
//
//   @override
//   State<UserPanel> createState() => _UserPanelState();
// }
//
// class _UserPanelState extends State<UserPanel> {
//
//   int _count = 0;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('photo poster'),
//         centerTitle: true,
//         backgroundColor: Colors.black12,
//       ),
//       body: SafeArea(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(
//               children: [
//                 Padding(padding: EdgeInsets.only(top: 20)),
//                 Text('User!', style: TextStyle(fontSize: 30),),
//                 Padding(padding: EdgeInsets.only(top: 20)),
//                 CircleAvatar(
//                   backgroundImage: AssetImage('assets/montain.jpg'),
//                   radius: 50,
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.mail_outline, size: 25),
//                     Text('admin@vsu.com')
//                   ],
//                 ),
//                 Text('Count $_count'),
//               ],
//             )
//           ],
//         )
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.ac_unit_rounded),
//         onPressed: () {
//           setState(() {
//             _count++;
//           });
//         },
//       ),
//     );
//   }
// }












/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.amberAccent),
        home: Scaffold(
          appBar: AppBar(
            title: Text('header'),
            centerTitle: true,
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(children: [
                Text('1'),
                TextButton(onPressed: () {}, child: Text('2'))
              ]),
              Column(children: [
                Text('1'),
                TextButton(onPressed: () {}, child: Text('2'))
              ])
            ],
          ),

          // Row(
          //   children: [
          //     Text('1'),
          //     TextButton(onPressed: () {}, child: Text('2' ))
          //   ],
          // ),

          // Container(
          //   color: Colors.blue,
          //   child: Text('dksa'),
          //   margin: EdgeInsets.all(20.0),
          //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //   // padding: EdgeInsets.fromLTRB(10, 5, 3 ,4),
          // ),

          // Center(
          //     child:
          // Image(
          //   image: AssetImage('assets/montain.jpg'),
          //   // image: NetworkImage('https://images.unsplash.com/photo-1548588627-f978862b85e1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bW9udGFpbnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80'),
          // )
          // ElevatedButton(onPressed: () {  }, child: Text('jh'),)
          // RaisedButton.icon(onPressed: () {}, icon: Icon(Icons.ac_unit_rounded), label: Text(''))
          // RaisedButton()
          // FlatButton(
          //   onPressed: () {},
          //   child: Text('push'),
          //   color: Colors.blue,
          // )

          // Icon(Icons.account_circle_outlined, size: 45, color: Colors.blue,)

          //   Text(
          // "new text",
          // style: TextStyle(
          //     fontSize: 20, color: Colors.blueAccent, fontFamily: 'Lato'),
          // )
          // ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print('clicked');
            },
            child: Text('Push me'),
            backgroundColor: Colors.deepPurple,
          ),
        ));
  }
}
*/


/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
