import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_navigator.dart';
import 'screens/tourist_home.dart';
import 'widgets/pet_overlay.dart';

class TouristApp extends StatelessWidget {
  const TouristApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF2B3850);
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Experiencias Locales',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          displaySmall: GoogleFonts.bebasNeue(
            fontSize: 34,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.manrope(
            fontSize: 13,
            height: 1.45,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
          labelLarge: GoogleFonts.manrope(
            fontSize: 12,
            letterSpacing: 0.6,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      home: const TouristHome(),
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            const PetOverlay(),
          ],
        );
      },
    );
  }
}
