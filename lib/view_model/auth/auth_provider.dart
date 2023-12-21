import 'package:chat_group/view_model/services/data_base/data_base_service.dart';
import 'package:chat_group/view_model/services/navigation/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../model/chat_user.dart';

class AuthenticationProvider with ChangeNotifier {
  late final FirebaseAuth _auth;
  late final DataBaseService _dataBaseService;
  late final NavigationService _navigationService;
  late ChatUserModel chatUserData;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _dataBaseService = GetIt.instance.get<DataBaseService>();
    // _auth.signOut();

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _dataBaseService.updateUserLastScene(user.uid);
        _dataBaseService.getUser(user.uid).then(
              (snapshot) {
            Map<String, dynamic> _userData =
            snapshot.data()! as Map<String, dynamic>;
            chatUserData = ChatUserModel.fromJSON(
              {
                "uid": user.uid,
                "name": _userData["name"],
                "email": _userData["email"],
                "last_active": _userData["last_active"],
                "image": _userData["image"],
              },
            );
            _navigationService.removeAndNavigateToRoute('/home');
          },
        );
      }else {
        _navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (value) {
          print('login successful');
        },
      );
    } on FirebaseAuthException {
      if (kDebugMode) {
        print("error during login to firebase");
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          e.toString(),
        );
      }
    }
  }

  Future<String?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return credential.user!.uid;
    } on FirebaseAuthException {
      if (kDebugMode) {
        print("error during signup to firebase");
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          e.toString(),
        );
      }
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
