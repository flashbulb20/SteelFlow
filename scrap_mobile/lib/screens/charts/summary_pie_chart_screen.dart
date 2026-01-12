// lib/screens/charts/summary_pie_chart_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart';

class SummaryPieChartScreen extends StatefulWidget {
  const SummaryPieChartScreen({super.key});

  @override
  State<SummaryPieChartScreen> createState() => _SummaryPieChartScreenState();
}

class _SummaryPieChartScreenState extends State<SummaryPieChartScreen> {
  bool showByBuyer = false; // ✅ 토글 (거래처 기준 / 품목 기준)

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

    if (list.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('전체 비율 원형 차트')),
        body: const Center(child: Text('데이터가 없습니다.')),
      );
    }

    // ✅ 데이터 그룹핑
    final Map<String, double> groupTotals = {};
    for (final tx in list) {
      final key = showByBuyer
          ? (tx.buyerName.isNotEmpty ? tx.buyerName : 'Unknown')
          : (tx.scrapType.isNotEmpty ? tx.scrapType : '기타');
      groupTotals[key] = (groupTotals[key] ?? 0) + tx.totalAmount;
    }

    final totalSum = groupTotals.values.fold(0.0, (a, b) => a + b);
    final colors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
      Colors.pinkAccent
    ];

    final sections = groupTotals.entries
        .toList()
        .asMap()
        .entries
        .map(
          (entry) => PieChartSectionData(
        value: entry.value.value,
        color: colors[entry.key % colors.length],
        title:
        '${entry.value.key}\n${((entry.value.value / totalSum) * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('전체 비율 원형 차트'),
        actions: [
          IconButton(
            icon: Icon(showByBuyer ? Icons.business : Icons.inventory),
            tooltip: showByBuyer ? "품목 기준으로 보기" : "거래처 기준으로 보기",
            onPressed: () {
              setState(() => showByBuyer = !showByBuyer);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PieChart(
          PieChartData(
            sections: sections,
            sectionsSpace: 2,
            centerSpaceRadius: 50,
          ),
        ),
      ),
    );
  }
}
