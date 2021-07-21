import 'dart:convert';

import 'package:formvalidation/user_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final String _firebaseKey = 'AIzaSyDbWPTlD9VMPlkBGJxn60xXsHdAzpaSi98';
  final _prefs = new UserPreferences();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey',
        body: json.encode(authData));

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse);

    if (decodedResponse.containsKey('idToken')) {
      _prefs.token = decodedResponse['idToken'];
      return {'ok': true, 'token': decodedResponse['idToken']};
    } else {
      return {'ok': false, 'message': decodedResponse['error']['message']};
    }
  }

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseKey',
        body: json.encode(authData));

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse);

    if (decodedResponse.containsKey('idToken')) {
      _prefs.token = decodedResponse['idToken'];
      return {'ok': true, 'token': decodedResponse['idToken']};
    } else {
      return {'ok': false, 'message': decodedResponse['error']['message']};
    }
  }
}
