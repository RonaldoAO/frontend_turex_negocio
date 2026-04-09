import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/ui_utils.dart';
import 'image_fill.dart';
import 'stat_widgets.dart';

class CardsHeaderCopy {
  final Map<String, String> text;
  const CardsHeaderCopy(this.text);

  String get(String key) => text[key] ?? key;
}

class CardsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;
  final PageController controller;
  final VoidCallback? onOaxacaTap;
  final CardsHeaderCopy copy;

  CardsHeaderDelegate({
    required this.maxHeight,
    required this.minHeight,
    required this.controller,
    required this.copy,
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
            _TouristCardLeft(t: t, onTap: onOaxacaTap, copy: copy),
            _TouristCardLeftAltOne(t: t, copy: copy),
            _TouristCardLeftAltTwo(t: t, copy: copy),
            _TouristCardRight(t: t, copy: copy),
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
        onOaxacaTap != oldDelegate.onOaxacaTap ||
        copy != oldDelegate.copy;
  }
}

class _TouristCardLeft extends StatelessWidget {
  final double t;
  final VoidCallback? onTap;
  final CardsHeaderCopy copy;
  const _TouristCardLeft({
    required this.t,
    this.onTap,
    required this.copy,
  });

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
                            Text(
                              copy.get('cards.card1.title'),
                              style: textTheme.displaySmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              copy.get('cards.card1.body'),
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Transform.translate(
                        offset: Offset(0, chipsShift),
                        child: Row(
                          children: [
                            StatChip(
                              title: '120',
                              subtitle: copy.get('cards.card1.statBusinesses'),
                              color: const Color(0xFF2E63F6),
                            ),
                            const SizedBox(width: 16),
                            StatChip(
                              title: '4.9',
                              subtitle: copy.get('cards.card1.statRating'),
                              color: const Color(0xFF1C1C1C),
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
                                    copy.get('cards.card1.action'),
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
                          copy.get('cards.card1.location'),
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
  final CardsHeaderCopy copy;
  const _TouristCardLeftAltOne({required this.t, required this.copy});

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
                  Text(copy.get('cards.card2.title'), style: textTheme.displaySmall),
                  const SizedBox(height: 6),
                  Text(
                    copy.get('cards.card2.subtitle'),
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
                      copy.get('cards.card2.body'),
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
                      children: [
                        MiniInfo(label: copy.get('cards.card2.chipStops')),
                        MiniInfo(label: copy.get('cards.card2.chipDistance')),
                        MiniInfo(label: copy.get('cards.card2.chipMusic')),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Transform.translate(
                    offset: Offset(0, rowShift),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                copy.get('cards.card2.priceLabel'),
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
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Container(
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
                                    copy.get('cards.card2.reserveCta'),
                                    style: textTheme.labelLarge,
                                  ),
                                ],
                              ),
                            ),
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
                    copy.get('cards.card2.location'),
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
  final CardsHeaderCopy copy;
  const _TouristCardLeftAltTwo({required this.t, required this.copy});

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
                  'https://images.pexels.com/photos/16977412/'
                  'pexels-photo-16977412.jpeg',
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
                  Text(copy.get('cards.card3.title'), style: textTheme.displaySmall),
                  const SizedBox(height: 6),
                  SizeTransition(
                    sizeFactor: AlwaysStoppedAnimation(descFactor),
                    axisAlignment: -1,
                    child: Text(
                      copy.get('cards.card3.body'),
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
                              copy.get('cards.card3.info'),
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
                      children: [
                        StatChip(
                          title: '8.2',
                          subtitle: copy.get('cards.card3.statKm'),
                          color: const Color(0xFF1C1C1C),
                        ),
                        const SizedBox(width: 16),
                        StatChip(
                          title: '3.5',
                          subtitle: copy.get('cards.card3.statHrs'),
                          color: const Color(0xFF2E63F6),
                        ),
                        const Spacer(),
                        const _ArrowCircle(),
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
                  copy.get('cards.card3.location'),
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
  final CardsHeaderCopy copy;
  const _TouristCardRight({required this.t, required this.copy});

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
                            copy.get('cards.card4.name'),
                            style: textTheme.titleLarge,
                          ),
                          Text(
                            copy.get('cards.card4.role'),
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
                      children: [
                        Metric(
                          value: '824',
                          label: copy.get('cards.card4.metricRoutes'),
                        ),
                        const SizedBox(width: 20),
                        Metric(
                          value: '56',
                          label: copy.get('cards.card4.metricStays'),
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
                            copy.get('cards.card4.title'),
                            style: textTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            copy.get('cards.card4.body'),
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Tag(text: copy.get('cards.card4.tag1')),
                              const SizedBox(width: 8),
                              Tag(text: copy.get('cards.card4.tag2')),
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
                        copy.get('cards.card4.footer'),
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
