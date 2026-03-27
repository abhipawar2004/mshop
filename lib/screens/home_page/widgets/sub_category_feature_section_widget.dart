import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import '../../../router/app_routes.dart';
import '../../../utils/widgets/custom_shimmer.dart';
import '../../../utils/widgets/custom_sub_category_card.dart';
import '../../product_listing_page/model/product_listing_type.dart';
import '../bloc/sub_category/sub_category_bloc.dart';
import '../bloc/sub_category/sub_category_state.dart';

class SubCategoryFeatureSectionWidget extends StatefulWidget {
  const SubCategoryFeatureSectionWidget({super.key});

  @override
  State<SubCategoryFeatureSectionWidget> createState() => _SubCategoryFeatureSectionWidgetState();
}

class _SubCategoryFeatureSectionWidgetState extends State<SubCategoryFeatureSectionWidget> {

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1200) return 10;
    if (screenWidth >= 800) return 6;
    if (screenWidth >= 600) return 4;
    if (screenWidth >= 400) return 4;
    return 4;
  }

  // Calculate responsive spacing
  double _getSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * 0.04;
  }

  // Calculate responsive padding
  EdgeInsets _getPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.04;
    return EdgeInsets.symmetric(horizontal: horizontalPadding);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubCategoryBloc, SubCategoryState>(
      builder: (BuildContext context, SubCategoryState state) {
        if (state is SubCategoryLoaded) {
          return state.subCategoryData.isNotEmpty
              ? SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    bottom: 10.0.h,
                    top: 10
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.shopByCategories ?? 'Shop by categories',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(8.r),
                        onTap: () {
                          final navigationShell = StatefulNavigationShell.of(context);
                          navigationShell.goBranch(1, initialLocation: false);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          child: Text(
                            AppLocalizations.of(context)?.seeAll ?? 'See All',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 15
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    crossAxisSpacing: _getSpacing(context),
                    mainAxisSpacing: _getSpacing(context),
                    childAspectRatio: 0.62,
                  ),
                  itemCount: state.subCategoryData.length >= 32 ? 32 : state.subCategoryData.length,
                  itemBuilder: (context, index) {
                    final subCategoryData = state.subCategoryData[index];
                    return InkWell(
                      onTap: () {
                        GoRouter.of(context).push(
                            AppRoutes.productListing,
                            extra: {
                              'isTheirMoreCategory': subCategoryData.subcategoryCount! > 0 ? true : false,
                              'title': subCategoryData.title,
                              'logo': subCategoryData.image,
                              'totalProduct': subCategoryData.productCount,
                              'type': ProductListingType.category,
                              'identifier': subCategoryData.slug,
                            }
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: CustomSubCategoryCard(
                        categoryImage: subCategoryData.image!,
                        categoryName: subCategoryData.title!,
                      ),
                    );
                  },
                ),
              ],
            ),
          )
              : const SizedBox.shrink();
        }
        else if (state is SubCategoryLoading) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: _getPadding(context).copyWith(
                    top: 12.0,
                    bottom: 12.0,
                  ),
                  child: ShimmerWidget.rectangular(
                    isBorder: true,
                    height: 18,
                    width: 200,
                    borderRadius: 15,
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: _getPadding(context),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    crossAxisSpacing: _getSpacing(context),
                    mainAxisSpacing: _getSpacing(context),
                    childAspectRatio: 0.65,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return const ResponsiveSubCategoryCardShimmer();
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}


class ResponsiveSubCategoryCardShimmer extends StatelessWidget {
  const ResponsiveSubCategoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                  margin: EdgeInsets.only(bottom: cardHeight * 0.05),
                  child: ShimmerWidget.rectangular(
                    isBorder: true,
                    height: double.infinity,
                    width: double.infinity,
                    borderRadius: borderRadius,
                  ),
                ),
              ),
              // Text Shimmer
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: cardWidth * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShimmerWidget.rectangular(
                        isBorder: true,
                        height: 8,
                        width: double.infinity,
                        borderRadius: 4,
                      ),
                      SizedBox(height: cardHeight * 0.02),
                      ShimmerWidget.rectangular(
                        isBorder: true,
                        height: 8,
                        width: cardWidth * 0.6,
                        borderRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}