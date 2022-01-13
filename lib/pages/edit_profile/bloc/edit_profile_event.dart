import 'package:flutter/services.dart';
import 'package:mobile_apps/models/user.dart';

abstract class EditProfileEvent{
}

class EditProfileInitialEvent extends EditProfileEvent {
  UserModel userModel;
  EditProfileInitialEvent({required this.userModel});
}

class EditProfileChangeAvatarEvent extends EditProfileEvent {
  ByteData avatarImage;
  EditProfileChangeAvatarEvent({required this.avatarImage});
}

class EditProfileChangeNicknameEvent extends EditProfileEvent {
  String nickname;
  EditProfileChangeNicknameEvent({required this.nickname});
}

class EditProfileSaveChangesEvent extends EditProfileEvent {
  EditProfileSaveChangesEvent();
}