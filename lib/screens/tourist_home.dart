import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/cards_header.dart';
import '../widgets/local_feed.dart';
import 'route_mission_screen.dart';

class TouristHome extends StatefulWidget {
  const TouristHome({super.key});

  @override
  State<TouristHome> createState() => _TouristHomeState();
}

class _TouristHomeState extends State<TouristHome> {
  late final PageController _controller;
  String _locationLabel = 'Ubicacion no disponible';
  bool _locationDenied = false;
  bool _locationLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.86);
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationLabel = 'Activa ubicacion';
          _locationDenied = true;
          _locationLoading = false;
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _locationLabel = 'Permiso denegado';
          _locationDenied = true;
          _locationLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String label;
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ].where((e) => e != null && e!.trim().isNotEmpty).map((e) => e!).toList();
        label = parts.isNotEmpty
            ? parts.join(', ')
            : '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
      } else {
        label =
            '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
      }

      if (!mounted) return;
      setState(() {
        _locationLabel = label;
        _locationDenied = false;
        _locationLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _locationLabel = 'Ubicacion no disponible';
        _locationDenied = true;
        _locationLoading = false;
      });
    }
  }

  Future<void> _handleLocationTap() async {
    if (_locationDenied) {
      await Geolocator.openLocationSettings();
      await Geolocator.openAppSettings();
    } else {
      await _initLocation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxCardsHeight = size.height * 0.74;
    const minCardsHeight = 210.0;
    final feedItems = const [
      LocalFeedItem(
        title: 'Mercado de Artesanias',
        subtitle: 'Barrio creativo, 1.4 km',
        color: Color(0xFFECE7F6),
      ),
      LocalFeedItem(
        title: 'Cafe de autor',
        subtitle: 'Tostado local, 18 min',
        color: Color(0xFFF4EEE3),
      ),
      LocalFeedItem(
        title: 'Museo interactivo',
        subtitle: 'Experiencia inmersiva',
        color: Color(0xFFE9F2F5),
      ),
      LocalFeedItem(
        title: 'Callejon nocturno',
        subtitle: 'Arte urbano y musica',
        color: Color(0xFFEFE9E2),
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF2F3F7),
                  Color(0xFFE7EBF3),
                  Color(0xFFF7F3ED),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Experiencias locales',
                              style: GoogleFonts.bebasNeue(
                                fontSize: 30,
                                letterSpacing: 1.2,
                                color: const Color(0xFF1E2430),
                              ),
                            ),
                            Text(
                              'Itinerarios disenados por la comunidad',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: const Color(0xFF586277),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: _handleLocationTap,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _locationDenied
                                          ? Icons.location_off
                                          : Icons.location_on,
                                      size: 14,
                                      color: _locationDenied
                                          ? const Color(0xFFB04A4A)
                                          : const Color(0xFF2E63F6),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _locationLoading
                                          ? 'Buscando ubicacion...'
                                          : _locationLabel,
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2D374B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.network(
                              'https://images.unsplash.com/'
                              'photo-1506794778202-cad84cf45f1d'
                              '?auto=format&fit=crop&w=80&q=80',
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: false,
                  delegate: CardsHeaderDelegate(
                    maxHeight: maxCardsHeight,
                    minHeight: minCardsHeight,
                    controller: _controller,
                    onOaxacaTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RouteMissionScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Agenda local',
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E2430),
                          ),
                        ),
                        Text(
                          'Ver todo',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E63F6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = feedItems[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: LocalFeedTile(item: item),
                      );
                    },
                    childCount: feedItems.length,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 140),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
