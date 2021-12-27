import 'package:mobile_apps/models/user.dart';
import 'package:mobile_apps/services/use_api_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersRepository {
  UserProvider _usersProvider = UserProvider();
  Future<List<UserModel>> getAllUsers() => _usersProvider.getUser();


  final FirebaseAuth _firebaseAuth;

  UsersRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;


  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp(String email, String password) { // todo
    try {
      print("sign up");
      return _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
    }
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<List<dynamic>> signOut() async { // todo
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    print("check signed in");
    final currentUser = await _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser).email;
  }
  Future<User> getFirebaseUser() async {
    return _firebaseAuth.currentUser;//.email;
  }






  // Future<String> authenticate({
  //   required String username,
  //   required String password,
  // }) async {
  //   await Future.delayed(Duration(seconds: 1));
  //   return 'token';
  // }
  //
  // Future<void> deleteToken() async {
  //   /// delete from keystore/keychain
  //   await Future.delayed(Duration(seconds: 1));
  //   return;
  // }
  //
  // Future<void> persistToken(String token) async {
  //   /// write to keystore/keychain
  //   await Future.delayed(Duration(seconds: 1));
  //   return;
  // }
  //
  // Future<bool> hasToken() async {
  //   /// read from keystore/keychain
  //   await Future.delayed(Duration(seconds: 1));
  //   return false;
  // }



}