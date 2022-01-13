import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  RegisterEvent([List props = const []]) : super(props);
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  RegisterEmailChanged({required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  RegisterPasswordChanged({required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class RegisterNicknameChanged extends RegisterEvent {
  final String nickname;

  RegisterNicknameChanged({required this.nickname}) : super([nickname]);

  @override
  String toString() => 'NicknameChanged { nickname: $nickname }';
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String nickname;

  RegisterSubmitted({required this.email, required this.password, required this.nickname})
      : super([email, password, nickname]);

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password, nickname: $nickname }';
  }
}