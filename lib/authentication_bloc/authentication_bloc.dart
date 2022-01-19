import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile_apps/models/user.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_block.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_event.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_bloc.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_event.dart';
import 'package:mobile_apps/services/user_repository.dart';

import '../main.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UsersRepository _userRepository;

  AuthenticationBloc({required UsersRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event,) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    print("_mapAppStartedToState start");
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      print("isSignedIn " + isSignedIn.toString());
      if (isSignedIn) {
        UserModel userModel = await _userRepository.getUser();
        var profileBloc = BlocProvider.of<ProfileBloc>(navigatorKey.currentContext!);
        profileBloc.add(ProfileInitialEvent(userUid: userModel.uid));

        yield Authenticated(userModel);
        print("Authenticated");
      } else {
        yield Unauthenticated();
        print("Unauthenticated");
      }
    } catch (_) {
      yield Unauthenticated();
      print("Unauthenticated");
    }
    print("_mapAppStartedToState end");
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    UserModel userModel = await _userRepository.getUser();
    var profileBloc = BlocProvider.of<ProfileBloc>(navigatorKey.currentContext!);
    profileBloc.add(ProfileInitialEvent(userUid: userModel.uid));
    BlocProvider.of<FeedBloc>(navigatorKey.currentContext!).add(FeedLoadEvent(reloadAll: true));

    yield Authenticated(userModel);
    Navigator.of(navigatorKey.currentContext!).pushReplacementNamed('/feed');

  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    print("_mapLoggedOutToState");
    _userRepository.signOut();
    _userRepository.getFirebaseUser().then((value) => print(value.email));
  }
}