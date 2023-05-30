import 'package:flutter/foundation.dart';

class Report with ChangeNotifier {
  final String transactionGroup;
  final int total_transaction;

  Report({@required this.transactionGroup, @required this.total_transaction});
}
