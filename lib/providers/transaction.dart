import 'package:flutter/foundation.dart';

class Transaction with ChangeNotifier {
  final int id;
  final int userId;
  final String transactionType;
  final String date;
  final int transactionValue;
  final String description;
  final String transactionGroup;

  Transaction({
    @required this.id,
    @required this.userId,
    @required this.transactionType,
    @required this.date,
    @required this.transactionValue,
    @required this.description,
    @required this.transactionGroup
  });
}
