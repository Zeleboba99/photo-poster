import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/models/user.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_block.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_event.dart';
import 'package:mobile_apps/pages/feed_screen/bloc/feed_screen_state.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_bloc.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_event.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_state.dart';
import 'package:mobile_apps/services/post_repository.dart';
import 'package:mobile_apps/services/user_repository.dart';

import '../../../main.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  UsersRepository _usersRepository = UsersRepository();

  @override
  EditProfileState get initialState => EditProfileLoadingState(UserModel(email: "", nickname: "", uid: ""));

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    print("start mapEventToState EditProfileBloc" + event.toString());

    if (event is EditProfileInitialEvent) {
      yield EditProfileShowPageState(userModel: event.userModel, nickname: event.userModel.nickname, avatarImage: event.userModel.avatar, setFromModel: true);
      Navigator.pushNamed(navigatorKey.currentContext!, '/edit-profile');
    } else if (event is EditProfileChangeAvatarEvent) {
      yield EditProfileShowPageState(userModel: state.userModel, avatarImage: event.avatarImage, nickname: state.nickname);
    } else if (event is EditProfileChangeNicknameEvent) {
      yield EditProfileShowPageState(userModel: state.userModel, nickname: event.nickname, avatarImage: state.avatarImage);
    } else if (event is EditProfileSaveChangesEvent) {
      yield EditProfileShowPageState(userModel: state.userModel, nickname: state.nickname, avatarImage: state.avatarImage);
      await _usersRepository.editUser(userUid: state.userModel.uid, nickname: state.nickname, avatar: state.avatarImage);
      var profileState = BlocProvider
          .of<ProfileBloc>(navigatorKey.currentContext!)
          .state as ProfileShowPostsState;
      profileState.loadedUser.nickname = state.nickname!;
      profileState.loadedUser.avatar = state.avatarImage;
      profileState.loadedPosts.forEach((element) {
        element.userModel = profileState.loadedUser;
        if (element.comments != null) {
          element.comments!.forEach((comment) {
            if (comment.userModel.uid == profileState.loadedUser.uid) {
              comment.userModel = profileState.loadedUser;
            }
          });
        }
      });
      BlocProvider.of<ProfileBloc>(navigatorKey.currentContext!).add(
          ProfileAdjustPostsEvent(adjustedPosts: profileState.loadedPosts,
              userModel: profileState.loadedUser));
      var adjustedUser = profileState.loadedUser;

      var feedState = BlocProvider.of<FeedBloc>(navigatorKey.currentContext!).state as FeedShowPostsState;
      feedState.loadedPosts.forEach((element) {
        if (element.userModel.uid == adjustedUser.uid) {
          element.userModel = adjustedUser;
          if (element.comments != null) {
            element.comments!.forEach((comment) {
              if (comment.userModel.uid == adjustedUser.uid) {
                comment.userModel = adjustedUser;
              }
            });
          }
        }
      });
      BlocProvider.of<FeedBloc>(navigatorKey.currentContext!).add(
          FeedAdjustPostsEvent(adjustedPosts: feedState.loadedPosts));
    }
    print("end mapEventToState EditProfileBloc");
  }
}