import 'package:flutter/material.dart';
import 'package:flutterapp/data/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  NotLoggedIn,
  LoggedIn,
  Loading,
  AuthError,
}

class SignInProvider with ChangeNotifier {
  final _apiHelper = ApiHelper();

  AuthStatus loginStatus = AuthStatus.NotLoggedIn;
  notifyListeners();

  dynamic signIn({String email, String password}) async {
    loginStatus = AuthStatus.Loading;
    notifyListeners();
    try {
      final response =
          await _apiHelper.signin(email: email, password: password);
      loginStatus = AuthStatus.LoggedIn;
      notifyListeners();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", response.data["token"]);

      return true;
    } catch (e) {
      loginStatus = AuthStatus.AuthError;
      notifyListeners();
      return e;
    }
  }
}
