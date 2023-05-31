import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/profile.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "/edit-profile";

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var _editedProfile = Profile(
    name: '',
    email: '',
    password: '',
    jk: '',
    pin: '',
    profile: '',
    telp: '',
  );

  var _initValues = {
    'name': '',
    'email': '',
    'profile': '',
    'telp': '',
    'pin': '',
    'jk': '',
  };

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final auth = Provider.of<Auth>(context);

    _editedProfile = Profile(
      name: auth.name ?? '',
      email: auth.email ?? '',
      password: '',
      jk: auth.jk ?? '',
      pin: auth.pin ?? '',
      profile: auth.profile ?? '',
      telp: auth.telp ?? '',
    );
    _initValues = {
      'name': _editedProfile.name,
      'email': _editedProfile.email,
      'profile': _editedProfile.profile,
      'telp': _editedProfile.telp,
      'pin': _editedProfile.pin,
      'jk': _editedProfile.jk,
    };

    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    try {
      print(_editedProfile.name.toString());
      await Provider.of<Auth>(context, listen: false).update(_editedProfile);
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured!'),
          content: Text(error.toString()),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Okay'),
              onPressed: () {
                // Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {});
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Column(
        children: [
          Consumer<Auth>(
            builder: (ctx, auth, _) => Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(16.0),
              child: ClipOval(
                child: Image.network(
                  auth.profile,
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Image.asset(
                      'assets/images/user.png', // Replace with your placeholder image path
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: TextFormField(
              initialValue: _initValues['name'],
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _editedProfile = Profile(
                    name: value,
                    email: _editedProfile.email,
                    password: _editedProfile.password,
                    jk: _editedProfile.jk,
                    pin: _editedProfile.pin,
                    profile: _editedProfile.profile,
                    telp: _editedProfile.telp,
                  );
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: TextFormField(
              initialValue: _initValues['email'],
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _editedProfile = Profile(
                    name: _editedProfile.name,
                    email: value,
                    password: _editedProfile.password,
                    jk: _editedProfile.jk,
                    pin: _editedProfile.pin,
                    profile: _editedProfile.profile,
                    telp: _editedProfile.telp,
                  );
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: TextFormField(
              initialValue: _initValues['telp'],
              decoration: InputDecoration(
                labelText: 'Telephone',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _editedProfile = Profile(
                    name: _editedProfile.name,
                    email: _editedProfile.email,
                    password: _editedProfile.password,
                    jk: _editedProfile.jk,
                    pin: _editedProfile.pin,
                    profile: _editedProfile.profile,
                    telp: value,
                  );
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: TextFormField(
              initialValue: _initValues['profile'],
              decoration: InputDecoration(
                labelText: 'Link Profile',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _editedProfile = Profile(
                    name: _editedProfile.name,
                    email: _editedProfile.email,
                    password: _editedProfile.password,
                    jk: _editedProfile.jk,
                    pin: _editedProfile.pin,
                    profile: value,
                    telp: _editedProfile.telp,
                  );
                });
              },
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                  value: "MALE",
                  groupValue: _editedProfile.jk,
                  onChanged: (value) {
                    setState(() {
                      _editedProfile = Profile(
                        name: _editedProfile.name,
                        email: _editedProfile.email,
                        password: _editedProfile.password,
                        jk: value,
                        pin: _editedProfile.pin,
                        profile: _editedProfile.profile,
                        telp: _editedProfile.telp,
                      );
                    });
                  },
                ),
                Text('MALE'),
                SizedBox(width: 20),
                Radio(
                  value: "FEMALE",
                  groupValue: _editedProfile.jk,
                  onChanged: (value) {
                    setState(() {
                      _editedProfile = Profile(
                        name: _editedProfile.name,
                        email: _editedProfile.email,
                        password: _editedProfile.password,
                        jk: value,
                        pin: _editedProfile.pin,
                        profile: _editedProfile.profile,
                        telp: _editedProfile.telp,
                      );
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
