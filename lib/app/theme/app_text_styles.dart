import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle heading({
    double size = 24,
    FontWeight weight = FontWeight.bold,
    Color? color,
  }) {
    return GoogleFonts.sora(fontSize: size, fontWeight: weight, color: color);
  }

  static TextStyle body({
    double size = 14,
    FontWeight weight = FontWeight.normal,
    Color? color,
  }) {
    return GoogleFonts.dmSans(fontSize: size, fontWeight: weight, color: color);
  }
}
