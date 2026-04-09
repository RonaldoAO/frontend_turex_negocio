import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/cards_header.dart';
import '../widgets/agenda_section.dart';
import 'route_mission_screen.dart';
import '../state/mission_progress.dart';

enum AppLanguage { es, en, de }

const Map<AppLanguage, String> _languageLabels = {
  AppLanguage.es: 'ES',
  AppLanguage.en: 'EN',
  AppLanguage.de: 'DE',
};

const Map<AppLanguage, Map<String, String>> _uiStrings = {
  AppLanguage.es: {
    'home.title': 'Experiencias locales',
    'home.subtitle': 'Itinerarios diseñados por la comunidad',
    'home.location.loading': 'Buscando ubicación...',
    'home.location.enable': 'Activa ubicación',
    'home.location.denied': 'Permiso denegado',
    'home.location.unavailable': 'Ubicación no disponible',
    'home.missions.title': 'Mis misiones',
    'home.mission.empty.title': 'Aún no inicias una misión',
    'home.mission.empty.body': 'Elige una ruta para comenzar.',
    'home.mission.active.title': 'Ruta viva de Oaxaca',
    'home.mission.active.step': 'Paso actual: {step}',
    'home.mission.active.cta': 'Continuar',
    'home.agenda.title': 'Agenda local',
    'home.agenda.all': 'Ver todo',
    'home.step.breakfast': 'Desayuno oaxaqueño',
    'home.step.workshop': 'Taller artesanal',
    'home.step.lunch': 'Comida local',
    'home.step.culture': 'Experiencia cultural',
  },
  AppLanguage.en: {
    'home.title': 'Local experiences',
    'home.subtitle': 'Community-designed itineraries',
    'home.location.loading': 'Finding location...',
    'home.location.enable': 'Enable location',
    'home.location.denied': 'Permission denied',
    'home.location.unavailable': 'Location unavailable',
    'home.missions.title': 'My missions',
    'home.mission.empty.title': "You haven't started a mission yet",
    'home.mission.empty.body': 'Choose a route to start.',
    'home.mission.active.title': 'Oaxaca Live Route',
    'home.mission.active.step': 'Current step: {step}',
    'home.mission.active.cta': 'Continue',
    'home.agenda.title': 'Local agenda',
    'home.agenda.all': 'See all',
    'home.step.breakfast': 'Oaxacan breakfast',
    'home.step.workshop': 'Artisan workshop',
    'home.step.lunch': 'Local meal',
    'home.step.culture': 'Cultural experience',
  },
  AppLanguage.de: {
    'home.title': 'Lokale Erlebnisse',
    'home.subtitle': 'Von der Community gestaltete Routen',
    'home.location.loading': 'Standort wird gesucht...',
    'home.location.enable': 'Standort aktivieren',
    'home.location.denied': 'Berechtigung verweigert',
    'home.location.unavailable': 'Standort nicht verfügbar',
    'home.missions.title': 'Meine Missionen',
    'home.mission.empty.title': 'Du hast noch keine Mission gestartet',
    'home.mission.empty.body': 'Wähle eine Route, um zu starten.',
    'home.mission.active.title': 'Oaxaca Live-Route',
    'home.mission.active.step': 'Aktueller Schritt: {step}',
    'home.mission.active.cta': 'Weiter',
    'home.agenda.title': 'Lokale Agenda',
    'home.agenda.all': 'Alle anzeigen',
    'home.step.breakfast': 'Oaxakanisches Frühstück',
    'home.step.workshop': 'Handwerks-Workshop',
    'home.step.lunch': 'Lokales Essen',
    'home.step.culture': 'Kulturelles Erlebnis',
  },
};

