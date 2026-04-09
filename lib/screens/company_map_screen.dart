import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../models/company.dart';
import '../widgets/pro_map.dart';

class CompanyMapScreen extends StatelessWidget {
  final String title;
  final List<Company> companies;

  const CompanyMapScreen({
    super.key,
    required this.title,
    required this.companies,
  });

  @override
  Widget build(BuildContext context) {
    final center = const LatLng(17.0602, -96.7253);
    final bounds = LatLngBounds(
      const LatLng(17.0402, -96.7453),
      const LatLng(17.0802, -96.7053),
    );

    final markers = companies
        .map(
          (c) => Marker(
            point: LatLng(c.lat, c.lng),
            width: 42,
            height: 42,
            child: const ProMapMarker(),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E2430),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 14.8,
          minZoom: 13,
          maxZoom: 18,
          cameraConstraint: CameraConstraint.contain(bounds: bounds),
        ),
        children: [
          buildProTileLayer(),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}
