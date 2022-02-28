import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  var accessToken = "";

  void setToken(String token) {
    accessToken = token;
    notifyListeners();
  }
}
