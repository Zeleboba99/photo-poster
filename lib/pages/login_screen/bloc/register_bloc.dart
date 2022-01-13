import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile_apps/pages/login_screen/bloc/register_event.dart';
import 'package:mobile_apps/pages/login_screen/bloc/register_state.dart';
import 'package:mobile_apps/services/user_repository.dart';
import 'package:mobile_apps/services/validators.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UsersRepository _usersRepository;

  RegisterBloc({required UsersRepository usersRepository})
      : assert(usersRepository != null),
        _usersRepository = usersRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  // @override
  // Stream<RegisterState> transform(
  //     Stream<RegisterEvent> events,
  //     Stream<RegisterState> Function(RegisterEvent event) next,
  //     ) {
  //   final observableStream = events as Observable<RegisterEvent>;
  //   final nonDebounceStream = observableStream.where((event) {
  //     return (event is! EmailChanged && event is! PasswordChanged);
  //   });
  //   final debounceStream = observableStream.where((event) {
  //     return (event is EmailChanged || event is PasswordChanged);
  //   }).debounce(Duration(milliseconds: 300));
  //   return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  // }

  @override
  Stream<RegisterState> mapEventToState(
      RegisterEvent event,
      ) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);}
    else if (event is RegisterNicknameChanged) {
      yield* _mapNicknameChangedToState(event.nickname);
    } else if (event is RegisterSubmitted) {
      yield* _mapFormSubmittedToState(event.email, event.password, event.nickname);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
      isPasswordValid: state.isPasswordValid,
      isNicknameValid: state.isNicknameValid,
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isEmailValid: state.isEmailValid,
      isPasswordValid: Validators.isValidPassword(password),
      isNicknameValid: state.isNicknameValid,
    );
  }

  Stream<RegisterState> _mapNicknameChangedToState(String nickname) async* {
    yield state.update(
      isEmailValid: state.isEmailValid,
      isPasswordValid: state.isPasswordValid,
      isNicknameValid: Validators.isValidPassword(nickname),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
      String email,
      String password,
      String nickname
      ) async* {
    yield RegisterState.loading();
    try {
      _usersRepository.signUp(email, password, nickname);
      await _usersRepository.signInWithCredentials(email, password).then((value) => print("signed in"));
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}