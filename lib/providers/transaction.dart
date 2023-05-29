import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Transaction with ChangeNotifier {
  final int id;
  final int userId;
  final String transactionType;
  final String date;
  final int transactionValue;
  final String description;

  Transaction({
    @required this.id,
    @required this.userId,
    @required this.transactionType,
    @required this.date,
    @required this.transactionValue,
    @required this.description
  });
}
