import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:usermanual/services/toast.dart';

class AuthServicehelper {
  static Future<String> createAccountWithemailandPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        return "AccountCreated";
      });
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
    return "";
  }

  static Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return "Login sucess";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future checkLogin(String email, String password) async {
    var currentuser = FirebaseAuth.instance.currentUser;
    return currentuser != null
        ? await FirebaseFirestore.instance
            .collection('User')
            .where('email', isEqualTo: email)
            .get()
            .then((value) {
            return Message.show(msg: value);
          })
        : false;
  }

  static Future getcurentuser() async {
    var curentuser = FirebaseAuth.instance.currentUser;
    return curentuser;
  }

  static Future<bool> checklogininit() async {
    var curentuser = FirebaseAuth.instance.currentUser;
    return curentuser != null ? true : false;
  }
}
