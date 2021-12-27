import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_apps/new_post_bloc/new_post_bloc.dart';
import 'package:mobile_apps/new_post_bloc/new_post_event.dart';
import 'package:mobile_apps/services/database.dart';

class PhotoGrid extends StatelessWidget {
  NewPostBloc? newPostBloc;
  PhotoGrid(this.newPostBloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 3,
      children:
        _getPhotosStub(context)
    );
  }

  List<Widget> _getPhotosStub(BuildContext context) {
    List<Widget> list = <Widget>[];
    for (int i=0; i < 20; i++) {
      list.add(
          GestureDetector(
            onTap: () {
              if (ModalRoute.of(context)!.settings.name == '/new-post-choose-photo') {
                Database.getDummyImage().then((value) {
                  newPostBloc!.add(ImageChanged(value));
                });
                Navigator.of(context).pushNamed('/new-post-add-description');
              }
              print("On picture click");
            },
            child: Container(
              child: const Image(
                image: AssetImage('assets/montain.jpg'),
                fit: BoxFit.cover,
              ),
              color: Colors.teal[100],
            ),
          )
      );
    }
    return list;
  }
}
