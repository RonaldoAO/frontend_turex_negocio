import 'dart:math';

import 'package:flutter/material.dart';

class MissionTip {
  final String title;
  final String fact;
  final String meaning;

  const MissionTip({
    required this.title,
    required this.fact,
    required this.meaning,
  });
}

class MissionTipsController {
  static final ValueNotifier<MissionTip?> current = ValueNotifier(null);
  static List<MissionTip> _tips = const [];
  static final Random _random = Random();
  static final ValueNotifier<bool> petVisible = ValueNotifier(true);

  static void setTips(List<MissionTip> tips, {int index = 0}) {
    _tips = tips;
    showTip(index);
  }

  static void showTip(int index) {
    if (index < 0 || index >= _tips.length) return;
    current.value = _tips[index];
  }

  static void showRandom() {
    if (_tips.isEmpty) return;
    final next = _random.nextInt(_tips.length);
    current.value = _tips[next];
  }

  static void clear() {
    current.value = null;
    _tips = const [];
  }

  static void setPetVisible(bool visible) {
    petVisible.value = visible;
  }
}
