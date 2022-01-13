import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/main.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/new_post_bloc/new_post_event.dart';
import 'package:mobile_apps/new_post_bloc/new_post_state.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_bloc.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_event.dart';
import 'package:mobile_apps/services/database.dart';
import 'package:mobile_apps/services/post_repository.dart';
import 'package:mobile_apps/services/user_repository.dart';

class NewPostBloc extends Bloc<NewPostEvent, NewPostState> {
  Database _database = Database();
  UsersRepository _usersRepository = UsersRepository();
  PostRepository _postRepository = PostRepository();

  @override
  NewPostState get initialState => NewPostState.empty();

  @override
  Stream<NewPostState> mapEventToState(NewPostEvent event) async* {
    if (event is ImageChanged) {
      yield* _mapImageChangedToState(event.image);
    } else if (event is DescriptionChanged) {
      yield* _mapDescriptionChangedToState(event.description);
    } else if (event is PublishPostPressed) {
      yield* _mapPublishPressedToState();
    }
  }

  Stream<NewPostState> _mapImageChangedToState(ByteData? image) async* {
    print("_mapImageChangedToState start");
    yield state.update(
        image: image,
        description: state.description);
    Navigator.pushNamed(navigatorKey.currentContext!, '/new-post-add-description');
    print("_mapImageChangedToState end");
  }

  Stream<NewPostState> _mapPublishPressedToState() async* {
    print("_mapPublishPressedToState start");
    ByteData? img = state.image;
    String? description = state.description;
    yield NewPostState.loading(img!);
    try {
      await _usersRepository.getUser().then((value) async {
        print("post photo");
        PostModel postModel = PostModel(
            uid: "",
            authorUid: value.uid,
            createdAt: Timestamp.now(),
            image: img,
            imageUrl: "",
            description: description,
            userModel: value,
            hasComments: false
        );
        await _postRepository.publishPost(postModel);
      });
      yield NewPostState.success(img);
      var profileBloc = BlocProvider.of<ProfileBloc>(navigatorKey.currentContext!);
      profileBloc.add(ProfileInitialEvent(userUid: (await _usersRepository.getUser()).uid));
    } catch (_) {
      yield NewPostState.failure(img);
    }
    print("_mapPublishPressedToState end");
  }

  Stream<NewPostState> _mapDescriptionChangedToState(
      String description) async* {
    yield state.update(
      image: state.image,
      description: description,
    );
  }
}
