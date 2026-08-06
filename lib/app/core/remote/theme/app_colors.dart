import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color tomato = Color(0xFFFF6347);
  static const Color primary = Color(0xFF333333);
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF333333);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightAsh = Color(0xFFD3D3D3);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkAsh = Color(0xFF444444);
  
  // Dynamic getters based on theme
  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightBackground;
  }
  
  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkText
        : lightText;
  }
  
  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkCard
        : lightCard;
  }
}