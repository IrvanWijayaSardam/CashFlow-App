import 'package:cashflow/widgets/transactions_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';

class TransactionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final trxData = Provider.of<Transactions>(context);
    final products = trxData.items;


    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: TransactionItem(
          // products[i].id,
          // products[i].title,
          // products[i].imageUrl,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}