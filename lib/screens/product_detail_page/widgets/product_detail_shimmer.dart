import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/utils/widgets/custom_shimmer.dart';

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget.rectangular(
                          height: 25,
                          isBorder: true,
                        ),
                        SizedBox(height: 6,),
                        ShimmerWidget.rectangular(
                          height: 25,
                          isBorder: true,
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 25,),
                  ShimmerWidget.rectangular(
                    height: 25,
                    isBorder: true,
                    width: 80,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  ShimmerWidget.rectangular(
                    height: 25,
                    isBorder: true,
                    width: 60,
                  ),
                  SizedBox(width: 5,),
                  ShimmerWidget.rectangular(
                    height: 25,
                    isBorder: true,
                    width: 60,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            productListShimmer(3)
          ],
        ),
      ),
    );
  }


}


Widget productListShimmer(int crossAxisCount) {
  return Padding(
    padding: EdgeInsetsGeometry.directional(
      start: 14.w,
      end: 8.w,
      top: 8.h,
      bottom: 8.h,
    ),
    child: GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 70),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 6.h,
        mainAxisExtent: crossAxisCount == 2 ? 180.h : 220.h,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget.rectangular(
              isBorder: true,
              height: 130,
              width: 130,
              borderRadius: 15,
            ),
            const SizedBox(height: 10.0),
            ShimmerWidget.rectangular(
              isBorder: true,
              height: 15,
              width: 130,
              borderRadius: 15,
            ),
            const SizedBox(height: 2.0),
            ShimmerWidget.rectangular(
              isBorder: true,
              height: 15,
              width: 130,
              borderRadius: 15,
            ),
            const SizedBox(height: 2.0),
            ShimmerWidget.rectangular(
              isBorder: true,
              height: 15,
              width: 60,
              borderRadius: 15,
            ),
            const SizedBox(height: 2.0),
            ShimmerWidget.rectangular(
              isBorder: true,
              height: 15,
              width: 100,
              borderRadius: 15,
            ),
            const SizedBox(height: 2.0),
            ShimmerWidget.rectangular(
              isBorder: true,
              height: 15,
              width: 80,
              borderRadius: 15,
            ),
          ],
        );
      },
    ),
  );
}