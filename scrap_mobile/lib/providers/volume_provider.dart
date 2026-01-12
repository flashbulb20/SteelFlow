// lib/providers/volume_provider.dart
import 'package:flutter/foundation.dart';
import '../models/volume_model.dart';
import '../services/volume_service.dart';

class VolumeProvider extends ChangeNotifier {
  VolumeSummary? summary;
  List<VolumeTimeSeries> timeSeries = [];

  bool isLoading = false;
  String? errorMessage;

  Future<void> refreshAll({String period = 'daily'}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final s = await VolumeService.fetchVolumeSummary();
      final ts = await VolumeService.fetchTimeSeries(period: period);
      summary = s;
      timeSeries = ts;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTimeSeries({String period = 'daily'}) async {
    try {
      isLoading = true;
      notifyListeners();
      final ts = await VolumeService.fetchTimeSeries(period: period);
      timeSeries = ts;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
