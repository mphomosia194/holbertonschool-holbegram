import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "Please fill all the fields";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    String res = "Please fill all the fields";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;

        Users users = Users(
          uid: user!.uid,
          email: email,
          username: username,
          bio: '',
          photoUrl: '',
          followers: [],
          following: [],
          posts: [],
          saved: [],
          searchKey: username[0].toUpperCase(),
        );

        await _firestore
            .collection("users")
            .doc(user.uid)
            .set(users.toJson());

        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
Future<Users> getUserDetails() async {
  User currentUser = _auth.currentUser!;

  DocumentSnapshot snap = await _firestore
      .collection('users')
      .doc(currentUser.uid)
      .get();

  return Users.fromSnap(snap);
}
}
