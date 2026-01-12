// lib/screens/transactions/transaction_chart_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart';

class TransactionChartScreen extends StatelessWidget {
  const TransactionChartScreen({super.key});

  Map<String, double> _calculateMonthlyTotals(List<TransactionModel> txs) {
    final Map<String, double> monthlyTotals = {};
    for (var tx in txs) {
      if (tx.contractDate == null) continue;
      final monthKey = DateFormat('yyyy-MM').format(tx.contractDate!);
      final total = tx.quantity * tx.price;
      monthlyTotals[monthKey] =
          (monthlyTotals[monthKey] ?? 0) + total.toDouble();
    }
    return monthlyTotals;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final txs = provider.transactions;

    if (txs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("월별 거래금액 추이")),
        body: const Center(child: Text("거래 내역이 없습니다.")),
      );
    }

    final monthlyTotals = _calculateMonthlyTotals(txs);
    final months = monthlyTotals.keys.toList()..sort();
    final spots = List.generate(
      months.length,
          (i) => FlSpot(i.toDouble(), monthlyTotals[months[i]]! / 1000000),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("월별 거래금액 추이"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📊 월별 거래 금액 (단위: 백만원)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < months.length) {
                            return Text(months[index].substring(5),
                                style: const TextStyle(fontSize: 10));
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true, interval: 50, reservedSize: 40),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blueAccent.withOpacity(0.3)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
