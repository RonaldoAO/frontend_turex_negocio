import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/company.dart';
import '../screens/company_industry_screen.dart';
import '../services/companies_service.dart';

class AgendaSection extends StatefulWidget {
  const AgendaSection({super.key});

  @override
  State<AgendaSection> createState() => _AgendaSectionState();
}

class _AgendaSectionState extends State<AgendaSection> {
  List<Industry> _industries = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadIndustries();
  }

  Future<void> _loadIndustries() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await fetchOpenIndustries();
      _industries = list;
    } catch (e) {
      _error = 'No pudimos cargar los giros.';
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _industries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Text(
          _error!,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6C7486),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _industries.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = _industries[index];
                return ActionChip(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CompanyIndustryScreen(industry: item),
                      ),
                    );
                  },
                  label: Text(
                    item.name,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  backgroundColor: const Color(0xFFF2F5FA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Selecciona un giro para ver negocios cercanos.',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6C7486),
            ),
          ),
        ],
      ),
    );
  }
}
