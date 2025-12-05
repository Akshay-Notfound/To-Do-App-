import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Typography: Outfit (headings) + Inter (body)
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      // Display - Largest text (Outfit)
      displayLarge: GoogleFonts.outfit(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 45,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w600,
      ),

      // Headline - Page titles, sections (Outfit)
      headlineLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),

      // Title - Card titles, dialogs (Outfit)
      titleLarge: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),

      // Body - Content, descriptions (Inter)
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),

      // Label - Buttons, chips (Inter)
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4), // M3 Purple
      brightness: Brightness.light,
    ),
    textTheme: _buildTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
      margin: EdgeInsets.zero,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD0BCFF), // M3 Purple Light
      brightness: Brightness.dark,
      surface: const Color(0xFF121212), // True Black for OLED
    ),
    textTheme: _buildTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
      margin: EdgeInsets.zero,
    ),
  );
}
