import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart';

class RegionBarChartScreen extends StatefulWidget {
  const RegionBarChartScreen({super.key});

  @override
  State<RegionBarChartScreen> createState() => _RegionBarChartScreenState();
}

class _RegionBarChartScreenState extends State<RegionBarChartScreen> {
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

  /// ✅ sellerId로 간단한 지역 매핑 (프론트 전용)
  String _regionFromSellerId(int? sellerId) {
    if (sellerId == null) return '기타';
    switch (sellerId % 4) {
      case 0:
        return '서울';
      case 1:
        return '부산';
      case 2:
        return '인천';
      default:
        return '기타';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<TransactionProvider>();
    final list = tp.transactions;

    final Map<String, double> inbound = {};
    final Map<String, double> outbound = {};

    for (final tx in list) {
      final region = _regionFromSellerId(tx.sellerId);
      final amount = tx.quantity;
      final isInbound = tx.tradeType == '입고';
      if (isInbound) {
        inbound[region] = (inbound[region] ?? 0) + amount;
      } else {
        outbound[region] = (outbound[region] ?? 0) + amount;
      }
    }

    final regions = {...inbound.keys, ...outbound.keys}.toList()..sort();

    if (regions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('지역별 입출량 비교')),
        body: const Center(child: Text('데이터가 없습니다.')),
      );
    }

    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < regions.length; i++) {
      final r = regions[i];
      final inVal = inbound[r] ?? 0;
      final outVal = outbound[r] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: inVal, color: Colors.blueAccent, width: 10),
            BarChartRodData(toY: outVal, color: Colors.redAccent, width: 10),
          ],
          barsSpace: 6,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('지역별 입출량 비교')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            barGroups: barGroups,
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= regions.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(regions[idx]),
                    );
                  },
                ),
              ),
            ),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true),
          ),
        ),
      ),
    );
  }
}
