import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('TODO list'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text('Main scr'),
          ElevatedButton(onPressed: () {
            // Navigator.pushNamed(context, '/todo');
            // Navigator.pushNamedAndRemoveUntil(context, '/todo', (route) => false);
            Navigator.pushReplacementNamed(context, '/todo');
          }, child: Text('Go to the next page'))
        ],
      ),
    );
  }
}
