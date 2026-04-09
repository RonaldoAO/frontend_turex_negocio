import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/mission.dart';
import '../services/companies_service.dart';
import '../state/mission_progress.dart';
import '../state/mission_tips.dart';
import 'map_mission_screen.dart';

class RouteMissionScreen extends StatefulWidget {
  const RouteMissionScreen({super.key});

  @override
  State<RouteMissionScreen> createState() => _RouteMissionScreenState();
}

class _RouteMissionScreenState extends State<RouteMissionScreen> {
  static const int _totalSteps = 4;
  static const List<MissionTip> _tips = [
    MissionTip(
      title: 'Dona Lupita - Tlayudas',
      fact:
          'La tlayuda es originaria de los Valles Centrales de Oaxaca y su '
          'tortilla es mas grande y crujiente porque se cuece dos veces.',
      meaning: 'Por eso aguanta tantos ingredientes sin romperse.',
    ),
    MissionTip(
      title: 'Don Mateo - Textiles',
      fact:
          'Muchos textiles de Oaxaca usan tintes naturales como cochinilla, '
          'un insecto que produce el color rojo intenso desde tiempos '
          'prehispanicos.',
      meaning: 'Ese rojo no es pintura, es biologia.',
    ),
    MissionTip(
      title: 'Ana - Cafe de olla',
      fact:
          'El cafe de olla se popularizo durante la Revolucion Mexicana '
          'porque se preparaba facil en campamentos y se endulzaba con piloncillo.',
      meaning: 'Es una receta historica, no solo cafe.',
    ),
    MissionTip(
      title: 'Dona Carmen - Cocina del dia',
      fact:
          'En muchas cocinas tradicionales de Oaxaca no hay menu porque se '
          'cocina segun lo disponible en el mercado cada manana.',
      meaning: 'Lo que comas hoy es unico.',
    ),
    MissionTip(
      title: 'Luis - Alebrijes',
      fact:
          'Los alebrijes no nacieron en Oaxaca, sino en CDMX, pero en Oaxaca '
          'evolucionaron usando madera de copal y disenos zapotecos.',
      meaning: 'Estas viendo una reinterpretacion cultural.',
    ),
    MissionTip(
      title: 'Jorge - Mezcal',
      fact:
          'El mezcal se produce desde hace mas de 400 anos y cada tipo de '
          'agave tarda entre 7 y 30 anos en madurar.',
      meaning: 'No es una bebida rapida, es un proceso largo.',
    ),
    MissionTip(
      title: 'Maribel - Memelas',
      fact:
          'Las memelas son una de las formas mas antiguas de consumir maiz '
          'en Mexico, desde antes de la conquista.',
      meaning: 'Estas comiendo algo con siglos de historia.',
    ),
    MissionTip(
      title: 'Don Raul - Musica',
      fact:
          'La musica tradicional oaxaquena mezcla influencias indigenas, '
          'espanolas y africanas, creando sonidos unicos por region.',
      meaning: 'Cada cancion tiene raices mezcladas.',
    ),
  ];
  final List<MissionStep> _steps = const [
    MissionStep(
      title: 'Manana',
      subtitle: 'Desayuno oaxaqueno',
      icon: Icons.breakfast_dining,
      businesses: [],
      remoteLoader: fetchOaxacaBreakfastCompanies,
    ),
    MissionStep(
      title: 'Medio dia',
      subtitle: 'Taller artesanal',
      icon: Icons.handyman,
      businesses: [
        BusinessLocation(
          id: 'artisan-1',
          name: 'Taller Tejido Oaxaca',
          lat: 17.0632,
          lng: -96.7264,
          status: 'OPEN',
        ),
        BusinessLocation(
          id: 'artisan-2',
          name: 'Arte en Barro',
          lat: 17.0588,
          lng: -96.7233,
          status: 'OPEN',
        ),
        BusinessLocation(
          id: 'artisan-3',
          name: 'Textiles del Centro',
          lat: 17.0603,
          lng: -96.7208,
          status: 'OPEN',
        ),
        BusinessLocation(
          id: 'artisan-4',
          name: 'Manos de Oax',
          lat: 17.0627,
          lng: -96.7291,
          status: 'OPEN',
        ),
      ],
    ),
    MissionStep(
      title: 'Tarde',
      subtitle: 'Comida local',
      icon: Icons.lunch_dining,
      businesses: [
        BusinessLocation(
          id: 'food-1',
          name: 'Mole & Mezcal',
          lat: 17.0583,
          lng: -96.7269,
          status: 'OPEN',
        ),
        BusinessLocation(
          id: 'food-2',
          name: 'Sazon de la Sierra',
          lat: 17.0612,
          lng: -96.7294,
          status: 'OPEN',
        ),
        BusinessLocation(
          id: 'food-3',
          name: 'Sabores del Zocalo',
          lat: 17.0624,
          lng: -96.7239,
          status: 'OPEN',
        ),
      ],
    ),
    MissionStep(
      title: 'Noche',
      subtitle: 'Experiencia cultural',
      icon: Icons.theater_comedy,
      businesses: [
        BusinessLocation(
          id: 'night-1',
          name: 'Centro Cultural',
          lat: 17.0596,
          lng: -96.7246,
          status: 'OPEN',
        ),
        BusinessLocation(
          id: 'night-2',
          name: 'Patio de Musica',
          lat: 17.0637,
          lng: -96.7278,
          status: 'OPEN',
        ),
        BusinessLocation(
          id: 'night-3',
          name: 'Teatro Local',
          lat: 17.0618,
          lng: -96.7302,
          status: 'OPEN',
        ),
      ],
    ),
  ];

