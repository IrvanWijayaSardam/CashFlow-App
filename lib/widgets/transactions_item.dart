import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction.dart';
import '../utils/utils.dart';

class TransactionItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transaction = Provider.of<Transaction>(context, listen: true);

    IconData _getIconForTransactionGroup(String transactionGroup) {
      switch (transactionGroup) {
        case "1":
          return Icons
              .fastfood; // Replace Icons.school with the desired educational hat icon
        case "2":
          return Icons
              .directions_bus; // Replace Icons.home with the desired house icon
        case "3":
          return Icons.hotel; // Replace Icons.money with the desired debt icon
        case "4":
          return Icons
              .shopping_cart; // Replace Icons.fastfood with the desired food/drink icon
        case "5":
          return Icons
              .house; // Replace Icons.shopping_cart with the desired grocery icon
        case "6":
          return Icons
              .school; // Replace Icons.directions_bus with the desired transportation icon
        default:
          return Icons
              .error; // Replace Icons.error with a default icon or handle the case when the transaction group is not recognized
      }
    }

    return GestureDetector(
      onTap: () {
        // Add your desired functionality here
        print('Card tapped!');
      },
      child: Card(
        color: Color.fromARGB(255, 190, 252, 222),
        elevation: 5.0,
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
                  Container(
                    width: 185, // Set the desired width
                    child: Text(
                      transaction.description,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    _getIconForTransactionGroup(transaction.transactionGroup),
                    size: 30.0,
                    color: Colors
                        .black, // Replace Colors.black with the desired color
                  ),
                  SizedBox(height: 8.0),
                  Expanded(
                    child: Text(
                      transaction.transactionType.toString() == "1"
                          ? " Uang Masuk +${Utils.formatCurrency(transaction.transactionValue)}"
                          : "Uang Keluar -${Utils.formatCurrency(transaction.transactionValue)}",
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
