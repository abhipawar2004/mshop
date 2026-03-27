import 'package:flutter/material.dart';

Color? getColorFromHex(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) return null;
  try {
    String cleanHex = hexColor.replaceAll('#', '');
    if (cleanHex.length == 6) cleanHex = 'FF$cleanHex';
    return Color(int.parse('0x$cleanHex'));
  } catch (e) {
    return null;
  }
}