import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: ListView(
                children: [
                  _signInBuilder(),
                  _orSeparatorBuilder(),
                  // Divider(color: Colors.black54, thickness: 1,),
                  _signUpBuilder()
                ]
            )),
          // body: _showImagesBuilder()
      // Column(
      //   children: [
      //     Text('Main scr'),
      //     ElevatedButton(onPressed: () {
      //       // Navigator.pushNamed(context, '/todo');
      //       // Navigator.pushNamedAndRemoveUntil(context, '/todo', (route) => false);
      //       Navigator.pushReplacementNamed(context, '/');
      //     }, child: Text('Home')),
      //   ],
      // ),
      //   _showImagesBuilder()

    );
  }

  Widget _orSeparatorBuilder() => Stack(
    children: const [
      Positioned(top:0,right: 200,child: Text("or", style: TextStyle(backgroundColor: Color.fromRGBO(0, 99, 0, 0)),)),
      Positioned(child: Divider(color: Colors.black54, thickness: 1,)),
      // Divider(color: Colors.black54, thickness: 1,),
    ],
  );

  Widget _signInBuilder() => Container(
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
                child: const TextField(
                    decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter email",
                  // helperText: "Логин используется для входа в систему",
                ))),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter password",
                      // helperText: "Логин используется для входа в систему",
                    ))),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                  width: double.infinity, // <-- match_parent
                  child: ElevatedButton(onPressed: () {}, child: Text("SIGN IN"), style: ElevatedButton.styleFrom(
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

  Widget _signUpBuilder() => Container(
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
            child: const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter nickname",
                  // helperText: "Логин используется для входа в систему",
                ))),
        Container(
            margin: const EdgeInsets.only(top: 15),
            child: const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter email",
                  // helperText: "Логин используется для входа в систему",
                ))),
        Container(
            margin: const EdgeInsets.only(top: 15),
            child: const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter password",
                  // helperText: "Логин используется для входа в систему",
                ))),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
              width: double.infinity, // <-- match_parent
              child: ElevatedButton(onPressed: () {}, child: Text("SIGN UP"), style: ElevatedButton.styleFrom(
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
}
