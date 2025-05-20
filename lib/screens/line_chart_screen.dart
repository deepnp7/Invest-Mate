import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';

class LineChartScreen extends StatelessWidget {
  const LineChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<PortfolioProvider>(context).balanceHistory;

    return Scaffold(
      appBar: AppBar(title: const Text("Portfolio Growth")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: history.isEmpty
            ? const Center(child: Text("No data yet"))
            : LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: history
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
