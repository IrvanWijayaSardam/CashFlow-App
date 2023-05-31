import 'package:flutter/foundation.dart';

class Summary with ChangeNotifier {
  final int transactionOut;
  final int transactionIn;

  Summary({@required this.transactionOut, @required this.transactionIn});
}
