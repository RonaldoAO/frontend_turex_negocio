import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../state/mission_tips.dart';

class PetIntroScreen extends StatefulWidget {
  const PetIntroScreen({super.key});

  @override
  State<PetIntroScreen> createState() => _PetIntroScreenState();
}

class _PetIntroScreenState extends State<PetIntroScreen> {
  late final VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    MissionTipsController.setPetVisible(false);
    _controller = VideoPlayerController.asset('assets/videos/ratita2.mp4');
    _initVideo();
  }

  Future<void> _initVideo() async {
    await _controller.setLooping(true);
    await _controller.setVolume(0);
    await _controller.initialize();
    if (!mounted) return;
    setState(() => _ready = true);
    await _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    MissionTipsController.setPetVisible(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Se acerca el mundial',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 26,
                          letterSpacing: 1.1,
                          color: const Color(0xFF1E2430),
                        ),
                      ),
                      Text(
                        'Planea tu presupuesto desde hoy y evita sorpresas',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: const Color(0xFF6C7486),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Color(0xFF1E2430)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: _ready
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: _controller.value.size.width == 0
                                    ? 220
                                    : _controller.value.size.width,
                                height: _controller.value.size.height == 0
                                    ? 220
                                    : _controller.value.size.height,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.pets,
                              color: Color(0xFF3A4B66),
                              size: 42,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7FF),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hey, se acerca el mundial',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: const Color(0xFF6C7486),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Es mejor tener planeados tus presupuestos desde hoy',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F1A2B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Evita sufrir despues y disfruta el mundial sin '
                    'preocupaciones.',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      height: 1.5,
                      color: const Color(0xFF566073),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1E2430),
                          textStyle: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Saltar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E2430),
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(14),
                          elevation: 0,
                        ),
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
