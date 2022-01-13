import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:mobile_apps/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_apps/services/converters/user_converter.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _userCollection = _firestore.collection('users');

class UserProvider {

  final FirebaseAuth _firebaseAuth;

  UserProvider({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await getUser(userUid: userCredential.user.uid);
  }

  Future<UserModel?> signUp(
      String email, String password, String nickname) async {
    try {
      print("sign up");
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userModel = UserModel(
          uid: userCredential.user.uid,
          nickname: nickname,
          email: email,
          avatarUrl: "");
      _userCollection
          .doc(userCredential.user.uid)
          .set(UserConverter.convertToMap(userModel));
      return userModel;
    } catch (e) {
      print(e);
    }
  }

  Future<List<dynamic>> signOut() async {
    // todo
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    print("check signed in");
    final currentUser = await _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<String> getUserEmail() async {
    return (await _firebaseAuth.currentUser).email;
  }

  Future<User> getFirebaseUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<UserModel> getUser({String? userUid}) async {
    if (userUid == null) {
      User user = await getFirebaseUser();
      var snapshot = await _userCollection.doc(user.uid.toString()).get();
      var data = snapshot.data();
      return await UserConverter.convertToUser(user.uid, data);
    } else {
      var snapshot = await _userCollection.doc(userUid).get();
      var data = snapshot.data();
      return await UserConverter.convertToUser(userUid, data);
    }
  }

  deleteProfile() {
    // todo
  }

  Future<void> editUser(
      {required String userUid, ByteData? avatar, String? nickname}) async {
    Map<String, dynamic> updatedData = <String, dynamic>{};

    if (nickname != null) {
      updatedData.addAll({UserConverter.NICKNAME: nickname});
    }

    var image = avatar;

    if (avatar != null) {
      final Directory systemTempDir =
          Directory.systemTemp; // getting tempory directory

      final byteData = await rootBundle
          .load("assets/montain.jpg"); // loading image using rootBundle
      var uuid = Uuid();
      // Generate a v1 (time-based) id
      String? imageName = uuid.v1();
      final file = File('${systemTempDir.path}/$imageName.jpg');

      if (image == null) {
        await file.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      } else {
        await file.writeAsBytes(
            image.buffer.asUint8List(image.offsetInBytes, image.lengthInBytes));
      }

      String path = "assets";
      var storage = FirebaseStorage.instance;
      TaskSnapshot taskSnapshot =
          await storage.ref('$path/$imageName').putFile(file);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      updatedData.addAll({UserConverter.AVATAR_URL: downloadUrl});
    }
    return await _userCollection.doc(userUid).update(updatedData);
  }

  Future<List<UserModel>> getUsers() async {
    final response =
    await http.get('http://jsonplaceholder.typicode.com/users');
    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);
      return [];
    } else {
      throw Exception('Error fetching users');
    }
  }
}
