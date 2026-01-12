// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';

import '../profile/profile_screen.dart';
import 'volume_summary_screen.dart';
import '../transactions/transaction_list_screen.dart';
import '../charts/region_bar_chart_screen.dart';
import '../charts/company_bar_chart_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // 대시보드 진입 시 거래데이터가 없으면 한 번만 불러와 차트에 노출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tx = context.read<TransactionProvider>();
      if (tx.transactions.isEmpty && !tx.isLoading) {
        tx.fetchTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("대시보드 (${user?.username ?? ''})"),
        actions: [
          // 👤 내 정보 (로그아웃 왼쪽)
          IconButton(
            tooltip: '내 정보',
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          // 🚪 로그아웃 (오른쪽 끝)
          IconButton(
            tooltip: '로그아웃',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ▲ 버튼 2x2 그리드
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _DashButton(
                  icon: Icons.bar_chart,
                  label: '물동량 현황 요약',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VolumeSummaryScreen()),
                    );
                  },
                ),
                _DashButton(
                  icon: Icons.receipt_long,
                  label: '거래 내역 조회',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TransactionListScreen()),
                    );
                  },
                ),
                _DashButton(
                  icon: Icons.map_outlined,
                  label: '지역별 입출량 비교',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegionBarChartScreen()),
                    );
                  },
                ),
                _DashButton(
                  icon: Icons.apartment,
                  label: '업체별 거래량 비교',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CompanyBarChartScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ▼ 대시보드 인라인 파이 차트(품목별/거래처별)
            const _InlineSummaryPies(),
          ],
        ),
      ),
    );
  }
}

/// 대시보드 버튼 공통 위젯
class _DashButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 대시보드 인라인 파이차트 카드 (품목별 / 거래처별)
class _InlineSummaryPies extends StatelessWidget {
  const _InlineSummaryPies();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    final isLoading = provider.isLoading;
    final list = provider.transactions;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardTitle(context, '전체 비율 요약'),
            const SizedBox(height: 8),
            if (isLoading)
              const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (list.isEmpty)
              SizedBox(
                height: 220,
                child: Center(
                  child: Text(
                    '데이터가 없습니다.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(.6),
                    ),
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (ctx, c) {
                  final isNarrow = c.maxWidth < 420;
                  return isNarrow
                      ? Column(
                    children: [
                      _PieBlock(
                        title: '품목별 비율',
                        data: _sumBy(list, (t) => t.scrapType),
                      ),
                      const SizedBox(height: 14),
                      _PieBlock(
                        title: '거래처별 비율',
                        data: _sumBy(list, (t) => t.buyerName),
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      Expanded(
                        child: _PieBlock(
                          title: '품목별 비율',
                          data: _sumBy(list, (t) => t.scrapType),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PieBlock(
                          title: '거래처별 비율',
                          data: _sumBy(list, (t) => t.buyerName),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _cardTitle(BuildContext context, String text) {
    return Row(
      children: [
        Icon(Icons.pie_chart, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  /// keySelector로 묶어 totalAmount 합산
  Map<String, double> _sumBy(
      List transactions,
      String Function(dynamic) keySelector,
      ) {
    final Map<String, double> map = {};
    for (final t in transactions) {
      final key = (keySelector(t)).trim().isEmpty ? '기타' : keySelector(t);
      map[key] = (map[key] ?? 0) + (t.totalAmount);
    }
    // 상위 6개 + 기타로 축약
    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (entries.length <= 6) {
      return Map.fromEntries(entries);
    }
    final top = entries.take(5).toList();
    final rest = entries.skip(5).fold<double>(0, (p, e) => p + e.value);
    return {
      for (final e in top) e.key: e.value,
      '기타': rest,
    };
  }
}

/// 개별 파이 차트 블럭
class _PieBlock extends StatelessWidget {
  final String title;
  final Map<String, double> data;

  const _PieBlock({
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<double>(0, (p, c) => p + c);
    final palette = _palette(context);

    final sections = <PieChartSectionData>[];
    final labels = data.keys.toList();
    for (var i = 0; i < labels.length; i++) {
      final k = labels[i];
      final v = data[k] ?? 0;
      final pct = total == 0 ? 0 : (v / total * 100);
      sections.add(
        PieChartSectionData(
          color: palette[i % palette.length],
          value: v,
          radius: 48,
          title: total == 0 ? '' : '${pct.toStringAsFixed(0)}%',
          titleStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            )),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    sectionsSpace: 2,
                    centerSpaceRadius: 26,
                    startDegreeOffset: -90,
                    borderData: FlBorderData(show: false),
                    // 간단한 터치 효과(범례 대신)
                    pieTouchData: PieTouchData(enabled: true),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _Legend(data: data, colors: palette),
            ],
          ),
        ),
      ],
    );
  }

  List<Color> _palette(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final alt = Colors.blueGrey;
    return [
      primary,
      Colors.indigo,
      Colors.blueAccent,
      Colors.lightBlue,
      alt.shade400,
      alt.shade200,
      Colors.teal,
      Colors.cyan,
    ];
  }
}

/// 간단한 범례
class _Legend extends StatelessWidget {
  final Map<String, double> data;
  final List<Color> colors;

  const _Legend({required this.data, required this.colors});

  @override
  Widget build(BuildContext context) {
    final labels = data.keys.toList();
    final total = data.values.fold<double>(0, (p, c) => p + c);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < labels.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _truncate(labels[i], 14),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    total == 0
                        ? '-'
                        : '${(data[labels[i]]! / total * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.7),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _truncate(String s, int max) =>
      s.length <= max ? s : '${s.substring(0, max)}…';
}
