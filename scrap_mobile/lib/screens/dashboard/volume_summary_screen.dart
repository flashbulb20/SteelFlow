// lib/screens/dashboard/volume_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../providers/volume_provider.dart';

class VolumeSummaryScreen extends StatefulWidget {
  const VolumeSummaryScreen({Key? key}) : super(key: key);

  @override
  State<VolumeSummaryScreen> createState() => _VolumeSummaryScreenState();
}

class _VolumeSummaryScreenState extends State<VolumeSummaryScreen> {
  String _selectedPeriod = 'daily';

  @override
  void initState() {
    super.initState();
    // 화면 진입시 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VolumeProvider>(context, listen: false).refreshAll(period: _selectedPeriod);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VolumeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 물동량 현황 요약'),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.refreshAll(period: _selectedPeriod),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : (provider.errorMessage != null)
            ? ListView(
          children: [
            const SizedBox(height: 80),
            Center(child: Text('오류: ${provider.errorMessage}')),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () => provider.refreshAll(period: _selectedPeriod),
                child: const Text('다시 시도'),
              ),
            ),
          ],
        )
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSummaryCard(provider),
            const SizedBox(height: 20),
            _buildPeriodSelector(),
            const SizedBox(height: 10),
            _buildChart(provider),
          ],
        ),
      ),
    );
  }

  /// 요약 카드
  Widget _buildSummaryCard(VolumeProvider provider) {
    final summary = provider.summary;
    if (summary == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('요약 데이터가 없습니다.')),
        ),
      );
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('요약 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _kv('입고량', summary.inbound, Colors.green),
                _kv('출고량', summary.outbound, Colors.red),
                _kv('총합', summary.total, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, double v, Color color) {
    return Column(
      children: [
        Text(k, style: TextStyle(color: Colors.grey[700])),
        const SizedBox(height: 6),
        Text(
          NumberFormat('#,##0.0').format(v),
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  /// 기간 선택
  Widget _buildPeriodSelector() {
    final items = const [
      {'key': 'daily', 'label': '일별'},
      {'key': 'weekly', 'label': '주별'},
      {'key': 'monthly', 'label': '월별'},
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: items.map((it) {
        final key = it['key'] as String;
        final label = it['label'] as String;
        final isSelected = _selectedPeriod == key;
        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) {
            setState(() => _selectedPeriod = key);
            Provider.of<VolumeProvider>(context, listen: false).loadTimeSeries(period: key);
          },
        );
      }).toList(),
    );
  }

  /// 시계열 차트
  Widget _buildChart(VolumeProvider provider) {
    final data = provider.timeSeries;
    if (data.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text('시계열 데이터가 없습니다.')),
        ),
      );
    }

    final inboundSpots = <FlSpot>[];
    final outboundSpots = <FlSpot>[];

    for (int i = 0; i < data.length; i++) {
      inboundSpots.add(FlSpot(i.toDouble(), data[i].inbound));
      outboundSpots.add(FlSpot(i.toDouble(), data[i].outbound));
    }

    final maxY = [
      ...inboundSpots.map((e) => e.y),
      ...outboundSpots.map((e) => e.y),
    ].fold<double>(0.0, (p, c) => c > p ? c : p);
    final intervalY = (maxY / 5).clamp(1, 100).toDouble();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('입고(파랑) / 출고(빨강) 추세', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 1.8,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (data.length / 6).clamp(1, 10).toDouble(),
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                          final label = data[idx].periodStart;
                          return Text(label.substring(5)); // MM-DD
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: intervalY,
                        getTitlesWidget: (v, m) => Text(v.toStringAsFixed(0)),
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: inboundSpots,
                      isCurved: true,
                      color: Colors.blueAccent,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: true, color: Colors.blueAccent.withOpacity(0.15)),
                    ),
                    LineChartBarData(
                      spots: outboundSpots,
                      isCurved: true,
                      color: Colors.redAccent,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: true, color: Colors.redAccent.withOpacity(0.10)),
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
