import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/features/auth/domain/entities/app_user.dart';


class AuthService extends ChangeNotifier{
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  //sign up 
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password, String name) async{
    try{
      UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      AppUser _appUser = AppUser(uid: user.user!.uid, email: email, name: name);

      await _firestore.collection('users').doc(_appUser.uid).set({..._appUser.toMap(), 'nameLower': name.toLowerCase()});
      return user;
    } on FirebaseAuthException catch (e){
      throw Exception(e.message);
    }
  }


  //Sign in
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();

      AppUser user = AppUser(
        uid: userCredential.user!.uid, 
        email: email, 
        name: userDoc['name']
      );
      
      return userCredential;


    } on FirebaseAuthException catch (e){
      throw Exception(e.message);
    }
  }
 
  // sign out
  Future<void> signOut() async{
    return await FirebaseAuth.instance.signOut();
  }

  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;

    if(firebaseUser == null){
      return null;
    }

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    if(!userDoc.exists){
      return null;
    }
    return AppUser(
      uid: firebaseUser.uid, 
      email: firebaseUser.email!, 
      name: userDoc['name']
    );
  }
}