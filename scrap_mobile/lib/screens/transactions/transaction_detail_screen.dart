// lib/screens/transactions/transaction_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

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
    final total = transaction.quantity * transaction.price;

    return Scaffold(
      appBar: AppBar(
        title: const Text("거래 상세 내역"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.scrapType,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text("계약일: ${_formatDate(transaction.contractDate)}"),
                Text("거래 상태: ${transaction.contractStatus}"),
                Text("수량: ${_formatNum(transaction.quantity)}"),
                Text("단가: ${_formatNum(transaction.price)} 원"),
                const Divider(height: 30),
                Text(
                  "총 거래 금액: ${_formatNum(total)} 원",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
