import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

/// 거래 정렬 옵션 열거형
enum TransactionSortBy {
  dateAsc,
  dateDesc,
  amountAsc,
  amountDesc,
  quantityAsc,
  quantityDesc,
}

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _transactions = []; // 빨간줄 사라짐
  bool _isLoading = false;
  String? _error;

  String _keyword = '';
  String? _status;
  DateTime? _fromDate;
  DateTime? _toDate;
  TransactionSortBy _sortBy = TransactionSortBy.dateDesc;

  // 공개 getters
  List<TransactionModel> get transactions => _filteredAndSortedTransactions();
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get keyword => _keyword;
  String? get status => _status;
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  TransactionSortBy get sortBy => _sortBy;

  Future<void> fetchTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await TransactionService.fetchTransactions();
      _transactions = data;
    } catch (e) {
      _error = e.toString();
      _transactions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setKeyword(String value) {
    _keyword = value;
    notifyListeners();
  }

  void setStatus(String? value) {
    _status = value;
    notifyListeners();
  }

  void setDateRange(DateTime? from, DateTime? to) {
    _fromDate = from;
    _toDate = to;
    notifyListeners();
  }

  void setSort(TransactionSortBy value) {
    _sortBy = value;
    notifyListeners();
  }

  void clearFilters() {
    _keyword = '';
    _status = null;
    _fromDate = null;
    _toDate = null;
    _sortBy = TransactionSortBy.dateDesc;
    notifyListeners();
  }

  List<String> get uniqueStatuses {
    if (_transactions.isEmpty) return [];
    final statuses = _transactions
        .map((t) => t.contractStatus ?? "미지정")
        .toSet()
        .toList();
    statuses.sort();
    return statuses;
  }

  String tradeType(TransactionModel transaction) {
    final status = transaction.contractStatus?.toLowerCase() ?? '';
    if (status.contains("입고")) return "입고";
    if (status.contains("출고")) return "출고";
    return "기타";
  }

  List<Map<String, dynamic>> get regionSummary {
    final Map<String, Map<String, double>> summary = {};
    for (var tx in _transactions) {
      final dynamicTx = tx as dynamic;
      String region;
      try {
        region = (dynamicTx.region as String?) ?? "미지정";
      } catch (_) {
        region = "미지정";
      }
      final type = tradeType(tx);
      summary.putIfAbsent(region, () => {"입고": 0, "출고": 0});
      if (type == "입고") {
        summary[region]!["입고"] = summary[region]!["입고"]! + tx.quantity;
      } else if (type == "출고") {
        summary[region]!["출고"] = summary[region]!["출고"]! + tx.quantity;
      }
    }
    return summary.entries
        .map((e) => {
      "region": e.key,
      "in": e.value["입고"] ?? 0,
      "out": e.value["출고"] ?? 0,
    })
        .toList();
  }

  List<Map<String, dynamic>> get companySummary {
    final Map<String, double> summary = {};
    for (var tx in _transactions) {
      final company = tx.buyerName ?? "미지정";
      summary[company] = (summary[company] ?? 0) + tx.quantity;
    }
    return summary.entries
        .map((e) => {"company": e.key, "value": e.value})
        .toList();
  }

  List<Map<String, dynamic>> get overallRatio {
    double totalIn = 0;
    double totalOut = 0;
    for (var tx in _transactions) {
      final type = tradeType(tx);
      if (type == "입고") totalIn += tx.quantity;
      if (type == "출고") totalOut += tx.quantity;
    }
    return [
      {"label": "입고", "value": totalIn, "color": Colors.green},
      {"label": "출고", "value": totalOut, "color": Colors.redAccent},
      {"label": "기타", "value": 0.0, "color": Colors.orange},
    ];
  }

  List<TransactionModel> _filteredAndSortedTransactions() {
    var filtered = _transactions;
    if (_keyword.isNotEmpty) {
      filtered = filtered.where((t) {
        final target =
            "${t.scrapType ?? ''}${t.buyerName ?? ''}${t.contractStatus ?? ''}";
        return target.contains(_keyword);
      }).toList();
    }
    if (_status != null && _status!.isNotEmpty) {
      filtered =
          filtered.where((t) => t.contractStatus == _status).toList();
    }
    if (_fromDate != null) {
      filtered =
          filtered.where((t) => t.contractDate != null && t.contractDate!.isAfter(_fromDate!)).toList();
    }
    if (_toDate != null) {
      filtered =
          filtered.where((t) => t.contractDate != null && t.contractDate!.isBefore(_toDate!)).toList();
    }

    filtered.sort((a, b) {
      switch (_sortBy) {
        case TransactionSortBy.dateAsc:
          return (a.contractDate ?? DateTime(0))
              .compareTo(b.contractDate ?? DateTime(0));
        case TransactionSortBy.dateDesc:
          return (b.contractDate ?? DateTime(0))
              .compareTo(a.contractDate ?? DateTime(0));
        case TransactionSortBy.amountAsc:
          return (a.price * a.quantity)
              .compareTo(b.price * b.quantity);
        case TransactionSortBy.amountDesc:
          return (b.price * b.quantity)
              .compareTo(a.price * a.quantity);
        case TransactionSortBy.quantityAsc:
          return a.quantity.compareTo(b.quantity);
        case TransactionSortBy.quantityDesc:
          return b.quantity.compareTo(a.quantity);
      }
    });

    return filtered;
  }
}
