import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/components/photo_grid.dart';
import 'package:mobile_apps/new_post_bloc/new_post_bloc.dart';
import 'package:mobile_apps/new_post_bloc/new_post_event.dart';
import 'package:mobile_apps/new_post_bloc/new_post_state.dart';

class NewPostPublishScreen extends StatefulWidget {
  const NewPostPublishScreen({Key? key}) : super(key: key);

  @override
  State<NewPostPublishScreen> createState() => _NewPostPublishScreenState();
}

class _NewPostPublishScreenState extends State<NewPostPublishScreen> {
  late NewPostBloc _newPostBloc;

  @override
  void initState() {
    super.initState();
    _newPostBloc = BlocProvider.of<NewPostBloc>(context);
    _newPostBloc.add(PublishPostPressed(image: _newPostBloc.state.image!,
        description: _newPostBloc.state.description));
  }

  @override
  Widget build(BuildContext context) {
    // _newPostBloc.add(PublishPostPressed(image: _newPostBloc.state.image!,
    //     description: _newPostBloc.state.description));
    print("build new_post_publish");
    return BlocListener(
      bloc: _newPostBloc,
      listener: (BuildContext context, NewPostState state){},
      child: BlocBuilder(
        bloc: _newPostBloc,
        builder: (BuildContext context, NewPostState state) {
          print("state" + state.toString());
          return Scaffold(
            body: Container(
              margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("New post",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w300
                              )))),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        "The photo is really cool! \n Wait a little, now we are publishing",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),)
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Image(
                        // width: 150,
                        // height: 150,
                        image: Image.memory(state.image!.buffer.asUint8List()).image,
                        // image: AssetImage('assets/montain.jpg'),
                        fit: BoxFit.cover,
                      ),  // Widget that is blurred
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: NavigationBar(),
          );
        },
      ),
    );
  }

  Widget _orSeparatorBuilder() => Stack(
    children: const [
      Positioned(top:0,right: 200,child: Text("or", style: TextStyle(backgroundColor: Color.fromRGBO(0, 99, 0, 0)),)),
      Positioned(child: Divider(color: Colors.black54, thickness: 1,)),
      // Divider(color: Colors.black54, thickness: 1,),
    ],
  );

  Widget _choosePhotoBuilder() => Container(
    child: Column(
      children: [
        Align(
            alignment: Alignment.center,
            child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: const Text("New post",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 40,
                        fontWeight: FontWeight.w300
                    )))),
        Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text("LET'S ADD A PHOTO!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
              width: double.infinity, // <-- match_parent
              child: ElevatedButton(onPressed: () {}, child: Text("FROM CAMERA"), style: ElevatedButton.styleFrom(
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

  Widget _chooseFromGalleryBuilder() => Container(
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
              width: double.infinity, // <-- match_parent
              child: ElevatedButton(onPressed: () {}, child: Text("FROM GALLERY"), style: ElevatedButton.styleFrom(
                  primary: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(
                    // fontSize: 3,
                      fontWeight: FontWeight.bold)),)
          ),
        ),
        Container()
      ],
    ),
  );
}
