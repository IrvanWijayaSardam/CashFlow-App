import 'package:cashflow/screens/user_transaction_screen.dart';
import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';
import '../screens/report_screen.dart';

class AppDrawer extends StatelessWidget {
  final String drawerTitle;

  const AppDrawer({Key key, this.drawerTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello, $drawerTitle !' ?? "Hello friend!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Transactions'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserTransactionsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Laporan'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ReportScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Manage Profile'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProfileScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
