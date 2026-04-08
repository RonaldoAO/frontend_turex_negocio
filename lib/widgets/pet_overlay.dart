import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../app_navigator.dart';
import '../screens/pet_intro_screen.dart';
import '../state/mission_tips.dart';
import 'pet_video.dart';

class PetOverlay extends StatefulWidget {
  const PetOverlay({super.key});

  @override
  State<PetOverlay> createState() => _PetOverlayState();
}

class _PetOverlayState extends State<PetOverlay> {
  static const double _petSize = 88;
  static const double _petMargin = 14;

  late final VideoPlayerController _controller;
  bool _ready = false;
  Offset? _offset;
  MissionTip? _tip;
  bool _showTip = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/ratita.mp4');
    _initVideo();
    MissionTipsController.current.addListener(_onTipChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final media = MediaQuery.of(context);
      final size = media.size;
      final padding = media.padding;
      setState(() {
        _offset = Offset(
          size.width - _petSize - _petMargin,
          size.height - _petSize - padding.bottom - _petMargin,
        );
      });
    });
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
    MissionTipsController.current.removeListener(_onTipChanged);
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Offset _clampOffset(Offset next, Size screen, EdgeInsets padding) {
    final minX = _petMargin;
    final maxX = screen.width - _petSize - _petMargin;
    final minY = padding.top + _petMargin;
    final maxY = screen.height - _petSize - padding.bottom - _petMargin;
    final dx = next.dx.clamp(minX, maxX);
    final dy = next.dy.clamp(minY, maxY);
    return Offset(dx, dy);
  }

  void _onTipChanged() {
    _tip = MissionTipsController.current.value;
    if (_tip == null) {
      if (mounted) {
        setState(() => _showTip = false);
      }
      return;
    }
    _showTipForDuration();
  }

  void _showTipForDuration() {
    _hideTimer?.cancel();
    if (mounted) {
      setState(() => _showTip = true);
    }
    _hideTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() => _showTip = false);
      }
    });
  }

  void _openPetScreen() {
    appNavigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const PetIntroScreen(),
      ),
    );
  }

  void _handleTap() {
    if (_tip != null) {
      _showTipForDuration();
      return;
    }
    _openPetScreen();
  }

  @override
  Widget build(BuildContext context) {
    if (_offset == null) return const SizedBox.shrink();
    return ValueListenableBuilder<bool>(
      valueListenable: MissionTipsController.petVisible,
      builder: (context, visible, _) {
        if (!visible) return const SizedBox.shrink();
        return Positioned(
          left: _offset!.dx,
          top: _offset!.dy,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (_showTip && _tip != null)
                Positioned(
                  right: 0,
                  bottom: _petSize + 10,
                  child: _TipBubble(tip: _tip!),
                ),
              GestureDetector(
                onPanUpdate: (details) {
                  final media = MediaQuery.of(context);
                  final next = _offset! + details.delta;
                  setState(() {
                    _offset = _clampOffset(next, media.size, media.padding);
                  });
                },
                child: PetVideo(
                  controller: _controller,
                  isReady: _ready,
                  onTap: _handleTap,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TipBubble extends StatelessWidget {
  final MissionTip tip;
  const _TipBubble({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tip.title,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E2430),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Dato curioso:',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2E63F6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tip.fact,
            style: GoogleFonts.manrope(
              fontSize: 11,
              height: 1.35,
              color: const Color(0xFF4C586B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tip.meaning,
            style: GoogleFonts.manrope(
              fontSize: 11,
              height: 1.35,
              color: const Color(0xFF4C586B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
