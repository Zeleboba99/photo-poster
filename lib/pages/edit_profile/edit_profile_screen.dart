import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_apps/authentication_bloc/authentication_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_event.dart';
import 'package:mobile_apps/components/navigation_bar.dart';
import 'package:mobile_apps/pages/edit_profile/bloc/edit_profile_event.dart';
import 'package:mobile_apps/pages/post_screen/bloc/post_screen_bloc.dart';
import 'package:mobile_apps/pages/profile_screen/bloc/profile_bloc.dart';
import 'package:mobile_apps/services/database.dart';
import 'package:mobile_apps/services/image_picker_provider.dart';

import 'bloc/edit_profile_bloc.dart';
import 'bloc/edit_profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late AuthenticationBloc _authenticationBloc;
  late ProfileBloc _profileBloc;
  late PostScreenBloc _postScreenBloc;
  late EditProfileBloc _editProfileBloc;

  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _postScreenBloc = BlocProvider.of<PostScreenBloc>(context);
    _editProfileBloc = BlocProvider.of<EditProfileBloc>(context);

    _nicknameController.addListener(_onNicknameChanged);
  }

  @override
  void didChangeDependencies() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _profileBloc = BlocProvider.of<ProfileBloc>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EditProfileBloc, EditProfileState>(builder: (context, state) {
        if (state is EditProfileLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is EditProfileShowPageState) {
          bool? setFromModel = (state as EditProfileShowPageState).setFromModel;
          if (setFromModel != null && setFromModel == true) {
            _nicknameController.text = state.userModel.nickname;
          }
          return Container(
            child: _profileHeaderBuilder(context, state),
          );
        } else {
          return Text("Something goes wrong during loading profile");
        }
      }),
      bottomNavigationBar: const NavigationBar(),
    );
  }

  Widget _profileHeaderBuilder(BuildContext context, EditProfileState state) =>
      Container(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        // top: 30,
        child: Container(
          // width: 400,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: Column(
                        children: [
                          Text("Edit Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 25,
                      ),
                      child: TextFormField(
                        // initialValue: state.nickname,
                          controller: _nicknameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Nickname",
                          )),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: state.avatarImage != null
                          ? CircleAvatar(backgroundImage: Image.memory(state.avatarImage!.buffer.asUint8List()).image, radius: 18,)
                          : const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.black87,
                        size: 50,
                      ),
                    ),
                    Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            PickedFile pickedImage = await ImagePickerProvider.getImageFromGallery(context);
                            validateAndNewImage(pickedImage);
                            // _onChoosePhoto();
                          },
                          child: Text('CHOOSE ANOTHER PHOTO'),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // <-- Radius
                            ),
                          ),
                        ))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: state.avatarImage != null
                            ? CircleAvatar(backgroundImage: Image.memory(state.avatarImage!.buffer.asUint8List()).image, radius: 100.0,)
                            : const Icon(
                          Icons.account_circle_outlined,
                          color: Colors.black87,
                          size: 150,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _onSaveChanges();
                        },
                        child: Text('SAVE CHANGES'),
                        style: OutlinedButton.styleFrom(
                          primary: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )),
      );

  void _onNicknameChanged() {
    _editProfileBloc.add(EditProfileChangeNicknameEvent(nickname: _nicknameController.text));
  }

  validateAndNewImage(PickedFile pickedImage) async {
    ByteData byteData = ByteData.sublistView(await pickedImage.readAsBytes());
    _editProfileBloc.add(EditProfileChangeAvatarEvent(avatarImage: byteData));

  }

  void _onChoosePhoto() async {
    _editProfileBloc.add(EditProfileChangeAvatarEvent(avatarImage: await Database.getDummyImage()));
  }

  void _onSaveChanges() {
    _editProfileBloc.add(EditProfileSaveChangesEvent());
  }
}
