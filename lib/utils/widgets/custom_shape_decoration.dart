import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ShapeDecoration getCustomShapeDecoration({
  Color? color,
  List<BoxShadow>? shadow,
  double radius = 30.0,
}) {
  return ShapeDecoration(
    color: color,
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(radius.r),
    ),
    shadows: shadow,
  );
}


