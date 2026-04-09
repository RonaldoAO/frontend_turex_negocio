import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../models/company.dart';
import '../screens/company_detail_screen.dart';
import '../services/companies_service.dart';
import '../widgets/pro_map.dart';

class CompanyIndustryScreen extends StatefulWidget {
  final Industry industry;

  const CompanyIndustryScreen({super.key, required this.industry});

  @override
  State<CompanyIndustryScreen> createState() => _CompanyIndustryScreenState();
}

class _CompanyIndustryScreenState extends State<CompanyIndustryScreen> {
  bool _loading = true;
  String? _error;
  List<Company> _companies = [];

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _companies = await fetchCompaniesByIndustry(widget.industry.slug);
    } catch (_) {
      _error = 'No pudimos cargar los negocios.';
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _openDetail(Company company) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompanyDetailScreen(company: company),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final center = const LatLng(17.0602, -96.7253);
    final bounds = LatLngBounds(
      const LatLng(17.0402, -96.7453),
      const LatLng(17.0802, -96.7053),
    );
    final markers = _companies
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
          widget.industry.name,
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E2430),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text(
                    _error!,
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6C7486),
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 260,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: center,
                          initialZoom: 14.8,
                          minZoom: 13,
                          maxZoom: 18,
                          cameraConstraint:
                              CameraConstraint.contain(bounds: bounds),
                        ),
                        children: [
                          buildProTileLayer(),
                          MarkerLayer(markers: markers),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        itemCount: _companies.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final company = _companies[index];
                          return InkWell(
                            onTap: () => _openDetail(company),
                            borderRadius: BorderRadius.circular(16),
                            child: Ink(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F7FB),
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: const Color(0xFFE0E4EC)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.storefront,
                                      color: Color(0xFF2E63F6),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          company.name,
                                          style: GoogleFonts.manrope(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF1E2430),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          company.locationText,
                                          style: GoogleFonts.manrope(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF6C7486),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFF3A4B66),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
