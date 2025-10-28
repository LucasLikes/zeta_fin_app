import 'package:flutter/material.dart';

class AppColors {
  // cores padrão
  static const Color primary = Color(0xFF7FE5A8);
  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Color(0xFF121212);

  // método para pegar background baseado no tema
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? backgroundDark
        : backgroundLight;
  }
  // Cores Principais
  static const Color primaryDark = Color(0xFF5FD090);
  static const Color primaryLight = Color(0xFF9FFFB8);
  
  // Background
  static const Color backgroundGradientStart = Color(0xFF7FE5A8);
  static const Color backgroundGradientEnd = Color(0xFF6DD99A);
  
  // Componentes
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color inputBorder = Color(0xFFE0E0E0);
  
  // Textos
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFFBDBDBD);
  
  // Estados
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Sombras e Overlays
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);
  
  // Gráficos
  static const Color chartGreen = Color(0xFF7FE5A8);
  static const Color chartDarkGreen = Color(0xFF5FD090);
  static const Color chartGray = Color(0xFFE0E0E0);
}