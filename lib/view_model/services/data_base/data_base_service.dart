import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = 'Chats';
const String MESSAGE_COLLECTION = 'Messages';

class DataBaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DataBaseService() {}

  Future<void> saveUserInfoInFirebase(
      String uid, String name, String email, String imageURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).set({
        "email": email,
        "name": name,
        "image": imageURL,
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return _db.collection(USER_COLLECTION).doc(uid).get();
  }

  Future<void> updateUserLastScene(String uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).update({
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print('khan time ni update');
      print(e);
    }
  }
}
