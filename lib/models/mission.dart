import 'package:flutter/material.dart';

class BusinessLocation {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String status;

  const BusinessLocation({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.status,
  });
}

class MissionStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<BusinessLocation> businesses;
  final Future<List<BusinessLocation>> Function()? remoteLoader;

  const MissionStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.businesses,
    this.remoteLoader,
  });
}
