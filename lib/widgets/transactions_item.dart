import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction.dart';
import '../utils/utils.dart';

class TransactionItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transaction = Provider.of<Transaction>(context, listen: true);

    return GestureDetector(
      onTap: () {
        // Add your desired functionality here
        print('Card tapped!');
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transaction.date,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    transaction.description,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    "https://api.duniagames.co.id/api/content/upload/file/3938980811652179565.jpg",
                    width: 20.0,
                    height: 20.0,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 8.0),
                  Expanded(
                    child: Text(
                      transaction.transactionType.toString() == "1" ? " Uang Masuk +${Utils.formatCurrency(transaction.transactionValue)}" : "Uang Keluar -${Utils.formatCurrency(transaction.transactionValue)}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
