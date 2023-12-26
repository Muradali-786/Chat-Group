import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';

const String USER_COLLECTION = "Users";

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService() {}

  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      Reference ref =
          _storage.ref().child('images/users/$uid/profile.${file.extension}');

      UploadTask uploadTask = ref.putFile(
        File(file.path!),
      );
      await Future.value(uploadTask);
      final newUrl = await ref.getDownloadURL();
      return newUrl.toString();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<String?> saveChatImage(
      String _chatId, String userId, PlatformFile file) async {
    try {
      Reference ref = _storage.ref().child(
          'images/chats/${_chatId}/${userId}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}');

      UploadTask uploadTask = ref.putFile(
        File(file.path!),
      );
      await Future.value(uploadTask);
      final newUrl = await ref.getDownloadURL();
      return newUrl.toString();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
