import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_ease/theme/colors.dart';

/// Base text theme of the app.
final TextTheme textTheme = TextTheme(
  titleLarge: GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  ),
  titleMedium: GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  ),
  titleSmall: GoogleFonts.poppins(
    fontSize: 16.5,
    fontWeight: FontWeight.w600,
  ),
  displayLarge: GoogleFonts.poppins(
    fontSize: 21,
    fontWeight: FontWeight.w400,
  ),
  displaySmall: GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
  ),
  displayMedium: GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w400,
  ),
  bodySmall: GoogleFonts.poppins(
    fontSize: 13.5,
    fontWeight: FontWeight.w300,
  ),
);

/// Theme for the app.
abstract class AppTheme {
  /// Private constructor for [AppTheme].
  AppTheme._();

  /// Base light theme of the app.
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.scaffoldBackGround,
    primaryColor: AppColors.black,
    textTheme: textTheme,
    appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.scaffoldBackGround,
        foregroundColor: AppColors.black,
        elevation: 0),
    colorScheme: const ColorScheme.light(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.tabPink,
        foregroundColor: AppColors.white,
        textStyle: textTheme.titleSmall,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.tabPink,
        foregroundColor: AppColors.white,
        textStyle: textTheme.titleSmall,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.pink),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        elevation: 0,
        selectedItemColor: AppColors.black,
        unselectedItemColor: AppColors.grey,
    ),
  );
}