  int _currentIndex = 0;
  final Set<int> _completed = {};

  @override
  void initState() {
    super.initState();
    final progress = MissionProgressController.current.value;
    if (progress.started) {
      _currentIndex = progress.currentIndex;
      _completed.addAll(List.generate(progress.completedCount, (i) => i));
    }
    MissionTipsController.setTips(_tips);
    MissionTipsController.showRandom();
  }

  @override
  void dispose() {
    MissionTipsController.clear();
    super.dispose();
  }

  Future<void> _startCurrentMission() async {
    if (!_completed.contains(_currentIndex)) {
      MissionProgressController.markStarted();
    }
    final step = _steps[_currentIndex];
    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => MapMissionScreen(step: step),
      ),
    );

    if (completed == true && mounted) {
      setState(() {
        _completed.add(_currentIndex);
        if (_currentIndex < _steps.length - 1) {
          _currentIndex += 1;
        }
      });
      MissionProgressController.updateProgress(
        currentIndex: _currentIndex,
        completedCount: _completed.length,
      );
      MissionTipsController.showRandom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _steps[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Ruta viva de Oaxaca',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E2430),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logros desbloqueables',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E2430),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(_steps.length, (index) {
                final step = _steps[index];
                final isDone = _completed.contains(index);
                final isActive = index == _currentIndex;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index == _steps.length - 1 ? 0 : 10),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFEAF2FF) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDone
                            ? const Color(0xFF2E63F6)
                            : const Color(0xFFE0E4EC),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          isDone ? Icons.check_circle : step.icon,
                          color: isDone
                              ? const Color(0xFF2E63F6)
                              : const Color(0xFF6C7486),
                          size: 20,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step.title,
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6C7486),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              'Mision actual',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E2430),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE0E4EC)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      currentStep.icon,
                      color: const Color(0xFF2E63F6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentStep.subtitle,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E2430),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Completa la mision para desbloquear el siguiente paso.',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: const Color(0xFF6C7486),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _completed.length >= _totalSteps ? null : _startCurrentMission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2430),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _completed.length >= _totalSteps
                      ? 'Ruta completada'
                      : MissionProgressController.current.value.started ||
                              _completed.isNotEmpty
                          ? 'Continuar'
                          : 'Iniciar mision',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
