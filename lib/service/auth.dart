import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vcook_app/main.dart';
import 'package:vcook_app/recieps.dart';

class Auth {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(BuildContext context, {required String name, required String email, required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await registerUser(name: name, email: email, password: password);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Recieps()));
      }
    }  on FirebaseAuthException catch (e) {
      print("Firebase Auth Exception: ${e.code}"); // Hata kodunu logla
      String errorMessage = _getFirebaseAuthErrorMessage(e.code);
      Fluttertoast.showToast(msg: errorMessage, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> signIn(BuildContext context, {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Recieps()));

      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseAuthErrorMessage(e.code);
      Fluttertoast.showToast(msg: errorMessage, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> registerUser({required String name, required String email, required String password}) async {
    await userCollection.doc().set({
      "name": name,
      "email": email,
      "password": password
    });
  }


  Future<void> signOut(BuildContext context) async {
    try {
      await firebaseAuth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()), // Burada başka bir sayfaya yönlendirebilirsiniz.
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Çıkış yapılırken hata oluştu: $e");
      Fluttertoast.showToast(msg: "Çıkış yapılırken hata oluştu", toastLength: Toast.LENGTH_LONG);
    }
  }


  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Geçersiz e-posta adresi. Lütfen e-posta adresinizi kontrol edin.';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanımda. Eğer bu hesap size aitse, lütfen giriş yapın.';
      case 'invalid-credential':
        return 'Yanlış şifre. Lütfen şifrenizi kontrol edin ve tekrar deneyin.';
      case 'too-many-requests':
        return 'Çok fazla başarısız giriş denemesi yapıldı. Lütfen bir süre sonra tekrar deneyin';
      default:
        return 'Bir hata oluştu: $code';
    }
  }
}
