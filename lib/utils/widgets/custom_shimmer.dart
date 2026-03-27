import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final ShapeBorder shapeBorder;
  final bool isBorder;
  final double? borderRadius;

  ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    this.height = 150,
    this.borderRadius,
    required this.isBorder,
  }) : shapeBorder = RoundedRectangleBorder(
      borderRadius: isBorder ? BorderRadius.circular(borderRadius ?? 15) : BorderRadius.zero,
  );

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
    required this.isBorder,
    this.borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}