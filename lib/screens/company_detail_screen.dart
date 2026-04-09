import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/company.dart';

class CompanyDetailScreen extends StatelessWidget {
  final Company company;

  const CompanyDetailScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          company.name,
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E2430),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company.industryName.isEmpty
                  ? 'Giro local'
                  : company.industryName,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E63F6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              company.name,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E2430),
              ),
            ),
            const SizedBox(height: 12),
            _InfoRow(label: 'Ubicacion', value: company.locationText),
            _InfoRow(label: 'Telefono', value: company.phone.isEmpty ? '-' : company.phone),
            _InfoRow(label: 'Status', value: company.status),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2430),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Volver',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF6C7486),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E2430),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
