import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

const String _proTileUrl =
    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';
const List<String> _proSubdomains = ['a', 'b', 'c', 'd'];

TileLayer buildProTileLayer({String userAgentPackageName = 'com.talent2026.app'}) {
  return TileLayer(
    urlTemplate: _proTileUrl,
    subdomains: _proSubdomains,
    userAgentPackageName: userAgentPackageName,
  );
}

class ProMapMarker extends StatelessWidget {
  final bool isSelected;
  final bool isClosed;
  final Color color;
  final IconData icon;

  const ProMapMarker({
    super.key,
    this.isSelected = false,
    this.isClosed = false,
    this.color = const Color(0xFF2E63F6),
    this.icon = Icons.storefront,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = isClosed ? const Color(0xFFC0342D) : color;
    final Color shade = Color.lerp(baseColor, Colors.black, 0.25) ?? baseColor;
    final double size = isSelected ? 48 : 40;
    final double inner = isSelected ? 34 : 28;
    final double iconSize = isSelected ? 20 : 18;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
                if (isSelected)
                  BoxShadow(
                    color: baseColor.withOpacity(0.35),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
              ],
            ),
          ),
          Container(
            width: inner,
            height: inner,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [baseColor, shade],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ],
      ),
    );
  }
}
