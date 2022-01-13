import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                          child: Image(
                            height: 350,
                            width: MediaQuery.of(context).size.width,
                            image: Image.memory(state.image!.buffer.asUint8List(),fit:BoxFit.contain).image,
                            fit: BoxFit.contain,//BoxFit.cover,
                          ),  // Widget that is blurred
                        ),
                      ],
                    )
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
}
