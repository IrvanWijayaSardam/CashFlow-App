import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../widgets/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      drawer: Consumer<Auth>(
          builder: (ctx, auth, _) => AppDrawer(
                drawerTitle: auth.name ?? '',
              )),
      body: Column(
        children: [
          Container(
            height: 100,
            child: Card(
              color: Colors.greenAccent,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.all(15.0),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          // Replace the placeholder image with your own image
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Subtitle',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Button onPressed code
                      },
                      child: Text('EDIT'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.greenAccent,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  height: 50, // Set the desired height for the ListTile
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text('Pengguna',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Container(
                  height: 50, // Set the desired height for the ListTile
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text('Ubah Pin'),
                      trailing: Icon(Icons.arrow_right_alt_outlined, size: 25),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Container(
                  height: 50, // Set the desired height for the ListTile
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text('Bantuan'),
                      trailing: Icon(Icons.arrow_right_alt_outlined, size: 25),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Container(
                  height: 50, // Set the desired height for the ListTile
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text('Tentang Kami'),
                      trailing: Icon(Icons.arrow_right_alt_outlined, size: 25),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Container(
                  height: 50, // Set the desired height for the ListTile
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text('Logout'),
                      trailing: Icon(Icons.arrow_right_alt_outlined, size: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}