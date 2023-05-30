import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import './report.dart';
import '../models/http_exception.dart';

class Reports with ChangeNotifier {
  List<Report> _items = [];

  final String jwtToken;

  Reports(this.jwtToken);

  List<Report> get items {
    return [..._items];
  }

  Future<void> fetchAndSetReports() async {
    var url = 'http://157.245.55.214:8001/api/report';
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': jwtToken,
        },
      );
      final responseData = json.decode(response.body);
      print('Report ${responseData}');
      if (responseData['status'] != true) {
        // Handle error when the response status is not true
        return;
      }
      final List<Report> loadedReport = [];
      final List<dynamic> transactionsData = responseData['data'];

      transactionsData.forEach((trxData) {
        loadedReport.add(Report(
            transactionGroup: trxData['transaction_group'],
            total_transaction: trxData['total_transaction']));
      });
      _items = loadedReport;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}