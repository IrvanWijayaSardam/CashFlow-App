import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './screens/user_transaction_screen.dart';
import './screens/home_screen.dart';
import './screens/edit_transaction_screen.dart';
import './screens/profile_screen.dart';
import './screens/edit_profile_screen.dart';



import './providers/auth.dart';
import './providers/transactions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Transactions>(
          update: (ctx, auth, previousTransactions) => Transactions(
              auth.jwtToken,
              auth.userId,
              previousTransactions == null ? [] : previousTransactions.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'CashFlow',
          theme: ThemeData(
            primarySwatch: Colors.green,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? HomeScreen() : AuthScreen(),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            UserTransactionsScreen.routeName : (ctx) => UserTransactionsScreen(),
            EditTransactionScreen.routeName : (ctx) => EditTransactionScreen(),
            ProfileScreen.routeName : (ctx) => ProfileScreen(),
            EditProfileScreen.routeName : (ctx) => EditProfileScreen(),
          },
        ),
      ),
    );
  }
}
