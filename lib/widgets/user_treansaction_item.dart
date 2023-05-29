import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_transaction_screen.dart';
import '../providers/transactions.dart';
import '../utils/utils.dart';

class UserTransactionItem extends StatelessWidget {
  final int id;
  final int userId;
  final String transactionType;
  final String date;
  final int transactionValue;
  final String description;

  UserTransactionItem(this.id, this.userId, this.transactionType, this.date,
      this.transactionValue,this.description);

  @override
  Widget build(BuildContext context) {
    final scaffoldMsg = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(description),
      subtitle: Text(transactionType.toString() == "1" ? "Uang Masuk: +${Utils.formatCurrency(transactionValue)}" : "Uang Keluar: -${Utils.formatCurrency(transactionValue)}"), // Add this line
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
              onPressed: () async {
                try {
                  await Provider.of<Transactions>(context, listen: false)
                      .deleteTransaction(id);
                } catch (error) {
                  scaffoldMsg.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
