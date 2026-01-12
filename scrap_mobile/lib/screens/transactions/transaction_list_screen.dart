import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final TextEditingController _keywordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 안전하게 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().fetchTransactions();
    });
  }

  @override
  void dispose() {
    _keywordCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? d) =>
      d == null ? '-' : DateFormat('yyyy-MM-dd').format(d);

  String _formatNum(num n) => NumberFormat('#,##0.##').format(n);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final statuses = ['전체', ...provider.uniqueStatuses];

    return Scaffold(
      appBar: AppBar(title: const Text('거래 내역')),
      body: Column(
        children: [
          // 🔎 필터 영역
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _keywordCtrl,
                        decoration: const InputDecoration(
                          hintText: '거래처/품목 검색',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: provider.setKeyword,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true, // ✅ 오버플로우 방지
                        value: provider.status ?? '전체',
                        items: statuses
                            .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s, overflow: TextOverflow.ellipsis),
                        ))
                            .toList(),
                        onChanged: (v) => provider.setStatus(v == '전체' ? null : v),
                        decoration: const InputDecoration(
                          labelText: '상태',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<TransactionSortBy>(
                        isExpanded: true, // ✅ 오버플로우 방지
                        value: provider.sortBy,
                        items: const [
                          DropdownMenuItem(
                            value: TransactionSortBy.dateDesc,
                            child: Text('날짜 ↓', overflow: TextOverflow.ellipsis),
                          ),
                          DropdownMenuItem(
                            value: TransactionSortBy.dateAsc,
                            child: Text('날짜 ↑', overflow: TextOverflow.ellipsis),
                          ),
                          DropdownMenuItem(
                            value: TransactionSortBy.amountDesc,
                            child: Text('금액 ↓', overflow: TextOverflow.ellipsis),
                          ),
                          DropdownMenuItem(
                            value: TransactionSortBy.amountAsc,
                            child: Text('금액 ↑', overflow: TextOverflow.ellipsis),
                          ),
                          DropdownMenuItem(
                            value: TransactionSortBy.quantityDesc,
                            child: Text('수량 ↓', overflow: TextOverflow.ellipsis),
                          ),
                          DropdownMenuItem(
                            value: TransactionSortBy.quantityAsc,
                            child: Text('수량 ↑', overflow: TextOverflow.ellipsis),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) provider.setSort(v);
                        },
                        decoration: const InputDecoration(
                          labelText: '정렬',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _DatePickerField(
                        label: '시작일',
                        date: provider.fromDate,
                        onPick: (d) => provider.setDateRange(d, provider.toDate),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _DatePickerField(
                        label: '종료일',
                        date: provider.toDate,
                        onPick: (d) => provider.setDateRange(provider.fromDate, d),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // ✅ 가로 영역에 맞춰 축소해서 오버플로우 방지
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: TextButton.icon(
                        onPressed: provider.clearFilters,
                        icon: const Icon(Icons.refresh),
                        label: const Text('초기화'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          // 리스트
          Expanded(
            child: Builder(
              builder: (_) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null) {
                  return Center(child: Text('오류: ${provider.error}'));
                }
                final items = provider.transactions;
                if (items.isEmpty) {
                  return const Center(child: Text('거래 내역이 없습니다.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final tx = items[i];
                    final total = tx.price * tx.quantity;
                    return Card(
                      elevation: 1,
                      child: ListTile(
                        title: Text(tx.scrapType),
                        subtitle: Text(
                          '계약일: ${_formatDate(tx.contractDate)}\n상태: ${tx.contractStatus ?? '-'}',
                        ),
                        trailing: Text(
                          '${_formatNum(total)} 원',
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final ValueChanged<DateTime?> onPick;
  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final txt = date == null ? '' : DateFormat('yyyy-MM-dd').format(date!);
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? now,
          firstDate: DateTime(now.year - 5),
          lastDate: DateTime(now.year + 1),
        );
        onPick(picked);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: '시작/종료일',
          border: OutlineInputBorder(),
          isDense: true,
        ),
        child: Text(txt.isEmpty ? '선택' : txt),
      ),
    );
  }
}
