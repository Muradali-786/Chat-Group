

import 'package:chat_group/view_model/services/navigation/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = 'Chats';
const String MESSAGE_COLLECTION = 'messages';

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
      }).then((value) {
        GetIt.instance
            .get<NavigationService>()
            .removeAndNavigateToRoute('/home');
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

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageOfChat(String chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSAGE_COLLECTION)
        .orderBy('sent_time', descending: true)
        .limit(1)
        .get();
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
