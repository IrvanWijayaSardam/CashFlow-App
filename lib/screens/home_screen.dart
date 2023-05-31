import 'package:cashflow/widgets/transactions_grid.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../providers/transactions.dart';
import '../providers/reports.dart';
import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = false;
  var _isInit = true;
  String transactionType;
  DateTime selectedDate;
  double transactionValue;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Transactions>(context, listen: false)
          .fetchAndSetTransactions()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      Provider.of<Reports>(context, listen: false)
          .fetchAndSetSummary()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CashFlow'),
      ),
      drawer: Consumer<Auth>(
          builder: (ctx, auth, _) => AppDrawer(
                drawerTitle: auth.name ?? '',
              )),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 5.0,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<Reports>(
                            builder: (ctx, report, _) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Saldo',
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold)),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    '${Utils.formatCurrency(report.dataSummary.transactionIn - report.dataSummary.transactionOut)}',
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                    'Pemasukan : ${Utils.formatCurrency(report.dataSummary.transactionIn)}'),
                                Text(
                                    'Pengeluaran : ${Utils.formatCurrency(report.dataSummary.transactionOut)}'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TransactionsGrid(),
                ),
              ],
            ),
    );
  }
}
