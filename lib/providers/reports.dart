import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './report.dart';
import './summary.dart';

class Reports with ChangeNotifier {
  List<Report> _items = [];
  Summary _summary;

  final String jwtToken;

  Reports(this.jwtToken);

  List<Report> get items {
    return [..._items];
  }

  Summary get dataSummary {
    return _summary;
  }

  Future<void> fetchAndSetReports() async {
    var url = Uri.parse('https://cashflow-production-f95f.up.railway.app/api/report');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': jwtToken,
        },
      );
      final responseData = json.decode(response.body);
      print('Report ${responseData}');
      if (responseData['errors'] != null) {
        // Handle error when the response status is not true
        return;
      } else {
        final List<Report> loadedReport = [];
        final List<dynamic> transactionsData = responseData['data'];

        transactionsData.forEach((trxData) {
          loadedReport.add(Report(
              transactionGroup: trxData['transaction_group'],
              total_transaction: trxData['total_transaction']));
        });
        _items = loadedReport;
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetSummary() async {
    var url = Uri.parse('https://cashflow-production-f95f.up.railway.app/api/report/summary');
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
      _summary = Summary(
          transactionOut: responseData['data']['transaction_out'],
          transactionIn: responseData['data']['total_in']);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
