import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import '../../../router/app_routes.dart';
import '../../../utils/widgets/custom_sub_category_card.dart';
import '../../home_page/model/sub_category_model.dart';
import '../../product_listing_page/model/product_listing_type.dart';

class CategoryGridWidget extends StatelessWidget {
  final List<SubCategoryData> subCategories;
  final EdgeInsets padding;
  final double spacing;

  const CategoryGridWidget({
    super.key,
    required this.subCategories,
    this.padding = const EdgeInsets.all(10.0),
    this.spacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {

    int getCrossAxisCount(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth >= 1200) return 10;
      if (screenWidth >= 800) return 6;
      if (screenWidth >= 600) return 4;
      if (screenWidth >= 400) return 4;
      return 4;
    }

    double getSpacing(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      return screenWidth * 0.04;
    }

    return Padding(
        padding: padding,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getCrossAxisCount(context),
            crossAxisSpacing: getSpacing(context),
            mainAxisSpacing: getSpacing(context),
            childAspectRatio: 0.62,
          ),
          itemCount: subCategories.length,
          itemBuilder: (context, index) {
            final category = subCategories[index];
            return InkWell(
              onTap: () {
                GoRouter.of(context).push(AppRoutes.productListing, extra: {
                  'isTheirMoreCategory':
                      category.subcategoryCount! > 0 ? true : false,
                  'title': category.title,
                  'logo': category.image,
                  'totalProduct': category.productCount,
                  'type': ProductListingType.category,
                  'identifier': category.slug,
                });
              },
              child: CustomSubCategoryCard(
                categoryImage: category.image!,
                categoryName: category.title!,
              ),
            );
          },
        ));
  }
}

class CategoryCardWithFixedColor extends StatelessWidget {
  final String name;
  final String imagePath;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final bool isNetworkImage;

  const CategoryCardWithFixedColor({
    super.key,
    required this.name,
    required this.imagePath,
    required this.backgroundColor,
    this.onTap,
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomImageContainer(
                        imagePath: imagePath,
                        fit: BoxFit.contain,
                      )
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
