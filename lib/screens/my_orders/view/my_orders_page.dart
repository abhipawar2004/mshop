import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/my_orders/bloc/get_my_order/get_my_order_bloc.dart';
import 'package:hyper_local/screens/my_orders/bloc/get_my_order/get_my_order_event.dart';
import 'package:hyper_local/screens/my_orders/bloc/get_my_order/get_my_order_state.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_refresh_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/empty_states_page.dart';
import '../../../config/constant.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/my_order_card.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetMyOrderBloc>().add(FetchMyOrder());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CustomScaffold(
      showViewCart: false,
      title: l10n?.myOrders,
      showAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: BlocBuilder<GetMyOrderBloc, GetMyOrderState>(
        builder: (context, state) {
          if (state is GetMyOrderLoading) {
            return const Center(
              child: CustomCircularProgressIndicator(),
            );
          } else if (state is GetMyOrderLoaded) {
            if (state.myOrderData.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n?.noOrdersYet ?? 'No orders yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
            return CustomRefreshIndicator(
              onRefresh: () async {
                context.read<GetMyOrderBloc>().add(FetchMyOrder());
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo){
                  if (scrollInfo is ScrollUpdateNotification &&
                      !state.hasReachedMax &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 50) {
                    context.read<GetMyOrderBloc>().add(
                      FetchMoreMyOrder(),
                    );
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.hasReachedMax ? state.myOrderData.length : state.myOrderData.length + 1,
                  itemBuilder: (context, index) {
                    if(index >= state.myOrderData.length) {
                      return SizedBox(
                        height: 80,
                        child: CustomCircularProgressIndicator(),
                      );
                    }
                    final order = state.myOrderData[index];
                    return GestureDetector(
                      onTap: (){
                        GoRouter.of(context).push(
                          AppRoutes.orderDetail,
                          extra: {
                            'order-slug': order.slug
                          }
                        );
                      },
                      child: OrderDeliveryCard(
                        status: capitalizeFirstLetter(removeUnderscores(order.status ?? 'Pending')),
                        dateTime: formatDateTime(DateTime.tryParse(order.createdAt.toString())),
                        productImages: _extractProductImages(order),
                        onRateOrder: () {
                          final storeMap = {
                            "orderSlug": order.slug,
                            "orderId": order.id,
                          };

                          GoRouter.of(context).push(
                            AppRoutes.rateYourExp,
                            extra: storeMap,
                          );
                        },
                        onTrackOrder: (){
                          GoRouter.of(context)
                              .push(AppRoutes.deliveryTracking, extra: {'order-slug': order.slug});
                        },
                        isDelivered: order.status == 'delivered',
                        isDeliveryBoyAssigned: order.deliveryBoyId != null,
                        orderSlug: order.slug!,
                      ),
                    );
                  },
                ),
              ),
            );
          }
          else if (state is GetMyOrderFailed) {
            return NoOrderPage(
              onRetry: (){
                context.read<GetMyOrderBloc>().add(FetchMyOrder());
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<String> _extractProductImages(dynamic order) {
    List<String> images = [];

    try {
      if (order.items != null && order.items is List) {
        for (var item in order.items) {
          if (item.product?.image != null) {
            images.add(item.product.image);
          }
        }
      }
    } catch (e) {
      // Return empty list if extraction fails
    }

    return images;
  }

}