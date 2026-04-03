import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Colors ──────────────────────────────────────────────────────────
  static const kBg = Color(0xFF0D1117);
  static const kSurface = Color(0xFF161B22);
  static const kCard = Color(0xFF1C2128);
  static const kBorder = Color(0xFF30363D);
  static const kAccent = Color(0xFF58A6FF);
  static const kAccentGreen = Color(0xFF3FB950);
  static const kAccentOrange = Color(0xFFD29922);
  static const kAccentRed = Color(0xFFF85149);
  static const kTextPrimary = Color(0xFFE6EDF3);
  static const kTextSecondary = Color(0xFF8B949E);
  static const kTextMuted = Color(0xFF484F58);

  // Risk colors
  static const kLow = Color(0xFF3FB950);
  static const kMedium = Color(0xFFD29922);
  static const kHigh = Color(0xFFF85149);

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kBg,
      colorScheme: const ColorScheme.dark(
        primary: kAccent,
        secondary: kAccentGreen,
        surface: kSurface,
        error: kAccentRed,
      ),
      textTheme:
          GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          color: kTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.inter(
          color: kTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(color: kTextPrimary),
        bodyMedium: GoogleFonts.inter(color: kTextSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: kTextPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
        iconTheme: const IconThemeData(color: kTextSecondary),
      ),
      cardTheme: CardThemeData(
        color: kCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: kBorder, width: 0.8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kAccent, width: 1.5),
        ),
        labelStyle: const TextStyle(color: kTextSecondary),
        hintStyle: const TextStyle(color: kTextMuted),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: kCard,
        selectedColor: kAccent.withValues(alpha: 0.2),
        labelStyle: const TextStyle(color: kTextPrimary, fontSize: 12),
        side: const BorderSide(color: kBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: kAccent,
        unselectedLabelColor: kTextMuted,
        indicatorColor: kAccent,
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: kCard,
        contentTextStyle: GoogleFonts.inter(color: kTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(color: kBorder, thickness: 0.8),
    );
  }
}
