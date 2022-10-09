import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../landing/screens/landing_screen.dart';

class LogoutRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void logout(context) {
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, LandingScreen.routeName, (route) => false);
  }
}