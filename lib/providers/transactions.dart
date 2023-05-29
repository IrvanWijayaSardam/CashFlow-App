import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import './transaction.dart';
import '../models/http_exception.dart';

class Transactions with ChangeNotifier {
  List<Transaction> _items = [];

  final String jwtToken;
  final int userId;

  Transactions(this.jwtToken, this.userId, this._items);

  List<Transaction> get items {
    return [..._items];
  }

  Transaction findById(int id) {
    return _items.firstWhere((trx) => trx.id == id);
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
          description: trxData['description'],
        ));
      });
      _items = loadedTransactions;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> _createTransaksi(
      String transactionType, String date, int trxValue,String description) async {
    final url = Uri.parse('http://157.245.55.214:8001/api/transaction/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': jwtToken,
        },
        body: json.encode(
          {
            'userid': userId,
            'trxtype': transactionType,
            'date': date,
            'trxvalue': trxValue,
            'description':description,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        print(json.decode(response.body));
        notifyListeners();
      } else {
        // Check if the error response contains 'errors' field
        if (responseData['errors'] != null) {
          throw HttpException(responseData['errors'].toString());
        } else {
          throw HttpException('An error occurred. Please try again later.');
        }
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateTransactions(int id, Transaction newTransaction) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'http://157.245.55.214:8001/api/transaction';
      await http.put(url,
          body: json.encode({
            'id': newTransaction.id,
            'userid': userId,
            'trxtype': newTransaction.transactionType,
            'date': newTransaction.date,
            'trxvalue': newTransaction.transactionValue,
            'description':newTransaction.description,
          }));
      _items[prodIndex] = newTransaction;
      print('Masuk Update');
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> createTransaction(
      String transactionType, String date, int trxValue,String description) async {
    return _createTransaksi(transactionType, date, trxValue,description);
  }
}
