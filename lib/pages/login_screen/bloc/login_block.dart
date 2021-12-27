import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile_apps/services/user_repository.dart';
import 'package:mobile_apps/services/validators.dart';
import 'package:rxdart/rxdart.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UsersRepository _usersRepository;

  LoginBloc({
    required UsersRepository usersRepository,
  })  : assert(usersRepository != null),
        _usersRepository = usersRepository;

  @override
  LoginState get initialState => LoginState.empty();

  // @override
  // Stream<LoginState> transform(
  //     Stream<LoginEvent> events,
  //     Stream<LoginState> Function(LoginEvent event) next,
  //     ) {
  //   final observableStream = events as Observable<LoginEvent>;
  //   final nonDebounceStream = observableStream.where((event) {
  //     return (event is! EmailChanged && event is! PasswordChanged);
  //   });
  //   final debounceStream = observableStream.where((event) {
  //     return (event is EmailChanged || event is PasswordChanged);
  //   }).debounce(Duration(milliseconds: 300));
  //   return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  // }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
      isPasswordValid: state.isPasswordValid,
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isEmailValid: state.isEmailValid,
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    required String email,
    required String password,
  }) async* {
    print("_mapLoginWithCredentialsPressedToState start");
    yield LoginState.loading();
    try {
      await _usersRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
    print("_mapLoginWithCredentialsPressedToState end");
  }
}