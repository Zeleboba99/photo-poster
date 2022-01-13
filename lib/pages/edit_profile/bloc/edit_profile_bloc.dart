import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/models/user.dart';
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
      _usersRepository.editUser(userUid: state.userModel.uid, nickname: state.nickname, avatar: state.avatarImage);
      yield EditProfileShowPageState(userModel: state.userModel, nickname: state.nickname, avatarImage: state.avatarImage);

    }
    print("end mapEventToState EditProfileBloc");
  }
}