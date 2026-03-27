import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/home_page/bloc/brands/brands_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_brands_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/widgets/custom_shimmer.dart';
import '../../product_listing_page/model/product_listing_type.dart';

class BrandsSection extends StatefulWidget {
  final String brandsSectionTitle;
  final String categorySlug;

  const BrandsSection({super.key, required this.brandsSectionTitle, required this.categorySlug});

  @override
  State<BrandsSection> createState() => _BrandsSectionState();
}

class _BrandsSectionState extends State<BrandsSection> {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  bool _scrollForward = true;

  @override
  void initState() {
    super.initState();
    // Start the infinite scroll after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) => _startInfiniteScroll());
  }

  void _startInfiniteScroll() {
    // Cancel any existing timer to avoid duplicates
    _scrollTimer?.cancel();

    // Start a periodic timer to toggle scroll direction
    _scrollTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_scrollController.hasClients) {
        double maxExtent = _scrollController.position.maxScrollExtent;
        double minExtent = _scrollController.position.minScrollExtent;

        if (maxExtent <= 0) {
          return;
        }

        if (_scrollForward) {
          // Scroll to the end
          _scrollController.animateTo(
            maxExtent,
            duration: const Duration(seconds: 12),
            curve: Curves.linear,
          );
        } else {
          // Scroll back to the start
          _scrollController.animateTo(
            minExtent,
            duration: const Duration(seconds: 12),
            curve: Curves.linear,
          );
        }
        // Toggle direction for next cycle
        _scrollForward = !_scrollForward;
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandsBloc, BrandsState>(
      builder: (context, state) {
        if (state is BrandsLoaded) {
          return state.brandsData.isNotEmpty
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
                        widget.brandsSectionTitle,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(8.r),
                        onTap: () {
                          GoRouter.of(context).push(
                            AppRoutes.brandsListPage,
                            extra: {
                              'category-slug': widget.categorySlug
                            }
                          );
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
                SizedBox(
                  height: MediaQueryHelper.screenHeight(context) * 0.145,
                  width: double.infinity,
                  child: ListView.builder(
                    // controller: _scrollController,
                    padding: EdgeInsets.only(
                      left: 10.w,
                      right: 10.w,
                      top: 4.h,
                      bottom: 10.h,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.brandsData.length,
                    itemBuilder: (context, index) {
                      final brandsData = state.brandsData[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 15.0.w),
                        child: GestureDetector(
                          onTap: (){
                            GoRouter.of(context).push(
                              AppRoutes.productListing,
                              extra: {
                                'isTheirMoreCategory': false,
                                'title': brandsData.title,
                                'logo': brandsData.logo,
                                'totalProduct': 10,
                                'type': ProductListingType.brand,
                                'identifier': brandsData.slug,
                              }
                            );
                          },
                          child: CustomBrandsCard(
                            brandName: state.brandsData[index].title ?? 'Brand',
                            brandImage: state.brandsData[index].logo ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
              : const SizedBox.shrink();
        }
        else if (state is BrandsLoading) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 12.0,
                  ),
                  child: ShimmerWidget.rectangular(
                    isBorder: true,
                    height: 18,
                    width: 200,
                    borderRadius: 15,
                  ),
                ),
                SizedBox(
                  height: 105.h,
                  width: double.infinity,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 5,
                      top: 4,
                      bottom: 4,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Column(
                          children: [
                            ShimmerWidget.rectangular(
                              isBorder: true,
                              height: 95,
                              width: 90.w,
                              borderRadius: 15,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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