import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';

class CustomBrandsCard extends StatelessWidget {
  final String brandName;
  final String brandImage;
  const CustomBrandsCard({super.key, required this.brandName, required this.brandImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isTablet(context) ? 65.w : 100.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2), width: 1, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
            blurRadius: 0.5,
            spreadRadius: 0
          )
        ]
      ),
      padding: EdgeInsets.all(10),

      child: CustomImageContainer(imagePath: brandImage, fit: BoxFit.contain,)
    );
  }
}
