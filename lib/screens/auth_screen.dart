import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthMode { Signup, Login }

enum Gender { male, female }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final authData = Provider.of<Auth>(context, listen: false);

    // Check if the user is already authenticated
    authData.tryAutoLogin().then((isAuthenticated) {
      if (isAuthenticated) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AuthCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'gender': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['name'],
          _authData['email'],
          _authData['password'],
          "-",
          _authData['telp'],
          _authData['pin'],
          _authData['gender'],
        );
      }
    } on HttpException catch (error) {
      if (error != null) {
        if (error.toString().contains("Duplicate")) {
          _showErrorDialog("Ooops, Email Sudah Digunakan");
        } else if (error.toString().contains("Invalid Credential")) {
          _showErrorDialog("Email Atau Password Salah");
        } else {
          _showErrorDialog(error.toString());
        }
      }
    } catch (error) {
      _showErrorDialog("masuk catch bawah");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Gender _selectedGender;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        }
                      : null,
                ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Full Name'),
                  onSaved: (value) {
                    _authData['name'] = value;
                  },
                ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    _authData['telp'] = value;
                  },
                ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Pin'),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _authData['pin'] = value;
                  },
                ),
              if (_authMode == AuthMode.Signup)
                Row(
                  children: [
                    Text('Gender'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: "Male",
                          groupValue: _authData['gender'],
                          onChanged: (value) {
                            setState(() {
                              _authData['gender'] = value;
                            });
                          },
                        ),
                        Text('MALE'),
                        SizedBox(width: 20),
                        Radio(
                          value: "Female",
                          groupValue: _authData['gender'],
                          onChanged: (value) {
                            setState(() {
                              _authData['gender'] = value;
                            });
                          },
                        ),
                        Text('Female'),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                SizedBox(
                  width: 300.0,
                  height: 40.0,
                  child: ElevatedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                  ),
                ),
              SizedBox(height: 20),
              SizedBox(
                width: 300.0,
                height: 40.0,
                child: ElevatedButton(
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGN UP' : 'LOGIN'} INSTEAD',
                  ),
                  onPressed: _switchAuthMode,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
