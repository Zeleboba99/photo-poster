import 'dart:typed_data';

import 'package:mobile_apps/models/user.dart';
import 'package:mobile_apps/services/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersRepository {
  final UserProvider _usersProvider = UserProvider();

  Future<List<UserModel>> getAllUsers() => _usersProvider.getUsers();

  Future<void> signInWithCredentials(String email, String password) async => _usersProvider.signInWithCredentials(email, password);

  Future<UserModel?> signUp(String email, String password, String nickname) async => _usersProvider.signUp(email, password, nickname);

  Future<List<dynamic>> signOut() async => _usersProvider.signOut();

  Future<bool> isSignedIn() async => _usersProvider.isSignedIn();

  Future<String> getUserEmail() async => _usersProvider.getUserEmail();

  Future<User> getFirebaseUser() async => _usersProvider.getFirebaseUser();

  Future<UserModel> getUser({String? userUid}) async => _usersProvider.getUser(userUid: userUid);

  Future<void> deleteProfile() => _usersProvider.deleteProfile();

  Future<void> editUser({required String userUid, ByteData? avatar, String? nickname}) async => _usersProvider.editUser(userUid: userUid, avatar: avatar, nickname: nickname);
}