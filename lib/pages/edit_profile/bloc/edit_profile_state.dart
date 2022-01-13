import 'package:flutter/services.dart';
import 'package:mobile_apps/models/user.dart';

abstract class EditProfileState {
  ByteData? avatarImage;
  String? nickname;
  UserModel userModel;

  EditProfileState({required this.userModel, this.avatarImage, this.nickname});
}

class EditProfileLoadingState extends EditProfileState {
  EditProfileLoadingState(UserModel userModel)
      : super(userModel: userModel, avatarImage: null);
}

class EditProfileShowPageState extends EditProfileState {
  bool? setFromModel = false;
  EditProfileShowPageState(
      {ByteData? avatarImage, required UserModel userModel, String? nickname, this.setFromModel})
      : super(
            userModel: userModel, avatarImage: avatarImage, nickname: nickname);
}

class EditProfileErrorState extends EditProfileState {
  EditProfileErrorState(UserModel userModel) : super(userModel: userModel);
}
