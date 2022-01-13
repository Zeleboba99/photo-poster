import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/new_post_bloc/new_post_bloc.dart';
import 'package:mobile_apps/new_post_bloc/new_post_event.dart';
import 'package:mobile_apps/new_post_bloc/new_post_state.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_block.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_event.dart';
import 'package:mobile_apps/services/image_picker_provider.dart';

class NewPostChoosePhotoScreen extends StatefulWidget {
  const NewPostChoosePhotoScreen({Key? key}) : super(key: key);

  @override
  State<NewPostChoosePhotoScreen> createState() =>
      _NewPostChoosePhotoScreenState();
}

class _NewPostChoosePhotoScreenState extends State<NewPostChoosePhotoScreen> {
  late NewPostBloc _newPostBloc;
  late FeedBloc _feedBloc;

  @override
  void initState() {
    super.initState();
    _newPostBloc = BlocProvider.of<NewPostBloc>(context);
    _feedBloc = BlocProvider.of<FeedBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _newPostBloc,
      listener: (BuildContext context, NewPostState state) {
        if (state.isSuccess) {
          print("add reload feed event");
          _feedBloc.add(FeedLoadEvent(reloadAll: true));
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/feed', (route) => false);
        }
      },
      child: BlocBuilder(
        bloc: _newPostBloc,
        builder: (BuildContext context, NewPostState state) {
          return Scaffold(
            body: Column(
              children: [
                Container(
                    child: Expanded(
                      child: ListView(children: [
                        _choosePhotoBuilder(context, state),
                        _chooseFromGalleryBuilder(),
                      ]),
                    )),
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
      Positioned(
          top: 0,
          right: 200,
          child: Text(
            "or",
            style: TextStyle(backgroundColor: Color.fromRGBO(0, 99, 0, 0)),
          )),
      Positioned(
          child: Divider(
            color: Colors.black54,
            thickness: 1,
          )),
    ],
  );

  Widget _choosePhotoBuilder(BuildContext context, NewPostState state) => Container(
    child: Column(
      children: [
        Row(
          children: [
            const Spacer(
              flex: 3,
            ),
            Container(
              child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: const Text("New post",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 40,
                              fontWeight: FontWeight.w300)))),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
        Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              "LET'S ADD A PHOTO!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
              width: double.infinity, // <-- match_parent
              child: ElevatedButton(
                onPressed: () async {
                  PickedFile pickedImage = await ImagePickerProvider.getImageFromCamera(context);
                  validateAndNewImage(pickedImage);
                },
                child: Text("FROM CAMERA"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold)),
              )),
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
              child: ElevatedButton(
                onPressed: () async {
                  PickedFile pickedImage = await ImagePickerProvider.getImageFromGallery(context);
                  validateAndNewImage(pickedImage);
                },
                child: Text("FROM GALLERY"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold)),
              )),
        ),
        Container()
      ],
    ),
  );

  validateAndNewImage(PickedFile pickedImage) async {
    ByteData byteData = ByteData.sublistView(await pickedImage.readAsBytes());
    _newPostBloc.add(ImageChanged(byteData));

  }
}
