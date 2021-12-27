import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _userCollection = _firestore.collection('users');
final CollectionReference _postCollection = _firestore.collection('posts');

class Database {
  static String? userUid;
  static String? postUid;

  static Future<void> addUser({
    required String nickname,
    required String email,
  }) async {
    // DocumentReference documentReferencer =
    // _mainCollection.doc(userUid).collection('email').doc();
    DocumentReference documentReferencer =
    // _mainCollection.doc(userUid);
    _userCollection.doc("12345");

    Map<String, dynamic> data = <String, dynamic>{
      "nickname": nickname,
      "email": email,
    };


    final Directory systemTempDir = Directory.systemTemp;                           // getting tempory directory

    final byteData = await rootBundle.load("assets/montain.jpg"); // loading image using rootBundle
    String imageName = "montain";
    final file = File('${systemTempDir.path}/$imageName.jpg');

    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    String path = "assets";
    var storage = FirebaseStorage.instance;
    TaskSnapshot taskSnapshot =
    await storage.ref('$path/$imageName').putFile(file);
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection(path)
        .add({"url": downloadUrl, "name": imageName});

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Заметка добавлена в базу"))
        .catchError((e) => print(e));
  }

  static Future<void> addPost({
    String? description,
    required String date,
    required String authorUid,
    ByteData? image, // todo
  }) async {
    final Directory systemTempDir = Directory.systemTemp;                           // getting tempory directory

    final byteData = await rootBundle.load("assets/montain.jpg"); // loading image using rootBundle
    var uuid = Uuid();
    // Generate a v1 (time-based) id
    String? imageName = uuid.v1();
    final file = File('${systemTempDir.path}/$imageName.jpg');

    if (image == null) {
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    } else {
      await file.writeAsBytes(image.buffer
          .asUint8List(image.offsetInBytes, image.lengthInBytes));
    }

    String path = "assets";
    var storage = FirebaseStorage.instance;
    TaskSnapshot taskSnapshot =
    await storage.ref('$path/$imageName').putFile(file);
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    await _postCollection.doc()
        .set({
      "description": description,
      "date": date,
      "authorUid": authorUid,
      "url": downloadUrl /*,
      "name": imageName*/
    });
  }

  static Future<Post> getPostByUid({
    required String postUid
  }) async {
    // postUid = "07tB8xx24CSt3WJRY9FP";
    var snapshot = await _postCollection.doc(postUid).get();
    var data = snapshot.data();
    String authorUid = data['authorUid'];
    String date = data['date'];
    String description = data['description'];
    String url = data['url'];
    Post post = Post(id: postUid, name: description, date: date, imageUrl: url, likeStatus: LikeStatus.inactive);
    return post;
  }

  // static Future<Post> getPosts() async {
  //   postUid = "07tB8xx24CSt3WJRY9FP";
  //   var snapshot = await _postCollection.doc().get();
  //   var data = snapshot.data();
  //   String authorUid = data['authorUid'];
  //   String date = data['date'];
  //   String description = data['description'];
  //   String url = data['url'];
  //   // Post post = Post(id: postUid, name: description, date: date, imageUrl: url, likeStatus: LikeStatus.inactive);
  //   // return post;
  // }

  static Future<ByteData> getDummyImage() {
    return rootBundle.load("assets/splash.jpg"); // loading image using rootBundle
  }

  // Future<Post> convertToPost(Future<DocumentSnapshot> snapshot) async {
  //   getPost(postUid: postUid)
  //   return Post(
  //     id: snapshot['id'],
  //     name: json['name'],
  //     date: json['date'],
  //     imageUrl: json['imageUrl'],
  //     likeStatus: json['likeStatus'],
  //   );
  // }
}