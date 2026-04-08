import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../models/mission.dart';
import 'qr_scan_screen.dart';

class MapMissionScreen extends StatelessWidget {
  final MissionStep step;

  const MapMissionScreen({super.key, required this.step});

  Future<void> _openScanner(BuildContext context) async {
    final scanned = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const QrScanScreen(),
      ),
    );
    if (scanned == true && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(17.0602, -96.7253);
    final markers = step.businesses
        .map(
          (b) => Marker(
            point: LatLng(b.lat, b.lng),
            width: 42,
            height: 42,
            child: const Icon(
              Icons.location_on,
              color: Color(0xFF2E63F6),
              size: 36,
            ),
          ),
        )
        .toList();

    final bounds = LatLngBounds(
      LatLng(17.0402, -96.7453),
      LatLng(17.0802, -96.7053),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          step.subtitle,
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E2430),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 14.8,
                minZoom: 13,
                maxZoom: 18,
                cameraConstraint: CameraConstraint.contain(bounds: bounds),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.talent2026.app',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Negocios sugeridos en el centro de Oaxaca',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E2430),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: step.businesses.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final b = step.businesses[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F5FA),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          b.name,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF344055),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openScanner(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2430),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Escanear QR para completar',
                      style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
