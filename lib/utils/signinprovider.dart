import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailSignIn extends ChangeNotifier {
  void _showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: Colors.greenAccent,
      webBgColor: const Color(0xFFE8F5E9),
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 2,
    );
  }

  bool _isSigningIn = true;

  EmailSignIn() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future<void> loginWithEmailPassword(String email, String password) async {
    var connectionStatus = await Connectivity().checkConnectivity();
    if (connectionStatus == ConnectivityResult.none) {
      _showToast('No Internet! Check your connection');
      return;
    }

    isSigningIn = true;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _showToast('Identity Verified. Logging in..');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showToast('No user found for the given email.');
      } else if (e.code == 'wrong-password') {
        _showToast('Wrong password');
      }
    }

    isSigningIn = false;
  }

  void logout() async {
    isSigningIn = true;
    await FirebaseAuth.instance.signOut();
    isSigningIn = false;
  }
}
