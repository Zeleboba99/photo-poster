import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/new_post_bloc/new_post_event.dart';
import 'package:mobile_apps/new_post_bloc/new_post_state.dart';
import 'package:mobile_apps/services/database.dart';
import 'package:mobile_apps/services/user_repository.dart';

class NewPostBloc extends Bloc<NewPostEvent, NewPostState> {
  Database _database = Database();
  UsersRepository _usersRepository = UsersRepository();

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
      image: image, // todo validate
      description: state.description
    );
    print("_mapImageChangedToState end");
  }

  Stream<NewPostState> _mapPublishPressedToState() async* {
    print("_mapPublishPressedToState start");
    ByteData? img = state.image;
    String? description = state.description;
    yield NewPostState.loading(img!);
    try {
      _usersRepository.getFirebaseUser().then((value) {
        print("post photo");
        Database.addPost(description: description, date: "date", authorUid: value.uid, image: img);
      });
      yield NewPostState.success(img);
    } catch (_) {
      yield NewPostState.failure(img);
    }
    print("_mapPublishPressedToState end");
  }

  Stream<NewPostState> _mapDescriptionChangedToState(String description) async* {
    yield state.update(
      image: state.image,
      description: description,
    );
  }
}