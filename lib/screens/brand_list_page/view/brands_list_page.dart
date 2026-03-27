import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/screens/home_page/bloc/brands/brands_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/empty_states_page.dart';

import '../../../l10n/app_localizations.dart';
import '../../../router/app_routes.dart';
import '../../../utils/widgets/custom_brands_card.dart';
import '../../../utils/widgets/custom_circular_progress_indicator.dart';
import '../../product_listing_page/model/product_listing_type.dart';

class BrandsListPage extends StatefulWidget {
  final String categorySlug;
  const BrandsListPage({super.key, required this.categorySlug});

  @override
  State<BrandsListPage> createState() => _BrandsListPageState();
}

class _BrandsListPageState extends State<BrandsListPage> {

  @override
  void initState() {
    // TODO: implement initState
    context.read<BrandsBloc>().add(FetchBrands(categorySlug: widget.categorySlug));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: AppLocalizations.of(context)!.brand,
      showAppBar: true,
      showViewCart: true,
      body: BlocBuilder<BrandsBloc, BrandsState>(
        builder: (context, state){
          if(state is BrandsLoading) {
            return CustomCircularProgressIndicator();
          }
          if(state is BrandsLoaded) {

            if (state.brandsData.isEmpty) {
              return const NoProductPage();
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 6 : 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.brandsData.length,
                itemBuilder: (context, index) {
                  final brand = state.brandsData[index];
                  return GestureDetector(
                    onTap: (){
                      GoRouter.of(context).push(
                          AppRoutes.productListing,
                          extra: {
                            'isTheirMoreCategory': false,
                            'title': brand.title,
                            'logo': brand.logo,
                            'totalProduct': 10,
                            'type': ProductListingType.brand,
                            'identifier': brand.slug,
                          }
                      );
                    },
                    child: CustomBrandsCard(
                      brandName: brand.title ?? 'Brand',
                      brandImage: brand.logo ?? '',
                    ),
                  );
                },
              ),
            );

          }
          if( state is BrandsFailed) {
            return NoProductPage();
          }
          return const Center(child: CustomCircularProgressIndicator());
        }
      )
    );
  }
}
