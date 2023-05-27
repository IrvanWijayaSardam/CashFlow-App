import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './transaction.dart';

class Transactions with ChangeNotifier {
  List<Transaction> _items = [];

  final String jwtToken;

  Transactions(this.jwtToken, this._items);

  List<Transaction> get items {
    return [..._items];
  }

  Future<void> fetchAndSetTransactions() async {
    var url = 'http://157.245.55.214:8001/api/transaction';
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': jwtToken,
        },
      );
      final responseData = json.decode(response.body);
      if (responseData['status'] != true) {
        // Handle error when the response status is not true
        return;
      }
      final List<Transaction> loadedTransactions = [];
      final List<dynamic> transactionsData = responseData['data'];
      transactionsData.forEach((trxData) {
        loadedTransactions.add(Transaction(
          id: trxData['id'],
          userId: trxData['user_id'],
          transactionType: trxData['transaction_type'],
          date: trxData['date'],
          transactionValue: trxData['transaction_value'],
        ));
      });
      _items = loadedTransactions;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
