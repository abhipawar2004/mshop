import 'package:flutter/material.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';

class CustomSubCategoryCard extends StatelessWidget {
  final String categoryImage;
  final String categoryName;

  const CustomSubCategoryCard({
    super.key,
    required this.categoryName,
    required this.categoryImage
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the available space from grid
        final cardWidth = constraints.maxWidth;
        final cardHeight = constraints.maxHeight;
        final borderRadius = cardWidth * 0.12;

        return SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4.0),
                  child: CustomImageContainer(imagePath:categoryImage, fit: BoxFit.cover, )
                ),
              ),
              SizedBox(height: 5,),
              Expanded(
                flex: 3,
                child: categoryNameWidget(
                    categoryName: categoryName,
                  cardWidth: cardWidth
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget categoryNameWidget ({
    required String categoryName, required double cardWidth}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: cardWidth * 0.05),
      child: Text(
        categoryName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: _getResponsiveFontSize(cardWidth),
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  double _getResponsiveFontSize(double cardWidth) {
    // Calculate font size based on card width
    if (cardWidth >= 120) return 16;
    if (cardWidth >= 100) return 15;
    if (cardWidth >= 80) return 14;
    return 14;
  }
}
