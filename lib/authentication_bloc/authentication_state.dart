import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mobile_apps/models/user.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState {
  final UserModel userModel;

  Authenticated(this.userModel) : super([userModel]);

  @override
  String toString() => 'Authenticated { displayName: $userModel }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}