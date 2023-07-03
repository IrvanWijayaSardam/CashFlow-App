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
    var url = Uri.parse('https://cashflow-production-f95f.up.railway.app/api/transaction');
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
            transactionGroup: trxData['transaction_group']));
      });
      _items = loadedTransactions;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> _createTransaksi(String transactionType, String date,
      int trxValue, String description, String trxGroup) async {
    final url = Uri.parse('https://cashflow-production-f95f.up.railway.app/api/transaction/');
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
            'description': description,
            'trxgroup': trxGroup,
          },
        ),
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 201) {
        print(json.decode(response.body));
        final newTransaction = Transaction(id: responseData['data']['id'], userId: userId, transactionType: transactionType, date: date, transactionValue: trxValue, description: description, transactionGroup: trxGroup);
        _items.add(newTransaction);
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

  Future<void> _updateTransaction(int id, Transaction newTransaction) async {
    final trxIndex = _items.indexWhere((prod) => prod.id == id);
    if (trxIndex >= 0) {
      final url = Uri.parse('https://cashflow-production-f95f.up.railway.app/api/transaction/');
      try {
        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': jwtToken,
          },
          body: json.encode(
            {
              'id': newTransaction.id,
              'userid': newTransaction.userId,
              'trxtype': newTransaction.transactionType,
              'date': newTransaction.date,
              'trxvalue': newTransaction.transactionValue,
              'description': newTransaction.description,
              'trxgroup': newTransaction.transactionGroup,
            },
          ),
        );
        _items[trxIndex] = newTransaction;
        final responseData = json.decode(response.body);
        if (response.statusCode == 200) {
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
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> _deleteTransactions(int id) async {
    final url = Uri.parse('https://cashflow-production-f95f.up.railway.app/api/transaction/$id');
    final existingTrxIndex = _items.indexWhere((trx) => trx.id == id);
    var existingTrx = _items[existingTrxIndex];
    _items.removeAt(existingTrxIndex);
    notifyListeners();
    final response = await http.delete(url, headers: {
      'Authorization': jwtToken,
    });
    if (response.statusCode >= 400) {
      _items.insert(existingTrxIndex, existingTrx);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingTrx = null;
  }

  Future<void> createTransaction(String transactionType, String date,
      int trxValue, String description, String trxGroup) async {
    return _createTransaksi(
        transactionType, date, trxValue, description, trxGroup);
  }

  Future<void> updateTransaction(int id, Transaction) async {
    return _updateTransaction(id, Transaction);
  }

  Future<void> deleteTransaction(int id) async {
    return _deleteTransactions(id);
  }
}
