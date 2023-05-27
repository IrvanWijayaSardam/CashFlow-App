import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _jwtToken;
  int _id;
  String _name;
  String _email;
  String _profile;
  String _telp;
  String _pin;
  String _jk;

  bool get isAuth {
    return jwtToken != null;
  }

  String get jwtToken {
    if (_jwtToken != null) {
      return _jwtToken;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password) async {
    final url = Uri.parse('http://157.245.55.214:8001/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(json.decode(response.body));
      if (responseData['errors'] != null) {
        throw HttpException(responseData['errors']);
      }
      _id = responseData["data"]["id"];
      _name = responseData["data"]["name"];
      _email = responseData["data"]["email"];
      _profile = responseData["data"]["profile"];
      _telp = responseData["data"]["telp"];
      _pin = responseData["data"]["pin"];
      _jk = responseData["data"]["jk"];
      _jwtToken = responseData["data"]["token"];

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> _createAccount(String name, String email, String password,
      String profile, String telp, String pin, String jk) async {
    final url = Uri.parse('http://157.245.55.214:8001/api/auth/register');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'name': name,
            'email': email,
            'password': password,
            'profile': profile,
            'telp': telp,
            'pin': pin,
            'jk': jk,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['errors'] != null) {
        throw HttpException(responseData['errors']);
      }
      _jwtToken = responseData["data"]["token"];
      _id = responseData["data"]["id"];
      _name = responseData["data"]["name"];
      _email = responseData["data"]["email"];
      _profile = responseData["data"]["profile"];
      _telp = responseData["data"]["telp"];
      _pin = responseData["data"]["pin"];
      _jk = responseData["data"]["jk"];

      print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<void> signup(String name, String email, String password,
      String profile, String telp, String pin, String jk) async {
    return _createAccount(name, email, password, profile, telp, pin, jk);
  }
}
