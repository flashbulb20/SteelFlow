// lib/screens/transactions/transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap_mobile/providers/transaction_provider.dart';
import 'package:scrap_mobile/models/transaction_model.dart';
import 'package:scrap_mobile/screens/transactions/transaction_detail_screen.dart';
import 'package:scrap_mobile/screens/transactions/transaction_chart_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TransactionProvider>(context, listen: false);
      provider.fetchTransactions();
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatNum(num n) {
    final f = NumberFormat('#,##0.##');
    return f.format(n);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('거래 내역 조회'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.transactions.isEmpty
          ? const Center(child: Text('거래 내역이 없습니다.'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: provider.transactions.length,
        itemBuilder: (context, index) {
          final tx = provider.transactions[index];
          final total = tx.quantity * tx.price;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              debugPrint("✅ [CLICK] 거래 항목 클릭됨: id=${tx.id}");
              try {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (ctx) {
                      debugPrint(
                          "➡️ [NAVIGATE] TransactionDetailScreen 진입 시도");
                      return TransactionDetailScreen(transaction: tx);
                    },
                  ),
                );
                debugPrint("🚀 [SUCCESS] Navigator.push 호출 완료");
              } catch (e) {
                debugPrint("❌ [ERROR] Navigator.push 실패: $e");
              }
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  tx.scrapType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '계약일: ${_formatDate(tx.contractDate)}\n'
                      '수량: ${_formatNum(tx.quantity)} / 단가: ${_formatNum(tx.price)}원',
                  style: const TextStyle(height: 1.4),
                ),
                trailing: Text(
                  '${_formatNum(total)} 원',
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.show_chart),
        label: const Text("월별 거래금액 그래프"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TransactionChartScreen()),
          );
        },
      ),
    );
  }
}
