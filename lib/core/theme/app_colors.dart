import 'package:flutter/material.dart';

final class CategoryColors {
  final Color color50;
  final Color color100;
  final Color color200;
  final Color color300;
  final Color color400;
  final Color color500;
  final Color color600;
  final Color color700;
  final Color color800;
  final Color color900;

  const CategoryColors({
    required this.color50,
    required this.color100,
    required this.color200,
    required this.color300,
    required this.color400,
    required this.color500,
    required this.color600,
    required this.color700,
    required this.color800,
    required this.color900,
  });
}

final class AppColors {
  const AppColors._({
    required this.brand,
    required this.neutral,
    required this.info,
    required this.error,
    required this.success,
    required this.warning,
  });

  final CategoryColors brand;
  final CategoryColors neutral;
  final CategoryColors success;
  final CategoryColors error;
  final CategoryColors warning;
  final CategoryColors info;

  static const light = AppColors._(
    brand: CategoryColors(
      color50: Color(0xFFE6F2FF),
      color100: Color(0xFFB3D9FF),
      color200: Color(0xFF80BFFF),
      color300: Color(0xFF4DA6FF),
      color400: Color(0xFF1A8CFF),
      color500: Color(0xFF0080FF), // Primary Brand Color (Saturated)
      color600: Color(0xFF0073E6),
      color700: Color(0xFF0066CC),
      color800: Color(0xFF0059B3),
      color900: Color(0xFF004080),
    ),
    neutral: CategoryColors(
      color50: Color(0xFFFFFFFF),
      color100: Color(0xFFF8FAFC),
      color200: Color(0xFFF1F5F9),
      color300: Color(0xFFE2E8F0),
      color400: Color(0xFFCBD5E1),
      color500: Color(0xFF94A3B8),
      color600: Color(0xFF64748B),
      color700: Color(0xFF475569),
      color800: Color(0xFF334155),
      color900: Color(0xFF1E293B),
    ),
    success: CategoryColors(
      color50: Color(0xFFE8F5E9),
      color100: Color(0xFFC8E6C9),
      color200: Color(0xFFA5D6A7),
      color300: Color(0xFF81C784),
      color400: Color(0xFF66BB6A),
      color500: Color(0xFF4CAF50),
      color600: Color(0xFF43A047),
      color700: Color(0xFF388E3C),
      color800: Color(0xFF2E7D32),
      color900: Color(0xFF1B5E20),
    ),
    error: CategoryColors(
      color50: Color(0xFFFFEBEE),
      color100: Color(0xFFFFCDD2),
      color200: Color(0xFFEF9A9A),
      color300: Color(0xFFE57373),
      color400: Color(0xFFEF5350),
      color500: Color(0xFFF44336),
      color600: Color(0xFFE53935),
      color700: Color(0xFFD32F2F),
      color800: Color(0xFFC62828),
      color900: Color(0xFFB71C1C),
    ),
    warning: CategoryColors(
      color50: Color(0xFFFFF8E1),
      color100: Color(0xFFFFECB3),
      color200: Color(0xFFFFE082),
      color300: Color(0xFFFFD54F),
      color400: Color(0xFFFFCA28),
      color500: Color(0xFFFFC107),
      color600: Color(0xFFFFB300),
      color700: Color(0xFFFFA000),
      color800: Color(0xFFFF8F00),
      color900: Color(0xFFFF6F00),
    ),
    info: CategoryColors(
      color50: Color(0xFFE0F7FA),
      color100: Color(0xFFB2EBF2),
      color200: Color(0xFF80DEEA),
      color300: Color(0xFF4DD0E1),
      color400: Color(0xFF26C6DA),
      color500: Color(0xFF00BCD4),
      color600: Color(0xFF00ACC1),
      color700: Color(0xFF0097A7),
      color800: Color(0xFF00838F),
      color900: Color(0xFF006064),
    ),
  );

  static const dark = AppColors._(
    brand: CategoryColors(
      color50: Color(0xFF004080),
      color100: Color(0xFF0059B3),
      color200: Color(0xFF0066CC),
      color300: Color(0xFF0073E6),
      color400: Color(0xFF0080FF),
      color500: Color(0xFF1A8CFF), // Primary Brand Color
      color600: Color(0xFF4DA6FF),
      color700: Color(0xFF80BFFF),
      color800: Color(0xFFB3D9FF),
      color900: Color(0xFFE6F2FF),
    ),
    neutral: CategoryColors(
      color50: Color(0xFF11171A), // Very dark blue grey
      color100: Color(0xFF1A2227),
      color200: Color(0xFF263238), // blueGrey 900
      color300: Color(0xFF37474F), // blueGrey 800
      color400: Color(0xFF455A64), // blueGrey 700
      color500: Color(0xFF546E7A), // blueGrey 600
      color600: Color(0xFF607D8B), // blueGrey 500
      color700: Color(0xFF78909C), // blueGrey 400
      color800: Color(0xFF90A4AE), // blueGrey 300
      color900: Color(0xFFCFD8DC), // blueGrey 100
    ),
    success: CategoryColors(
      color50: Color(0xFF1B5E20),
      color100: Color(0xFF2E7D32),
      color200: Color(0xFF388E3C),
      color300: Color(0xFF43A047),
      color400: Color(0xFF4CAF50),
      color500: Color(0xFF66BB6A),
      color600: Color(0xFF81C784),
      color700: Color(0xFFA5D6A7),
      color800: Color(0xFFC8E6C9),
      color900: Color(0xFFE8F5E9),
    ),
    error: CategoryColors(
      color50: Color(0xFFB71C1C),
      color100: Color(0xFFC62828),
      color200: Color(0xFFD32F2F),
      color300: Color(0xFFE53935),
      color400: Color(0xFFF44336),
      color500: Color(0xFFEF5350),
      color600: Color(0xFFE57373),
      color700: Color(0xFFEF9A9A),
      color800: Color(0xFFFFCDD2),
      color900: Color(0xFFFFEBEE),
    ),
    warning: CategoryColors(
      color50: Color(0xFFFF6F00),
      color100: Color(0xFFFF8F00),
      color200: Color(0xFFFFA000),
      color300: Color(0xFFFFB300),
      color400: Color(0xFFFFC107),
      color500: Color(0xFFFFCA28),
      color600: Color(0xFFFFD54F),
      color700: Color(0xFFFFE082),
      color800: Color(0xFFFFECB3),
      color900: Color(0xFFFFF8E1),
    ),
    info: CategoryColors(
      color50: Color(0xFF006064),
      color100: Color(0xFF00838F),
      color200: Color(0xFF0097A7),
      color300: Color(0xFF00ACC1),
      color400: Color(0xFF00BCD4),
      color500: Color(0xFF26C6DA),
      color600: Color(0xFF4DD0E1),
      color700: Color(0xFF80DEEA),
      color800: Color(0xFFB2EBF2),
      color900: Color(0xFFE0F7FA),
    ),
  );

  const AppColors({
    required this.brand,
    required this.neutral,
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
  });
}
