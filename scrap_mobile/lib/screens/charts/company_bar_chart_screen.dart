import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart';

class CompanyBarChartScreen extends StatefulWidget {
  const CompanyBarChartScreen({super.key});

  @override
  State<CompanyBarChartScreen> createState() => _CompanyBarChartScreenState();
}

class _CompanyBarChartScreenState extends State<CompanyBarChartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tp = context.read<TransactionProvider>();
      if (!tp.isLoading && tp.transactions.isEmpty) {
        tp.fetchTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<TransactionProvider>();
    final list = tp.transactions;

    /// ✅ 거래처 이름(buyerName) 기준으로 거래금액 합산
    final Map<String, double> byCompanyAmount = {};
    for (final tx in list) {
      final company = tx.buyerName.isNotEmpty ? tx.buyerName : 'Unknown';
      final amount = tx.totalAmount;
      byCompanyAmount[company] = (byCompanyAmount[company] ?? 0) + amount;
    }

    if (byCompanyAmount.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('업체별 거래액 비교')),
        body: const Center(child: Text('데이터가 없습니다.')),
      );
    }

    final companies = byCompanyAmount.keys.toList()
      ..sort((a, b) => (byCompanyAmount[b] ?? 0).compareTo(byCompanyAmount[a] ?? 0));

    final top = companies.take(10).toList();
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < top.length; i++) {
      final name = top[i];
      final val = byCompanyAmount[name]!;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: val,
              color: Colors.indigoAccent,
              width: 14,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('업체별 거래액 비교')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            barGroups: barGroups,
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, m) {
                    final i = v.toInt();
                    if (i < 0 || i >= top.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        top[i],
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
