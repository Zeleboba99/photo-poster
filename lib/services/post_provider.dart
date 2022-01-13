import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_bloc.dart';
import 'package:mobile_apps/authentication_bloc/authentication_state.dart';
import 'package:mobile_apps/models/comment.dart';
import 'package:mobile_apps/models/post.dart';
import 'package:mobile_apps/models/user.dart';
import 'package:mobile_apps/services/converters/comment_converter.dart';
import 'package:mobile_apps/services/converters/post_converter.dart';
import 'package:mobile_apps/services/converters/user_converter.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _userCollection = _firestore.collection('users');
final CollectionReference _postCollection = _firestore.collection('posts');
final CollectionReference _commentCollection =
    _firestore.collection('comments');

class PostProvider {
  static const POST_PAGE_SIZE = 3;
  static const COMMENT_PAGE_SIZE = 10;
  static const COMMENT_PAGE_SIZE_FOR_PREVIEW_MODE = 3;
  static const POST_PAGE_SIZE_FOR_SPECIFIED_USER = 10;

  Future<List<PostModel>> getPostsByUserUid(String userUid,
      {Timestamp? after}) async {
    String currentUserUid = _getCurrentUserUid();
    List<PostModel> postModels = [];

    var userSnapshot = await _userCollection.doc(userUid).get();
    var userData = userSnapshot.data();
    UserModel userModel = await UserConverter.convertToUser(userUid, userData);

    var query = _postCollection
        .where(PostConverter.AUTHOR_UID, isEqualTo: userUid)
        .orderBy(PostConverter.CREATED_AT, descending: true);

    if (after != null) {
      query =
          query.startAfter([after]).limit(POST_PAGE_SIZE_FOR_SPECIFIED_USER);
    } else {
      query = query
          // .startAfter([Timestamp.now()])
          .limit(POST_PAGE_SIZE_FOR_SPECIFIED_USER);
    }
    var snapshot = await query.get();
    print(snapshot.toString());
    var postDocs = snapshot.docs;

    for (var postDoc in postDocs) {
      var data = postDoc.data();
      PostModel post =
          await PostConverter.convertToPost(postDoc.id, data, currentUserUid);

      post.hasComments = (await getComments(post.uid, forPreviewMode: true)).isNotEmpty;

      post.userModel = userModel;

      postModels.add(post);
      print(post.toString());
    }

    print("was fetched " + postModels.length.toString() + " posts");
    return postModels;
  }

  getPost(String postUid) async {
    String currentUserUid = _getCurrentUserUid();
    var snapshot = await _postCollection.doc(postUid).get();
    var data = snapshot.data();
    PostModel post =
        await PostConverter.convertToPost(postUid, data, currentUserUid);

    post.hasComments = (await getComments(post.uid, forPreviewMode: true)).isNotEmpty;

    post.userModel = await loadAndCacheUser([], post.authorUid);

    return post;
  }

  Future<List<PostModel>> getPosts({Timestamp? after}) async {
    String currentUserUid = _getCurrentUserUid();

    List<PostModel> postModels = [];
    List<UserModel> loadedUsers = [];

    var query =
        _postCollection.orderBy(PostConverter.CREATED_AT, descending: true);

    if (after != null) {
      print("after " + after.toDate().toString());
      query = query.startAfter([after]).limit(POST_PAGE_SIZE);
    } else {
      query = query
          // .startAfter([Timestamp.now()])
          .limit(POST_PAGE_SIZE);
      print("after was null" + Timestamp.now().toString());
    }
    var snapshot = await query.get();
    print(snapshot.toString());
    var postDocs = snapshot.docs;

    for (var postDoc in postDocs) {
      var data = postDoc.data();
      PostModel post =
          await PostConverter.convertToPost(postDoc.id, data, currentUserUid);

      post.hasComments = (await getComments(post.uid, forPreviewMode: true)).isNotEmpty;

      post.userModel = await loadAndCacheUser(loadedUsers, post.authorUid);

      postModels.add(post);
      print(post.toString());
    }

    print("was fetched " + postModels.length.toString() + " posts");
    return postModels;
  }

  Future<List<CommentModel>> getComments(String postUid,
      {Timestamp? after, bool? forPreviewMode}) async {
    List<CommentModel> loadedComments = [];
    List<UserModel> loadedUsers = [];

    var query = _commentCollection
        .where(CommentConverter.POST_UID, isEqualTo: postUid)
        .orderBy(PostConverter.CREATED_AT, descending: true);

    if (after != null) {
      query = query.startAfter([after]);
    }

    if (forPreviewMode == true) {
      query = query.limit(COMMENT_PAGE_SIZE_FOR_PREVIEW_MODE);
    } else {
      query = query.limit(COMMENT_PAGE_SIZE);
    }

    var snapshot = await query.get();
    var commentDocs = await snapshot.docs;

    for (var commentDoc in commentDocs) {
      var data = await commentDoc.data();
      CommentModel commentModel =
          await CommentConverter.convertToComment(commentDoc.id, data);

      commentModel.userModel =
          await loadAndCacheUser(loadedUsers, commentModel.authorUid);

      loadedComments.add(commentModel);
      print(commentModel.toString());
    }

    print("was fetched " + loadedComments.length.toString() + " comments");
    print("was fetched " + loadedComments.toString() + " comments");
    return await loadedComments;
  }

  setLike(LikeStatus newLikeStatus, PostModel postModel, String userUid) async {
    postModel.likedBy ??= [];
    if (newLikeStatus == LikeStatus.inactive) {
      postModel.likedBy!.removeAt(postModel.likedBy!.indexOf(userUid));
    } else {
      if (postModel.likedBy!.any((element) => element == userUid) == false) {
        postModel.likedBy!.add(userUid);
      }
    }
    await _postCollection
        .doc(postModel.uid)
        .update({PostConverter.LIKED_BY: postModel.likedBy});
  }

  Future<void> publishPost(PostModel postModel) async {
    var image = postModel.image;

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
    postModel.imageUrl = downloadUrl;
    return await _postCollection
        .doc()
        .set(PostConverter.convertToMap(postModel));
  }

  leaveComment(CommentModel commentModel) async {
    await _commentCollection
        .doc()
        .set(CommentConverter.convertToMap(commentModel));
  }

  removePost(String postUid) async {
    _postCollection.doc(postUid).delete();
    for (var element in (await getComments(postUid))) {
      _commentCollection.doc(element.uid).delete();
    }
  }

  removeComment(String commentUid) async {
    _commentCollection.doc(commentUid).delete();
  }

  complain(String postUid) {
    //todo
  }

  static Future<ByteData> getDummyImage() {
    return rootBundle
        .load("assets/splash.jpg"); // loading image using rootBundle
  }

  Future<UserModel> loadAndCacheUser(
      List<UserModel> loadedUsers, String userUid) async {
    if (loadedUsers.any((element) => element.uid == userUid)) {
      return loadedUsers.firstWhere((element) => element.uid == userUid);
    } else {
      var userSnapshot = await _userCollection.doc(userUid).get();
      var userData = userSnapshot.data();
      UserModel userModel =
          await UserConverter.convertToUser(userUid, userData);
      loadedUsers.add(userModel);
      return userModel;
    }
  }

  bool hasComments(PostModel postModel) {
    return postModel.comments != null && postModel.comments!.length > 0;
  }

  _getCurrentUserUid() {
    AuthenticationState state =
        BlocProvider.of<AuthenticationBloc>(navigatorKey.currentContext!).state;
    if (state is Authenticated) {
      return state.userModel.uid;
    } else {
      throw Exception("User was not authenticated");
    }
  }
}
