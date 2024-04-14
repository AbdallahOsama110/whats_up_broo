// ignore_for_file: prefer_const_constructors, invalid_return_type_for_catch_error
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whats_up_broo/classes/userData.dart';
import '../core/utils/cache_helper.dart';
import '../functions/show_snack_bar.dart';
import '../screens/home_screen.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');
  final FirebaseStorage storage = FirebaseStorage.instance;

//* addUserData method inside the signUpUser
  Future<void> signUpUser(
    BuildContext context,
    Function clearAll,
    Function customDialog,
    Function clearPasswordTextFields, {
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      //TODO:=========(this statement to creat new account.)==================
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);
      //! ============(add to users collection method)======================
      UserData userData = UserData(
        email: email,
        uid: userCredential.user!.uid,
        username: name,
        profileImageUrl: null,
        bio: "Hey there, I'm using WhatsUpBro.",
      );
      await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData.toJson());
      //!============================================================
      //TODO==================================================================
      //*======(this part will execute if there are no any Exceptions)==========
      clearAll();
      showSnackBar(context, 'Account created succsessfully...', true);
      customDialog();
      //*=======================================================================

      //? this "on FirebaseAuthException" catches two Exceptions (weak-password & account already exists)
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password provided is too weak!', false);
        clearPasswordTextFields();
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(
            context, 'The account already exists for that email!', false);
        clearAll();
      }
      //?=================================================================================================

      //*=========(this (catch) to catch any other Exceptions)==================
    } catch (e) {
      showSnackBar(context, '$e', false);
    }
  }

  Future<void> signInUser(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController, {
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      showSnackBar(context, 'Sign In Successfully...', true);
      await CacheHelper.putData(key: 'email', value: email);
      await CacheHelper.putData(key: 'password', value: password);
      emailController.clear();
      passwordController.clear();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email!', false);
        emailController.clear();
        passwordController.clear();
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Wrong password provided for that user!', false);
        passwordController.clear();
      }
    } catch (e) {
      showSnackBar(context, '$e', false);
    }
  }

  Future<UserData> getUserData() async {
    User currentUser = auth.currentUser!;
    DocumentSnapshot snap =
        await firestore.collection('users').doc(currentUser.uid).get();
    return UserData.fromJson(snap);
  }

  Future<void> updateUserData(
      BuildContext context, String fieldKey, String data, dynamic updateData) {
    User currentUser = auth.currentUser!;
    return usersRef
        .doc(currentUser.uid)
        .update({fieldKey: data})
        .then(
          (value) => updateData,
        )
        .catchError((error) =>
            showSnackBar(context, "Failed to update user: $error", false));
  }

  Future<String> uploadProfileImageToStorage(
      String childName, Uint8List fileImage) async {
    Reference ref = storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(fileImage);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> updateProfilImage(BuildContext context, dynamic updateData,
      {required Uint8List fileImage}) async {
    if (fileImage.isNotEmpty) {
      String profileImageUrl =
          await uploadProfileImageToStorage(auth.currentUser!.uid, fileImage);
      if (profileImageUrl.isNotEmpty) {
        await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .update({'profileImageUrl': profileImageUrl}).catchError((error) =>
                showSnackBar(context, "Failed to update user: $error", false));

        await auth.currentUser?.updatePhotoURL(profileImageUrl);
      }
    }
  }
}
