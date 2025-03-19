import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:terra_fertil/data/store.dart';
import 'package:terra_fertil/exception/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logOutTimer;
  static const _apiKey = 'AIzaSyDYhCUaedir60eisZMMID0SuqfnwsMOm-o';
  static const _url = 'https://identitytoolkit.googleapis.com/v1/accounts:';

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  Future<void> _autenticate(
    String email,
    String password,
    String urlFragment,
  ) async {
    final url = '$_url$urlFragment?key=$_apiKey';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn'])),
      );
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    final expiryDate = DateTime.tryParse(userData['expiryDate'] ?? '');
    if (expiryDate == null || expiryDate.isBefore(DateTime.now())) {
      print("Token expirado ou inválido.");
      return;
    }

    _token = userData['token'];
    _userId = userData['userId'];
    _email = userData['email'];
    _expiryDate = expiryDate;
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    return _autenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _autenticate(email, password, 'signInWithPassword');
  }

  Future<void> signout() async {
    _expiryDate = null;
    _userId = null;
    _email = null;
    _token = null;
    _logOutTimer?.cancel();
    _logOutTimer = null;
    Store.remove('userData');
    notifyListeners();
  }

  // Future<void> _autoSignout() async {
  //   _logOutTimer?.cancel();
  //   _logOutTimer = null;
  //   final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
  //   _logOutTimer = Timer(Duration(seconds: timeToLogout ?? 0), signout);
  //   notifyListeners();
  // }
}
