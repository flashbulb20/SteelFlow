// lib/services/volume_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/volume_model.dart';
import 'api_service.dart';

class VolumeService {
  /// 요약
  static Future<VolumeSummary> fetchVolumeSummary() async {
    final url = Uri.parse(ApiService.endpoint('/volumes/summary'));
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return VolumeSummary.fromJson(jsonDecode(res.body));
    }
    throw Exception('요약 조회 실패: ${res.statusCode} ${res.body}');
  }

  /// 시계열
  static Future<List<VolumeTimeSeries>> fetchTimeSeries({String period = 'daily'}) async {
    final url = Uri.parse(
      ApiService.endpoint('/volumes/summary/timeseries?period=$period'),
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List<dynamic> list = jsonDecode(res.body);
      return list.map((e) => VolumeTimeSeries.fromJson(e)).toList();
    }
    throw Exception('시계열 조회 실패: ${res.statusCode} ${res.body}');
  }
}
