import 'package:flutter/material.dart';

class BusinessLocation {
  final String name;
  final double lat;
  final double lng;

  const BusinessLocation({
    required this.name,
    required this.lat,
    required this.lng,
  });
}

class MissionStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<BusinessLocation> businesses;

  const MissionStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.businesses,
  });
}
