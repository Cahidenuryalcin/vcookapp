import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vcook_app/recieps.dart';

class Auth{
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(BuildContext context, { required String name,required String email,required String password}) async{
    try{
      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        await registerUser(name: name,email: email,password: password);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Recieps(),));

      }

    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message! , toastLength: Toast.LENGTH_LONG);
    }

  }

  Future<void> signIn(BuildContext context, {required String email,required String password}) async{
    try{
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Recieps(),));
      }

      }on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message! , toastLength: Toast.LENGTH_LONG);
  }

  }

  Future<void> registerUser({ required String name,required String email,required String password}) async{
    await userCollection.doc().set({
      "name" : name,
      "email" : email,
      "password" : password

    });
  }


}