import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/ui_utils.dart';
import 'image_fill.dart';
import 'stat_widgets.dart';

class CardsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;
  final PageController controller;
  final VoidCallback? onOaxacaTap;

  CardsHeaderDelegate({
    required this.maxHeight,
    required this.minHeight,
    required this.controller,
    this.onOaxacaTap,
  });

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double t = clamp01(shrinkOffset / (maxExtent - minExtent));
    final double scale = ui.lerpDouble(1, 0.94, t) ?? 1;
    return SizedBox.expand(
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.topCenter,
        child: PageView(
          controller: controller,
          children: [
            _TouristCardLeft(t: t, onTap: onOaxacaTap),
            _TouristCardLeftAltOne(t: t),
            _TouristCardLeftAltTwo(t: t),
            _TouristCardRight(t: t),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant CardsHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        controller != oldDelegate.controller ||
        onOaxacaTap != oldDelegate.onOaxacaTap;
  }
}

class _TouristCardLeft extends StatelessWidget {
  final double t;
  final VoidCallback? onTap;
  const _TouristCardLeft({required this.t, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double collapse = clamp01(t);
    final double textFactor = clamp01(1 - collapse);
    final double chipsShift = ui.lerpDouble(0, -36, collapse) ?? 0;
    final double buttonScale = ui.lerpDouble(1, 0.6, collapse) ?? 1;
    final double buttonOpacity = clamp01(1 - collapse * 1.2);
    final EdgeInsets contentPadding = EdgeInsets.lerp(
          const EdgeInsets.fromLTRB(22, 24, 22, 22),
          const EdgeInsets.fromLTRB(22, 14, 22, 16),
          collapse,
        ) ??
        const EdgeInsets.fromLTRB(22, 24, 22, 22);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
            const ImageFill(
              url:
                  'https://plus.unsplash.com/premium_photo-1730425752722-f5f31f316f61'
                  '?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid='
                  'M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFCA7C54),
                    Color(0x882B1F1B),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Padding(
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizeTransition(
                    sizeFactor: AlwaysStoppedAnimation(textFactor),
                    axisAlignment: -1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RUTA VIVA DE OAXACA', style: textTheme.displaySmall),
                        const SizedBox(height: 10),
                        Text(
                          'Vive Oaxaca a piel, sin filtros ni rutas genericas: '
                          'solo experiencias reales que te muestran exactamente '
                          'que hacer en cada momento.',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Transform.translate(
                    offset: Offset(0, chipsShift),
                    child: Row(
                      children: const [
                        StatChip(
                          title: '120',
                          subtitle: 'negocios',
                          color: Color(0xFF2E63F6),
                        ),
                        SizedBox(width: 16),
                        StatChip(
                          title: '4.9',
                          subtitle: 'ranking',
                          color: Color(0xFF1C1C1C),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ui.lerpDouble(18, 6, collapse) ?? 12),
                  Opacity(
                    opacity: buttonOpacity,
                    child: Transform.scale(
                      scale: buttonScale,
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white70,
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.near_me_outlined,
                                color: Colors.white,
                                size: 26,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Iniciar',
                                style: textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 18,
              bottom: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pin_drop, size: 16, color: Color(0xFF3A4B66)),
                    const SizedBox(width: 6),
                    Text(
                      'Oaxaca de Juarez, OAXACA',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3A4B66),
                      ),
                    ),
                  ],
                ),
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TouristCardLeftAltOne extends StatelessWidget {
  final double t;
  const _TouristCardLeftAltOne({required this.t});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double collapse = clamp01(t);
    final double descFactor = clamp01(1 - collapse);
    final double chipsFactor = clamp01(1 - collapse * 1.3);
    final double rowShift = ui.lerpDouble(0, -28, collapse) ?? 0;
    final EdgeInsets contentPadding = EdgeInsets.lerp(
          const EdgeInsets.fromLTRB(22, 22, 22, 22),
          const EdgeInsets.fromLTRB(22, 14, 22, 16),
          collapse,
        ) ??
        const EdgeInsets.fromLTRB(22, 22, 22, 22);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ImageFill(
              url:
                  'https://www.mexicodesconocido.com.mx/wp-content/uploads/2020/09/'
                  '6029400765_ebcf494aff_o-900x620.jpg',
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF22304A),
                    Color(0xAA17202B),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('VELA ISTMEÑA', style: textTheme.displaySmall),
                  const SizedBox(height: 6),
                  Text(
                    'La noche que nunca se apaga',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizeTransition(
                    sizeFactor: AlwaysStoppedAnimation(descFactor),
                    axisAlignment: -1,
                    child: Text(
                      'Fiesta comunitaria en el Istmo de Oaxaca, llena de '
                      'musica en vivo, baile y tradicion que se vive hasta '
                      'el amanecer.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: ui.lerpDouble(18, 6, collapse) ?? 12),
                  SizeTransition(
                    sizeFactor: AlwaysStoppedAnimation(chipsFactor),
                    axisAlignment: -1,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        MiniInfo(label: '6 paradas'),
                        MiniInfo(label: '2.2 km'),
                        MiniInfo(label: 'Live DJ'),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Transform.translate(
                    offset: Offset(0, rowShift),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Desde',
                              style: textTheme.bodyMedium,
                            ),
                            Text(
                              r'$2200',
                              style: GoogleFonts.bebasNeue(
                                fontSize: 34,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E63F6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                '4.8 • Reserva',
                                style: textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 18,
              bottom: 18,
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    'Centro Historico, CDMX',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
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
}

class _TouristCardLeftAltTwo extends StatelessWidget {
  final double t;
  const _TouristCardLeftAltTwo({required this.t});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double collapse = clamp01(t);
    final double descFactor = clamp01(1 - collapse);
    final double infoFactor = clamp01(1 - collapse * 1.1);
    final double rowShift = ui.lerpDouble(0, -28, collapse) ?? 0;
    final EdgeInsets contentPadding = EdgeInsets.lerp(
          const EdgeInsets.fromLTRB(22, 22, 22, 22),
          const EdgeInsets.fromLTRB(22, 14, 22, 16),
          collapse,
        ) ??
        const EdgeInsets.fromLTRB(22, 22, 22, 22);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ImageFill(
              url:
                  'https://images.unsplash.com/photo-1501785888041-af3ef285b470'
                  '?auto=format&fit=crop&w=900&q=80',
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0C1A1B),
                    Color(0x990C1A1B),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Padding(
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CAMINATA VERDE', style: textTheme.displaySmall),
                  const SizedBox(height: 6),
                  SizeTransition(
                    sizeFactor: AlwaysStoppedAnimation(descFactor),
                    axisAlignment: -1,
                    child: Text(
                      'Senderos, miradores y puntos para fotos en la '
                      'manana. Ideal para grupos pequenos.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: ui.lerpDouble(18, 6, collapse) ?? 12),
                  SizeTransition(
                    sizeFactor: AlwaysStoppedAnimation(infoFactor),
                    axisAlignment: -1,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.directions_walk,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Salida 7:00 AM • Punto de encuentro: '
                              'Metro Viveros',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Transform.translate(
                    offset: Offset(0, rowShift),
                    child: Row(
                      children: const [
                        StatChip(
                          title: '8.2',
                          subtitle: 'km',
                          color: Color(0xFF1C1C1C),
                        ),
                        SizedBox(width: 16),
                        StatChip(
                          title: '3.5',
                          subtitle: 'hrs',
                          color: Color(0xFF2E63F6),
                        ),
                        Spacer(),
                        _ArrowCircle(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 18,
              bottom: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Viveros, CDMX',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3A4B66),
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

class _ArrowCircle extends StatelessWidget {
  const _ArrowCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white70,
          width: 1.2,
        ),
      ),
      child: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
    );
  }
}

class _TouristCardRight extends StatelessWidget {
  final double t;
  const _TouristCardRight({required this.t});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double collapse = clamp01(t);
    final double infoFactor = clamp01(1 - collapse * 1.2);
    final double rowShift = ui.lerpDouble(0, -24, collapse) ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ImageFill(
              url:
                  'https://images.unsplash.com/photo-1469474968028-'
                  '56623f02e42e?auto=format&fit=crop&w=900&q=80',
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xCC0B241D),
                    Color(0x8A0B241D),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.network(
                            'https://images.unsplash.com/'
                            'photo-1544723795-3fb6469f5b39'
                            '?auto=format&fit=crop&w=80&q=80',
                            fit: BoxFit.cover,
                            width: 36,
                            height: 36,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Renata Alvarez',
                            style: textTheme.titleLarge,
                          ),
                          Text(
                            'Guia local • Nivel 28',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Transform.translate(
                    offset: Offset(0, rowShift),
                    child: Row(
                      children: const [
                        Metric(
                          value: '824',
                          label: 'Rutas',
                        ),
                        SizedBox(width: 20),
                        Metric(
                          value: '56',
                          label: 'Estancias',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizeTransition(
                    sizeFactor: AlwaysStoppedAnimation(infoFactor),
                    axisAlignment: -1,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chapultepec Nocturno',
                            style: textTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Recorre senderos iluminados, lagos y museos '
                            'con musica en vivo y food trucks locales.',
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: const [
                              Tag(text: 'Arte y cultura'),
                              SizedBox(width: 8),
                              Tag(text: '2.5 hrs'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        'Bosque de Chapultepec',
                        style: textTheme.labelLarge?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 22,
                        ),
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
