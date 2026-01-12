// lib/models/volume_model.dart

/// 물동량 요약 모델
class VolumeSummary {
  final double inbound;
  final double outbound;
  final double total;

  VolumeSummary({
    required this.inbound,
    required this.outbound,
    required this.total,
  });

  factory VolumeSummary.fromJson(Map<String, dynamic> json) {
    // 백엔드가 숫자를 문자열/Decimal로 줄 수도 있으므로 double 변환 방어
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }
    return VolumeSummary(
      inbound: _toDouble(json['inbound']),
      outbound: _toDouble(json['outbound']),
      total: _toDouble(json['total']),
    );
  }
}

/// 시계열 데이터 모델
class VolumeTimeSeries {
  final String periodStart; // 'YYYY-MM-DD'
  final double inbound;
  final double outbound;

  VolumeTimeSeries({
    required this.periodStart,
    required this.inbound,
    required this.outbound,
  });

  factory VolumeTimeSeries.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }
    return VolumeTimeSeries(
      periodStart: (json['period_start'] ?? '').toString(),
      inbound: _toDouble(json['inbound']),
      outbound: _toDouble(json['outbound']),
    );
  }
}
