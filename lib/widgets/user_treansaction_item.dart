import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_transaction_screen.dart';
import '../providers/transactions.dart';

class UserTransactionItem extends StatelessWidget {
  final int id;
  final int userId;
  final String transactionType;
  final String date;
  final int transactionValue;

  UserTransactionItem(this.id, this.userId, this.transactionType, this.date,
      this.transactionValue);

  @override
  Widget build(BuildContext context) {
    final scaffoldMsg = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(transactionType),
      subtitle: Text('Transaction Value: $transactionValue'), // Add this line
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditTransactionScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              // onPressed: () async {
              //   try {
              //     await Provider.of<Transactions>(context, listen: false)
              //         .deleteProduct(id);
              //   } catch (error) {
              //     scaffoldMsg.showSnackBar(
              //       SnackBar(
              //         content: Text(
              //           'Deleting failed!',
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //     );
              //   }
              // },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
