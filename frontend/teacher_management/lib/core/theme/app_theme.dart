// core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      primary: AppColors.primary,
    ),
    textTheme: TextTheme(
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontWeight: FontWeight.w700,
        fontSize: 21,
        color: AppColors.ink,
      ),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: AppColors.ink),
      labelSmall: GoogleFonts.ibmPlexMono(
        fontSize: 11,
        color: AppColors.inkSoft,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.paper,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.line),
      ),
    ),
  );
}
