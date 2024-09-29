import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme() {
  return ThemeData(
    primaryColor: const Color(0xFF5D7C9A),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF5D7C9A),
      secondary: Color(0xFFC4D5E8),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: Color(0xFFC4D5E8),
      onSurface: Colors.black,
    ),
    dividerColor: const Color(0xFF163840),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color.fromARGB(137, 93, 124, 154),
      textTheme: ButtonTextTheme.normal,
    ),
    fontFamily: GoogleFonts.kanit().fontFamily,
  );
}

ThemeData darkTheme() {
  return ThemeData(
    primaryColor: const Color(0xFF2F2F2F),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2F2F2F),
      secondary: Color(0xFFC4D5E8),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: Color(0xFF5D7C9A),
      onSurface: Colors.black,
    ),
    dividerColor: const Color(0xFF163840),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF5D7C9A),
      textTheme: ButtonTextTheme.accent,
    ),
    fontFamily: GoogleFonts.kanit().fontFamily,
  );
}
