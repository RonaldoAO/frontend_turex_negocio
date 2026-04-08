import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocalFeedItem {
  final String title;
  final String subtitle;
  final Color color;

  const LocalFeedItem({
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class LocalFeedTile extends StatelessWidget {
  final LocalFeedItem item;
  const LocalFeedTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(18),
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
              Icons.place_outlined,
              color: Color(0xFF3A4B66),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E2430),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
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
    );
  }
}
