import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_event.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_block.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_event.dart';
import 'package:mobile_apps/services/user_repository.dart';

import 'bloc/login_block.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';
import 'bloc/register_bloc.dart';
import 'bloc/register_event.dart';
import 'bloc/register_state.dart';

class LoginScreen extends StatefulWidget {
  final UsersRepository _usersRepository = UsersRepository();

  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;
  late RegisterBloc _registerBloc;
  final TextEditingController _emailLoginController = TextEditingController();
  final TextEditingController _passwordLoginController = TextEditingController();
  final TextEditingController _emailRegisterController = TextEditingController();
  final TextEditingController _passwordRegisterController = TextEditingController();
  final TextEditingController _nicknameRegisterController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailLoginController.addListener(_onLoginEmailChanged);
    _passwordLoginController.addListener(_onPasswordEmailChanged);
    _emailRegisterController.addListener(_onRegisterEmailChanged);
    _passwordRegisterController.addListener(_onRegisterPasswordChanged);
    _nicknameRegisterController.addListener(_onRegisterNicknameChanged);
  }

  void _onLoginEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailLoginController.text),
    );
  }

  void _onPasswordEmailChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordLoginController.text),
    );
  }

  void _onLoginFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailLoginController.text,
        password: _passwordLoginController.text,
      ),
    );
  }

  void _onRegisterEmailChanged() {
    _registerBloc.add(
      RegisterEmailChanged(email: _emailRegisterController.text),
    );
  }

  void _onRegisterPasswordChanged() {
    _registerBloc.add(
      RegisterPasswordChanged(password: _passwordRegisterController.text),
    );
  }

  void _onRegisterNicknameChanged() {
    _registerBloc.add(
      RegisterNicknameChanged(nickname: _nicknameRegisterController.text),
    );
  }

  void _onRegisterFormSubmitted() {
    _registerBloc.add(
      RegisterSubmitted(
        email: _emailRegisterController.text,
        password: _passwordRegisterController.text,
        nickname: _nicknameRegisterController.text
      ),
    );
  }

  bool get isLoginPopulated =>
      _emailLoginController.text.isNotEmpty && _passwordLoginController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isLoginPopulated && !state.isSubmitting;
  }

  bool get isRegisterPopulated =>
      _emailRegisterController.text.isNotEmpty
          && _passwordRegisterController.text.isNotEmpty
          && _nicknameRegisterController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isRegisterPopulated && !state.isSubmitting;
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      print("Yeah, this line is printed after 3 seconds");
    });
    return Scaffold(
        body: Container(
            child: ListView(
                children: [
                  _signInBuilder(),
                  _orSeparatorBuilder(),
                  _signUpBuilder()
                ]
            )),
    );
  }

  Widget _orSeparatorBuilder() => Stack(
    children: const [
      Positioned(top:0,right: 200,child: Text("or", style: TextStyle(backgroundColor: Color.fromRGBO(0, 99, 0, 0)),)),
      Positioned(child: Divider(color: Colors.black54, thickness: 1,)),
      // Divider(color: Colors.black54, thickness: 1,),
    ],
  );

  Widget _signInBuilder() => BlocListener(
    bloc: _loginBloc,
    listener: (BuildContext context, LoginState state) {
      if (state.isFailure) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Login Failure'), Icon(Icons.error)],
              ),
              backgroundColor: Colors.red,
            ),
          );
      }
      if (state.isSubmitting) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Logging In...'),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
      }
      if (state.isSuccess) {

        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        // Navigator.of(context).pushReplacementNamed('/feed');

      }
    },

    child: BlocBuilder(
      bloc: _loginBloc,
      builder: (BuildContext context, LoginState state) {
        return Container(
          child: Column(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Container(
                      padding: const EdgeInsets.only(top: 50),
                      child: const Text("Sign in",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 40,
                              fontWeight: FontWeight.w300
                          )))),
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: TextFormField(
                      controller: _emailLoginController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter email",
                        // helperText: "Логин используется для входа в систему",
                      ),
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  )
              ),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                      controller: _passwordLoginController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter password",
                        // helperText: "Логин используется для входа в систему",
                      ),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  )
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                    width: double.infinity, // <-- match_parent
                    child: ElevatedButton(
                      onPressed: () {
                        if (isLoginButtonEnabled(state)) {
                          FocusScope.of(context).unfocus();
                          _onLoginFormSubmitted();
                        }
                      },
                      child: Text("SIGN IN"), style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(
                          // fontSize: 3,
                            fontWeight: FontWeight.bold)),)
                ),
              )
            ],
          ),
        );
      },
    ),
  );

  Widget _signUpBuilder() => BlocListener(
      bloc: _registerBloc,
      listener: (BuildContext context, RegisterState state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          BlocProvider.of<FeedBloc>(context).add(FeedLoadEvent(reloadAll: true));
          // Navigator.of(context).pushReplacementNamed('/feed');
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
    child: BlocBuilder(
      bloc: _registerBloc,
      builder: (BuildContext context, RegisterState state) {
        return Container(
          child: Column(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Container(
                      padding: const EdgeInsets.only(top: 50),
                      child: const Text("Sign up",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 40,
                              fontWeight: FontWeight.w300
                          )))),
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: TextFormField(
                    controller: _nicknameRegisterController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter nickname",
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isNicknameValid ? 'Invalid Nickname' : null;
                    },
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                    controller: _emailRegisterController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter email",
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                    controller: _passwordRegisterController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter password",
                    ),
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  )),
              Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                        width: double.infinity, // <-- match_parent
                        child: ElevatedButton(
                          onPressed: () {
                            if (isRegisterButtonEnabled(state)) {
                              FocusScope.of(context).unfocus();
                              _onRegisterFormSubmitted();
                            }
                          },
                          child: Text("SIGN UP"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold)),)
                ),
              )
            ],
          ),
        );
      },
    ),

  );


  @override
  void dispose() {
    _emailLoginController.dispose();
    _passwordLoginController.dispose();
    super.dispose();
  }
}
