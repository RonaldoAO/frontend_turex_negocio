import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../models/mission.dart';
import '../services/company_status_listener.dart';
import 'qr_scan_screen.dart';
import '../widgets/pro_map.dart';

class MapMissionScreen extends StatefulWidget {
  final MissionStep step;

  const MapMissionScreen({super.key, required this.step});

  @override
  State<MapMissionScreen> createState() => _MapMissionScreenState();
}

class _MapMissionScreenState extends State<MapMissionScreen> {
  late final Future<List<BusinessLocation>>? _remoteFuture;
  List<BusinessLocation> _businesses = [];
  int? _selectedIndex;
  String _selectionReason = 'Seleccionado por cercania';
  CompanyStatusListener? _listener;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _remoteFuture = widget.step.remoteLoader?.call();
    _loadBusinesses();
  }

  Future<void> _loadBusinesses() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = _remoteFuture == null
          ? widget.step.businesses
          : await _remoteFuture!;
      _businesses = list;
      _pickRandomDefault();
    } catch (_) {
      _error = 'No pudimos cargar los negocios.';
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _pickRandomDefault() {
    if (_businesses.isEmpty) return;
    final random = Random();
    final openIndexes = _businesses
        .asMap()
        .entries
        .where((e) => e.value.status == 'OPEN')
        .map((e) => e.key)
        .toList();
    final index = openIndexes.isNotEmpty
        ? openIndexes[random.nextInt(openIndexes.length)]
        : random.nextInt(_businesses.length);
    _selectBusiness(index, reason: 'Seleccionado por cercania');
  }

  void _selectBusiness(int index, {required String reason}) {
    if (index < 0 || index >= _businesses.length) return;
    _listener?.stop();
    _selectedIndex = index;
    _selectionReason = reason;
    final selected = _businesses[index];
    if (selected.id.isNotEmpty) {
      _listener = CompanyStatusListener(
        companyId: selected.id,
        onChange: (status, _) => _onStatusChange(status.toUpperCase()),
      )..start();
    }
    setState(() {});
  }

  void _onStatusChange(String status) {
    if (_selectedIndex == null) return;
    final idx = _selectedIndex!;
    if (idx >= _businesses.length) return;
    final nextStatus = status.toUpperCase();
    _businesses[idx] = BusinessLocation(
      id: _businesses[idx].id,
      name: _businesses[idx].name,
      lat: _businesses[idx].lat,
      lng: _businesses[idx].lng,
      status: nextStatus,
    );
    if (nextStatus == 'CLOSED') {
      _showClosedDialog();
    } else {
      setState(() {});
    }
  }

  Future<void> _showClosedDialog() async {
    if (!mounted) return;
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Negocio cerrado',
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, _, __) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info, color: Color(0xFF2E63F6), size: 32),
                  const SizedBox(height: 10),
                  Text(
                    'Negocio cerrado',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E2430),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Este negocio cerró. Seleccionaremos otro disponible.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6C7486),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E2430),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Entendido',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondary, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
    _selectNextOpen();
  }

  void _selectNextOpen() {
    final openIndex = _businesses.indexWhere((b) => b.status == 'OPEN');
    if (openIndex == -1) {
      setState(() => _selectedIndex = null);
      return;
    }
    _selectBusiness(openIndex, reason: 'Actualizado por disponibilidad');
  }

  @override
  void dispose() {
    _listener?.stop();
    super.dispose();
  }

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

  void _openSelection(BuildContext context) {
    if (_businesses.isEmpty) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          itemCount: _businesses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final b = _businesses[index];
            return ListTile(
              tileColor: const Color(0xFFF5F7FB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              title: Text(
                b.name,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                b.status,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color:
                      b.status == 'OPEN' ? const Color(0xFF1E8E5A) : Colors.red,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pop();
                _selectBusiness(index, reason: 'Seleccionado por ti');
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(17.0602, -96.7253);
    final bounds = LatLngBounds(
      LatLng(17.0402, -96.7453),
      LatLng(17.0802, -96.7053),
    );

    Widget buildMap(List<BusinessLocation> businesses) {
      final markers = businesses
          .asMap()
          .entries
          .map(
            (entry) => Marker(
              point: LatLng(entry.value.lat, entry.value.lng),
              width: 48,
              height: 48,
              child: ProMapMarker(
                isSelected: entry.key == _selectedIndex,
                isClosed: entry.value.status == 'CLOSED',
              ),
            ),
          )
          .toList();

      return FlutterMap(
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
      );
    }

    final step = widget.step;
    final selected =
        _selectedIndex == null ? null : _businesses[_selectedIndex!];

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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Text(
                          _error!,
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : buildMap(_businesses.isEmpty ? step.businesses : _businesses),
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
                const SizedBox(height: 8),
                if (selected != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE0E4EC)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.place,
                          color: Color(0xFF2E63F6),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selected.name,
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1E2430),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _selectionReason,
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6C7486),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: selected.status == 'OPEN'
                                ? const Color(0xFFE3F6ED)
                                : const Color(0xFFFFE7E7),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            selected.status,
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: selected.status == 'OPEN'
                                  ? const Color(0xFF1E8E5A)
                                  : const Color(0xFFC0342D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => _openSelection(context),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2E63F6),
                    textStyle: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Prefiero seleccionar otro'),
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
                      'Escanear QR o codigopara completar',
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
