import 'package:flutter/material.dart';
import 'package:hyper_local/utils/widgets/custom_shape_decoration.dart';

Widget iconBox(IconData icon, Color iconColor) {
  return Container(
    width: 36,
    height: 36,
    decoration: getCustomShapeDecoration(
      color: iconColor,
      radius: 20
    ),
    child: Icon(icon, size: 20,),
  );
}