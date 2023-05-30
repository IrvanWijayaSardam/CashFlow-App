import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import './profile.dart';

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

  String get name {
    if (_name != null) {
      return _name;
    }
    return null;
  }

  set name(String name) {
    _name = name;
  }

  String get profile {
    if (_profile != null) {
      return _profile;
    }
    return null;
  }

  set profile(String profile) {
    _profile = profile;
  }

  String get pin {
    if (_pin != null) {
      return _pin;
    }
    return null;
  }

  set pin(String pin) {
    _pin = pin;
  }

  String get jk {
    if (_jk != null) {
      return _jk;
    }
    return null;
  }

  set jk(String jk) {
    _jk = jk;
  }

  String get email {
    if (_email != null) {
      return _email;
    }
    return null;
  }

  set email(String email) {
    _email = email;
  }

  String get telp {
    if (_telp != null) {
      return _telp;
    }
    return null;
  }

  set telp(String telp) {
    _telp = telp;
  }

  int get userId {
    if (_id != null) {
      return _id;
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
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': name,
            'email': email,
            'password': password,
            'profile': profile,
            'telp': telp,
            'pin': pin,
            'Jk': jk,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
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
      } else {
        // Check if the error response contains 'errors' field
        if (responseData['errors'] != null) {
          throw HttpException(responseData['errors'].toString());
        } else {
          throw HttpException('An error occurred. Please try again later.');
        }
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> _updateAccount(Profile newProfile) async {
    final url = Uri.parse('http://157.245.55.214:8001/api/user/profile');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': jwtToken
        },
        body: json.encode(
          {
            'name': newProfile.name,
            'email': newProfile.email,
            'password': newProfile.password,
            'profile': newProfile.profile,
            'telp': newProfile.telp,
            'pin': newProfile.pin,
            'jk': newProfile.jk,
          },
        ),
      );

      final responseData = json.decode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
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
      } else {
        // Check if the error response contains 'errors' field
        if (responseData['errors'] != null) {
          print(responseData['errors']);
          throw HttpException(responseData['errors'].toString());
        } else {
          print(responseData['errors']);
          throw HttpException('An error occurred. Please try again later.');
        }
      }
    } catch (error) {
      print(error);
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

  Future<void> update(Profile newProfile) async {
    return _updateAccount(newProfile);
  }
}