const Map<AppLanguage, Map<String, String>> _cardStrings = {
  AppLanguage.es: {
    'cards.card1.title': 'RUTA VIVA DE OAXACA',
    'cards.card1.body':
        'Vive Oaxaca a piel, sin filtros ni rutas genéricas: solo experiencias reales que te muestran exactamente qué hacer en cada momento.',
    'cards.card1.statBusinesses': 'negocios',
    'cards.card1.statRating': 'ranking',
    'cards.card1.action': 'Iniciar',
    'cards.card1.location': 'Oaxaca de Juárez, OAXACA',
    'cards.card2.title': 'VELA ISTMEÑA',
    'cards.card2.subtitle': 'La noche que nunca se apaga',
    'cards.card2.body':
        'Fiesta comunitaria en el Istmo de Oaxaca, llena de música en vivo, baile y tradición que se vive hasta el amanecer.',
    'cards.card2.chipStops': '6 paradas',
    'cards.card2.chipDistance': '2.2 km',
    'cards.card2.chipMusic': 'Live DJ',
    'cards.card2.priceLabel': 'Desde',
    'cards.card2.reserveCta': '4.8 - Reserva',
    'cards.card2.location': 'Juchitán, Oaxaca',
    'cards.card3.title': 'GUELAGUETZA',
    'cards.card3.body':
        'Una fiesta llena de danzas, música y tradiciones donde Oaxaca comparte lo mejor de su cultura con todos.',
    'cards.card3.info':
        'Caminata al auditorio Guelaguetza. Punto de encuentro: Santo Domingo, Oaxaca',
    'cards.card3.statKm': 'km',
    'cards.card3.statHrs': 'hrs',
    'cards.card3.location': 'Oaxaca de Juárez',
    'cards.card4.name': 'Renata Álvarez',
    'cards.card4.role': 'Guía local • Nivel 28',
    'cards.card4.metricRoutes': 'Rutas',
    'cards.card4.metricStays': 'Estancias',
    'cards.card4.title': 'Chapultepec Nocturno',
    'cards.card4.body':
        'Recorre senderos iluminados, lagos y museos con música en vivo y food trucks locales.',
    'cards.card4.tag1': 'Arte y cultura',
    'cards.card4.tag2': '2.5 hrs',
    'cards.card4.footer': 'Bosque de Chapultepec',
  },
  AppLanguage.en: {
    'cards.card1.title': 'RUTA VIVA DE OAXACA',
    'cards.card1.body':
        'Experience Oaxaca raw—no filters or generic routes. Real moments that show you exactly what to do at each step.',
    'cards.card1.statBusinesses': 'businesses',
    'cards.card1.statRating': 'rating',
    'cards.card1.action': 'Start',
    'cards.card1.location': 'Oaxaca de Juárez, OAXACA',
    'cards.card2.title': 'VELA ISTMEÑA',
    'cards.card2.subtitle': 'The night that never ends',
    'cards.card2.body':
        'A community celebration in the Isthmus of Oaxaca, with live music, dance, and tradition until dawn.',
    'cards.card2.chipStops': '6 stops',
    'cards.card2.chipDistance': '2.2 km',
    'cards.card2.chipMusic': 'Live DJ',
    'cards.card2.priceLabel': 'From',
    'cards.card2.reserveCta': '4.8 - Book',
    'cards.card2.location': 'Juchitán, Oaxaca',
    'cards.card3.title': 'GUELAGUETZA',
    'cards.card3.body':
        'A festival of dances, music, and traditions where Oaxaca shares the best of its culture.',
    'cards.card3.info':
        'Walk to the Guelaguetza auditorium. Meeting point: Santo Domingo, Oaxaca',
    'cards.card3.statKm': 'km',
    'cards.card3.statHrs': 'hrs',
    'cards.card3.location': 'Oaxaca de Juárez',
    'cards.card4.name': 'Renata Álvarez',
    'cards.card4.role': 'Local guide • Level 28',
    'cards.card4.metricRoutes': 'Routes',
    'cards.card4.metricStays': 'Stays',
    'cards.card4.title': 'Chapultepec at Night',
    'cards.card4.body':
        'Walk illuminated trails, lakes, and museums with live music and local food trucks.',
    'cards.card4.tag1': 'Art & culture',
    'cards.card4.tag2': '2.5 hrs',
    'cards.card4.footer': 'Chapultepec Forest',
  },
  AppLanguage.de: {
    'cards.card1.title': 'RUTA VIVA DE OAXACA',
    'cards.card1.body':
        'Erlebe Oaxaca hautnah – ohne Filter oder generische Routen. Echte Momente, die dir genau zeigen, was du wann tun kannst.',
    'cards.card1.statBusinesses': 'Geschäfte',
    'cards.card1.statRating': 'Bewertung',
    'cards.card1.action': 'Starten',
    'cards.card1.location': 'Oaxaca de Juárez, OAXACA',
    'cards.card2.title': 'VELA ISTMEÑA',
    'cards.card2.subtitle': 'Die Nacht, die nie endet',
    'cards.card2.body':
        'Ein Gemeinschaftsfest im Isthmus von Oaxaca mit Live-Musik, Tanz und Tradition bis zum Morgengrauen.',
    'cards.card2.chipStops': '6 Stopps',
    'cards.card2.chipDistance': '2.2 km',
    'cards.card2.chipMusic': 'Live-DJ',
    'cards.card2.priceLabel': 'Ab',
    'cards.card2.reserveCta': '4.8 - Buchen',
    'cards.card2.location': 'Juchitán, Oaxaca',
    'cards.card3.title': 'GUELAGUETZA',
    'cards.card3.body':
        'Ein Fest voller Tänze, Musik und Traditionen, bei dem Oaxaca das Beste seiner Kultur teilt.',
    'cards.card3.info':
        'Spaziergang zum Guelaguetza-Auditorium. Treffpunkt: Santo Domingo, Oaxaca',
    'cards.card3.statKm': 'km',
    'cards.card3.statHrs': 'Std.',
    'cards.card3.location': 'Oaxaca de Juárez',
    'cards.card4.name': 'Renata Álvarez',
    'cards.card4.role': 'Lokaler Guide • Level 28',
    'cards.card4.metricRoutes': 'Routen',
    'cards.card4.metricStays': 'Aufenthalte',
    'cards.card4.title': 'Chapultepec bei Nacht',
    'cards.card4.body':
        'Spaziere durch beleuchtete Wege, Seen und Museen mit Live-Musik und lokalen Food Trucks.',
    'cards.card4.tag1': 'Kunst & Kultur',
    'cards.card4.tag2': '2.5 Std.',
    'cards.card4.footer': 'Bosque de Chapultepec',
  },
};

