import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 3,
      children:
        _getPhotosStub()
    );
  }

  List<Widget> _getPhotosStub() {
    List<Widget> list = <Widget>[];
    for (int i=0; i < 20; i++) {
      list.add(
          GestureDetector(
            onTap: () {
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
