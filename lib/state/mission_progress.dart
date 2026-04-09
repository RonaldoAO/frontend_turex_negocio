import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MissionProgress {
  final bool started;
  final int currentIndex;
  final int completedCount;

  const MissionProgress({
    required this.started,
    required this.currentIndex,
    required this.completedCount,
  });

  MissionProgress copyWith({
    bool? started,
    int? currentIndex,
    int? completedCount,
  }) {
    return MissionProgress(
      started: started ?? this.started,
      currentIndex: currentIndex ?? this.currentIndex,
      completedCount: completedCount ?? this.completedCount,
    );
  }
}

class MissionProgressController {
  static final ValueNotifier<MissionProgress> current =
      ValueNotifier(const MissionProgress(started: false, currentIndex: 0, completedCount: 0));
  static const _keyStarted = 'mission_started';
  static const _keyCurrent = 'mission_current_index';
  static const _keyCompleted = 'mission_completed_count';

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final started = prefs.getBool(_keyStarted) ?? false;
    final currentIndex = prefs.getInt(_keyCurrent) ?? 0;
    final completedCount = prefs.getInt(_keyCompleted) ?? 0;
    current.value = MissionProgress(
      started: started,
      currentIndex: currentIndex,
      completedCount: completedCount,
    );
  }

  static void markStarted() {
    final value = current.value;
    if (value.started) return;
    current.value = value.copyWith(started: true);
    _persist(current.value);
  }

  static void updateProgress({
    required int currentIndex,
    required int completedCount,
  }) {
    final value = current.value;
    current.value = value.copyWith(
      started: true,
      currentIndex: currentIndex,
      completedCount: completedCount,
    );
    _persist(current.value);
  }

  static Future<void> _persist(MissionProgress value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyStarted, value.started);
    await prefs.setInt(_keyCurrent, value.currentIndex);
    await prefs.setInt(_keyCompleted, value.completedCount);
  }
}
