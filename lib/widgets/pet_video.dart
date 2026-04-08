import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PetVideo extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isReady;
  final VoidCallback? onTap;

  const PetVideo({
    super.key,
    required this.controller,
    required this.isReady,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: isReady
                ? IgnorePointer(
                    child: VideoPlayer(controller),
                  )
                : const Center(
                    child: Icon(
                      Icons.pets,
                      color: Color(0xFF3A4B66),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
