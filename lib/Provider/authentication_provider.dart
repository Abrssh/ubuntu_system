import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider extends ChangeNotifier {
  User? _user;
  User? get userVal => _user;

  assignUser(User user) {
    _user = user;
  }
}
