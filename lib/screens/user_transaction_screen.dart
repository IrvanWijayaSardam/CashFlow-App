import 'package:cashflow/providers/transactions.dart';
import 'package:cashflow/screens/edit_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../widgets/user_treansaction_item.dart';

import 'package:cashflow/widgets/app_drawer.dart';

class UserTransactionsScreen extends StatelessWidget {
  static const routeName = '/user-transactions';

  Future<void> _refreshTransactions(BuildContext context) async {
    await Provider.of<Transactions>(context, listen: false)
        .fetchAndSetTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final trxData = Provider.of<Transactions>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Transactions'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditTransactionScreen.routeName);
            },
          ),
        ],
      ),
      drawer: Consumer<Auth>(
        builder: (ctx, auth, _) => AppDrawer(
          drawerTitle: auth.name ?? '',
        ),
      ),
        body: RefreshIndicator(
          onRefresh: () => _refreshTransactions(context),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: trxData.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  UserTransactionItem(
                    trxData.items[i].id,
                    trxData.items[i].userId,
                    trxData.items[i].transactionType,
                    trxData.items[i].date,
                    trxData.items[i].transactionValue,
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      );
  }
}