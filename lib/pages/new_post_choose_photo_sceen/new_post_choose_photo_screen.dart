import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/components/photo_grid.dart';
import 'package:mobile_apps/new_post_bloc/new_post_bloc.dart';
import 'package:mobile_apps/new_post_bloc/new_post_state.dart';

class NewPostChoosePhotoScreen extends StatefulWidget {
  const NewPostChoosePhotoScreen({Key? key}) : super(key: key);

  @override
  State<NewPostChoosePhotoScreen> createState() => _NewPostChoosePhotoScreenState();
}

class _NewPostChoosePhotoScreenState extends State<NewPostChoosePhotoScreen> {
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
          if (state.isSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil('/feed', (route) => false);
          }
        },
        child: BlocBuilder(
          bloc: _newPostBloc,
          builder: (BuildContext context, NewPostState state) {
            return Scaffold(
              body: Column(
                children: [
                  Container(
                    // height: 300,
                    // width: 410,
                      child: Expanded(
                        child: ListView(
                            children: [
                              _choosePhotoBuilder(context),
                              // _orSeparatorBuilder(),
                              _chooseFromGalleryBuilder(),
                            ]
                        ),
                      )
                  ),
                  // todo
                  Container(
                    // top: 300,// todo
                    //   height: 350,
                    //   width: 410,
                      child: Container(child: SizedBox(height: 350,child:PhotoGrid(_newPostBloc)))
                  )
                ],
              ),
              bottomNavigationBar: const NavigationBar(),
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

  Widget _choosePhotoBuilder(BuildContext context) => Container(
    child: Column(
      children: [
        Row(
          children: [
            const Spacer(flex: 3,),
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
            const Spacer(flex: 2,),
            IconButton(
                icon: const Icon(Icons.keyboard_arrow_right, size: 40,),
                onPressed: () {
                  Navigator.pushNamed(context, '/new-post-add-description');
                }
            ),
          ],
        ),
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
