import 'package:flutter/material.dart';

class AppText {
  /// EB Garamond SemiBold: judul
  static TextStyle serif(double size,
          {Color color = Colors.white,
          FontWeight weight = FontWeight.w600,
          double? height,
          double? letterSpacing}) =>
      TextStyle(
          fontFamily: 'EBGaramond',
          fontSize: size,
          fontWeight: weight,
          color: color,
          height: height,
          letterSpacing: letterSpacing);

  /// Poppins: teks UI
  static TextStyle sans(double size,
          {Color color = Colors.white,
          FontWeight weight = FontWeight.w400,
          double? height,
          double? letterSpacing}) =>
      TextStyle(
          fontFamily: 'Poppins',
          fontSize: size,
          fontWeight: weight,
          color: color,
          height: height,
          letterSpacing: letterSpacing);
}
