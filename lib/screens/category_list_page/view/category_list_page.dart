import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:hyper_local/screens/category_list_page/bloc/all_category_bloc/all_category_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/sub_category/sub_category_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/sub_category/sub_category_event.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/empty_states_page.dart';
import '../../../router/app_routes.dart';
import '../../../utils/widgets/custom_refresh_indicator.dart';
import '../bloc/all_category_bloc/all_category_event.dart';
import '../bloc/all_category_bloc/all_category_state.dart';
import '../widgets/category_grid_widget.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllCategoriesBloc()..add(
        FetchAllCategories(),
      ),
      child: const _CategoryListView(),
    );
  }
}

class _CategoryListView extends StatefulWidget {
  const _CategoryListView();

  @override
  State<_CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<_CategoryListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;

    if (current >= (maxScroll - 200)) {
      context.read<SubCategoryBloc>().add(FetchMoreSubCategory());
    }
  }

  Future<void> _onRefresh() async {
    context.read<AllCategoriesBloc>().add(
      FetchAllCategories(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showViewCart: true,
      onConnectivityRestored: (_) async {
        _onRefresh();
      },
      title: AppLocalizations.of(context)!.categories,
      appBarActions: [
        IconButton(
          onPressed: () {
            GoRouter.of(context).push(AppRoutes.search);
          },
          icon: const Icon(TablerIcons.search),
        )
      ],
      showAppBar: true,
      body: BlocBuilder<AllCategoriesBloc, AllCategoriesState>(
        builder: (context, state) {
          // Loading States (Initial + Refresh)
          if (state is AllCategoriesLoading || state is AllCategoriesInitial) {
            return const Center(
              child: CustomCircularProgressIndicator(),
            );
          }

          // Error State
          if (state is AllCategoriesFailed) {
            return Center(
              child: NoCategoryPage(onRetry: _onRefresh),
            );
          }

          // Loaded State
          if (state is AllCategoriesLoaded) {
            final hasData = state.subCategoryData.isNotEmpty;

            return CustomRefreshIndicator(
              onRefresh: _onRefresh,
              child: hasData
                  ? ListView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                children: [
                  CategoryGridWidget(subCategories: state.subCategoryData),

                  // Load more indicator at bottom
                  if (state.isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(child: CustomCircularProgressIndicator()),
                    ),

                  const SizedBox(height: 70), // Safe bottom padding
                ],
              )
                  : ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Center(child: NoCategoryPage(onRetry: _onRefresh)),
                ],
              ),
            );
          }

          // Fallback (should never hit)
          return const Center(child: CustomCircularProgressIndicator());
        },
      ),
    );
  }
}