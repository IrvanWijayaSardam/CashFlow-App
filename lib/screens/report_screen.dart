import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../providers/auth.dart';
import '../providers/reports.dart';
import 'package:cashflow/widgets/app_drawer.dart';

class ReportScreen extends StatefulWidget {
  static const routeName = '/user-reports';

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var _isInit = true;
  Future<void> _refreshReport(BuildContext context) async {
    await Provider.of<Reports>(context, listen: false).fetchAndSetReports();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _refreshReport(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final trxData = Provider.of<Reports>(context);

    // Prepare the data for the pie chart
// Prepare the data for the pie chart
    Map<String, double> chartData = {};
    for (var item in trxData.items) {
      if (item.transactionGroup == "1") {
        chartData["Makanan / Minuman"] = item.total_transaction.toDouble();
      } else if (item.transactionGroup == "2") {
        chartData["Transportasi"] = item.total_transaction.toDouble();
      } else if (item.transactionGroup == "3") {
        chartData["Tempat Tinggal"] = item.total_transaction.toDouble();
      } else if (item.transactionGroup == "4") {
        chartData["Belanja"] = item.total_transaction.toDouble();
      } else if (item.transactionGroup == "5") {
        chartData["Tagihan"] = item.total_transaction.toDouble();
      } else if (item.transactionGroup == "6") {
        chartData["Pendidikan"] = item.total_transaction.toDouble();
      }
    }

    if (chartData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Laporan Transaksi'),
        ),
        drawer: Consumer<Auth>(
          builder: (ctx, auth, _) => AppDrawer(
            drawerTitle: auth.name ?? '',
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Transaksi'),
      ),
      drawer: Consumer<Auth>(
        builder: (ctx, auth, _) => AppDrawer(
          drawerTitle: auth.name ?? '',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshReport(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              // Display the pie chart
              PieChart(
                dataMap: chartData,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 1.5,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                centerText: "Transaksi",
                legendOptions: LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
