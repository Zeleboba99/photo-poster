import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Photo poster'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text('Main scr'),
          ElevatedButton(onPressed: () {
            // Navigator.pushNamed(context, '/todo');
            // Navigator.pushNamedAndRemoveUntil(context, '/todo', (route) => false);
            Navigator.pushReplacementNamed(context, '/todo');
          }, child: Text('Go to the next page')),
          ElevatedButton(onPressed: () {
            // Navigator.pushNamed(context, '/todo');
            // Navigator.pushNamedAndRemoveUntil(context, '/todo', (route) => false);
            Navigator.pushNamed(context, '/feed');
          }, child: Text('Feed')),
          ElevatedButton(onPressed: () {
            Navigator.pushNamed(context, '/login');
          }, child: Text('Login')),
          ElevatedButton(onPressed: () {
            Navigator.pushNamed(context, '/profile');
          }, child: Text('Profile')),
          ElevatedButton(onPressed: () {
            Navigator.pushNamed(context, '/new-post-choose-photo');
          }, child: Text('new-post-choose-photo')),
          ElevatedButton(onPressed: () {
            Navigator.pushNamed(context, '/new-post-add-description');
          }, child: Text('new-post-add-description')),
          ElevatedButton(onPressed: () {
            Navigator.pushNamed(context, '/new-post-publish');
          }, child: Text('new-post-publish')),
          ElevatedButton(onPressed: () {
            Navigator.pushNamed(context, '/post');
          }, child: Text('post')),
          ElevatedButton(onPressed: () {
            Navigator.pushNamed(context, '/comments');
          }, child: Text('comments'))
        ],
      ),
    );
  }
}
