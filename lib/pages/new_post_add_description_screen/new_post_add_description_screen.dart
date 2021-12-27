import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/components/photo_grid.dart';
import 'package:mobile_apps/new_post_bloc/new_post_bloc.dart';
import 'package:mobile_apps/new_post_bloc/new_post_event.dart';
import 'package:mobile_apps/new_post_bloc/new_post_state.dart';

class NewPostAddDescriptionScreen extends StatefulWidget {
  const NewPostAddDescriptionScreen({Key? key}) : super(key: key);

  @override
  State<NewPostAddDescriptionScreen> createState() => _NewPostAddDescriptionScreenState();
}

class _NewPostAddDescriptionScreenState extends State<NewPostAddDescriptionScreen> {
  late NewPostBloc _newPostBloc;

  @override
  void initState() {
    super.initState();
    _newPostBloc = BlocProvider.of<NewPostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _newPostBloc,
      listener: (BuildContext context, NewPostState state) {

      },
      child: BlocBuilder(
        bloc: _newPostBloc,
        builder: (BuildContext context, NewPostState state) {
          return Scaffold(
            body: Container(
              margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.keyboard_backspace, size: 40,),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      const Spacer(flex: 2,),
                      Container(
                        // alignment: Alignment.topCenter,
                        child: Align(
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
                      ),
                      const Spacer(flex: 3,),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Row(
                      children: [
                        Image(
                          width: 150,
                          height: 150,
                          image: Image.memory(state.image!.buffer.asUint8List()).image,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: ElevatedButton(
                            onPressed: () {
                               // _newPostBloc.add(PublishPostPressed(image: _newPostBloc.state.image!,
                               //     description: _newPostBloc.state.description));
                              Navigator.pushNamed(context, '/new-post-publish');
                            },
                            child: Text("PUBLISH"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                textStyle: const TextStyle(
                                  // fontSize: 3,
                                    fontWeight: FontWeight.bold)),),
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: const TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "This post is about...",
                          ))),
                ],
              ),
            ),
            bottomNavigationBar: NavigationBar(),
          );
        },
      )
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
