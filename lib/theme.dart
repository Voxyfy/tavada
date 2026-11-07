import 'package:flutter/material.dart';

/// Tasarım belgesindeki (design/ana-ekranlar.png) renkler.
abstract final class AppColors {
  static const background = Color(0xFFF5EFE6);
  static const card = Color(0xFFFBF8F3);
  static const ink = Color(0xFF1C1917);
  static const muted = Color(0xFF57534E);
  static const line = Color(0xFFD9D0C4);
  // Turuncu yalnızca ekrandaki tek ana düğmede kullanılır; seçili durumlar siyah.
  static const accent = Color(0xFFC2410C);
}

/// Bricolage değişken yazı tipi; kalınlık eksenini doğrudan veriyoruz çünkü
/// tek dosyalı değişken fontta FontWeight her platformda eksene eşlenmiyor.
TextStyle display(double size, {double weight = 800}) => TextStyle(
  fontFamily: 'Bricolage',
  fontSize: size,
  height: 1.05,
  letterSpacing: -size * 0.03,
  color: AppColors.ink,
  fontVariations: [FontVariation('wght', weight)],
);

TextStyle body(double size, {double weight = 400, Color color = AppColors.ink}) =>
    TextStyle(fontFamily: 'Inter', fontSize: size, color: color, fontVariations: [FontVariation('wght', weight)]);

ThemeData buildTheme() => ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    surface: AppColors.background,
    primary: AppColors.accent,
  ),
  fontFamily: 'Inter',
  splashFactory: InkSparkle.splashFactory,
);