class TouristHome extends StatefulWidget {
  const TouristHome({super.key});

  @override
  State<TouristHome> createState() => _TouristHomeState();
}

class _TouristHomeState extends State<TouristHome> {
  late final PageController _controller;
  String? _locationResolved;
  bool _locationDenied = false;
  bool _locationServiceDisabled = false;
  bool _locationLoading = true;
  AppLanguage _language = AppLanguage.es;

  String _t(String key) {
    return _uiStrings[_language]?[key] ?? key;
  }

  CardsHeaderCopy _cardCopy() {
    return CardsHeaderCopy(
      _cardStrings[_language] ?? _cardStrings[AppLanguage.es]!,
    );
  }

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
          _locationDenied = true;
          _locationServiceDisabled = true;
          _locationResolved = null;
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
          _locationDenied = true;
          _locationServiceDisabled = false;
          _locationResolved = null;
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
        _locationResolved = label;
        _locationDenied = false;
        _locationServiceDisabled = false;
        _locationLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _locationResolved = null;
        _locationDenied = false;
        _locationServiceDisabled = false;
        _locationLoading = false;
      });
    }
  }

  Future<void> _handleLocationTap() async {
    if (_locationDenied || _locationServiceDisabled) {
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
    const minCardsHeight = 80.0;
    final stepLabels = [
      _t('home.step.breakfast'),
      _t('home.step.workshop'),
      _t('home.step.lunch'),
      _t('home.step.culture'),
    ];
    final locationText = _locationLoading
        ? _t('home.location.loading')
        : _locationServiceDisabled
            ? _t('home.location.enable')
            : _locationDenied
                ? _t('home.location.denied')
                : (_locationResolved ?? _t('home.location.unavailable'));
    final locationHasError = _locationDenied ||
        _locationServiceDisabled ||
        (!_locationLoading && _locationResolved == null);
    // Agenda local ahora se construye desde giros/empresas remotas.
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
                              _t('home.title'),
                              style: GoogleFonts.bebasNeue(
                                fontSize: 30,
                                letterSpacing: 1.2,
                                color: const Color(0xFF1E2430),
                              ),
                            ),
                            Text(
                              _t('home.subtitle'),
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
                                      locationHasError
                                          ? Icons.location_off
                                          : Icons.location_on,
                                      size: 14,
                                      color: locationHasError
                                          ? const Color(0xFFB04A4A)
                                          : const Color(0xFF2E63F6),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      locationText,
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
                        Row(
                          children: [
                            Container(
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<AppLanguage>(
                                  value: _language,
                                  icon: const Icon(Icons.language, size: 16),
                                  items: AppLanguage.values
                                      .map(
                                        (lang) => DropdownMenuItem(
                                          value: lang,
                                          child: Text(
                                            _languageLabels[lang] ?? 'ES',
                                            style: GoogleFonts.manrope(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF2D374B),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() => _language = value);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
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
                    copy: _cardCopy(),
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
                          _t('home.missions.title'),
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E2430),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ValueListenableBuilder<MissionProgress>(
                    valueListenable: MissionProgressController.current,
                    builder: (context, progress, _) {
                      if (!progress.started) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F7FB),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE0E4EC)),
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
                                    Icons.flag_outlined,
                                    color: Color(0xFF2E63F6),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _t('home.mission.empty.title'),
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF1E2430),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _t('home.mission.empty.body'),
                                        style: GoogleFonts.manrope(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF6C7486),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final current = progress.currentIndex;
                      final label = stepLabels[
                          current.clamp(0, stepLabels.length - 1)];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FB),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE0E4EC)),
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
                                  Icons.map_outlined,
                                  color: Color(0xFF2E63F6),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _t('home.mission.active.title'),
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF1E2430),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _t('home.mission.active.step')
                                          .replaceFirst('{step}', label),
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF6C7486),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const RouteMissionScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF2E63F6),
                                  textStyle: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                child: Text(_t('home.mission.active.cta')),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _t('home.agenda.title'),
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E2430),
                          ),
                        ),
                        Text(
                          _t('home.agenda.all'),
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
                const SliverToBoxAdapter(
                  child: AgendaSection(),
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
