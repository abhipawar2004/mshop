import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/my_orders/bloc/delivery_boy_feedback/delivery_boy_feedback_bloc.dart';
import 'package:hyper_local/screens/my_orders/bloc/order_detail/order_detail_bloc.dart';
import 'package:hyper_local/screens/my_orders/model/order_detail_model.dart';
import 'package:hyper_local/screens/my_orders/widgets/delivery_boy_feedback_bottom_sheet.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/product_feedback/product_feedback_bloc.dart';
import 'package:hyper_local/screens/seller_page/bloc/seller_feedback/seller_feedback_bloc.dart';
import 'package:hyper_local/screens/seller_page/widgets/seller_feedback_bottomsheet.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

class RateYourExpPage extends StatefulWidget {
  final String orderSlug;
  final int orderId;

  const RateYourExpPage({
    super.key,
    required this.orderSlug,
    required this.orderId,
  });

  @override
  State<RateYourExpPage> createState() => _RateYourExpPageState();
}

class _RateYourExpPageState extends State<RateYourExpPage> {
  bool _hasChanges =
      false;

  @override
  void initState() {
    super.initState();
    // Fetch order details
    context.read<OrderDetailBloc>().add(
          FetchOrderDetail(orderSlug: widget.orderSlug),
        );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          GoRouter.of(context).pop(_hasChanges);
        }
      },
      child: CustomScaffold(
        showViewCart: false,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: AppLocalizations.of(context)!.rateYourExperience,
        showAppBar: true,
        body: MultiBlocListener(
          listeners: [
            BlocListener<ProductFeedbackBloc, ProductFeedbackState>(
              listener: (context, state) {
                if (state is ProductFeedbackLoaded) {
                  setState(() {
                    _hasChanges = true;
                  });

                  context
                      .read<ProductFeedbackBloc>()
                      .add(ResetProductFeedback());
                  context.read<OrderDetailBloc>().add(
                        FetchOrderDetail(orderSlug: widget.orderSlug),
                      );
                } else if (state is ProductFeedbackFailure) {
                  context
                      .read<ProductFeedbackBloc>()
                      .add(ResetProductFeedback());
                }
              },
            ),
          ],
          child: BlocBuilder<OrderDetailBloc, OrderDetailState>(
            builder: (context, state) {
              if (state is OrderDetailLoading) {
                return const Center(child: CustomCircularProgressIndicator());
              }
              if (state is! OrderDetailLoaded) {
                return Center(
                    child: Text(AppLocalizations.of(context)!.failedToLoadOrderDetails));
              }

              final orderData = state.cartData.first.data;
              final items = orderData?.items ?? [];

              return _buildBody(
                  items, orderData?.items?.length.toString() ?? '0');
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<OrderItems> items, String totalItems) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        children: [
          // Give hero feedback
          Padding(
            padding: EdgeInsets.only(
                left: 12.w, right: 12.w, top: 12.h, bottom: 12.h),
            child: buildDeliveryFeedbackCard(context),
          ),

          // seller wise cards
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
            child: OrderItemsCard(
              items: items,
              totalItems: totalItems,
              orderSlug: widget.orderSlug,
              orderId: widget.orderId,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeliveryFeedbackCard(BuildContext context) {
    final state = context.watch<OrderDetailBloc>().state;
    if (state is! OrderDetailLoaded) return const SizedBox.shrink();

    final orderData = state.cartData.first.data;
    final deliveryBoyId = orderData?.deliveryBoyId;
    final deliveryBoyName = orderData?.deliveryBoyName ?? 'Delivery Hero';
    final bool isFeedbackGiven = orderData?.isDeliveryFeedbackGiven ?? false;
    final DeliveryFeedback? feedback =
        orderData?.deliveryFeedback?.isNotEmpty == true
            ? orderData!.deliveryFeedback!.first
            : null;

    if (deliveryBoyId == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode(context) ? Theme.of(context).colorScheme.onSecondary : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFeedbackGiven
                      ? AppLocalizations.of(context)!.editYourFeedbackFor(deliveryBoyName)
                      : AppLocalizations.of(context)!.giveYourDeliveryHeroFeedback,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final result = await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => BlocProvider.value(
                        value: context.read<DeliveryBoyFeedbackBloc>(),
                        child: DeliveryBoyFeedbackSheet(
                          orderSlug: widget.orderSlug,
                          orderId: widget.orderId,
                          deliveryBoyId: deliveryBoyId,
                          feedbackId: feedback?.id,
                          initialTitle: feedback?.title,
                          initialDescription: feedback?.description,
                          initialRating: feedback?.rating,
                        ),
                      ),
                    );

                    if (result == true) {
                      setState(() => _hasChanges = true);
                      if(context.mounted){
                        context.read<OrderDetailBloc>().add(
                          FetchOrderDetail(orderSlug: widget.orderSlug),
                        );
                      }
                    }
                  },
                  child: Text(
                    isFeedbackGiven ? AppLocalizations.of(context)!.editFeedback : AppLocalizations.of(context)!.leaveFeedback,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CustomImageContainer(
            imagePath: 'assets/images/delivery-feedback.png',
            width: 90,
            height: 90,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

Map<String, List<OrderItems>> groupCartItemsByStore(List<OrderItems> items) {
  Map<String, List<OrderItems>> groupedItems = {};

  for (var item in items) {
    String storeKey = item.store?.name ?? 'Unknown Store';
    if (!groupedItems.containsKey(storeKey)) {
      groupedItems[storeKey] = [];
    }
    groupedItems[storeKey]!.add(item);
  }
  return groupedItems;
}

class OrderItemsCard extends StatelessWidget {
  final List<OrderItems> items;
  final String totalItems;
  final String orderSlug;
  final int orderId;
  final VoidCallback? onAddMoreItems;
  final Color? priceColor;
  final Color? originalPriceColor;

  const OrderItemsCard({
    super.key,
    required this.items,
    required this.totalItems,
    required this.orderSlug,
    required this.orderId,
    this.onAddMoreItems,
    this.priceColor,
    this.originalPriceColor,
  });

  @override
  Widget build(BuildContext context) {
    final groupedItems = groupCartItemsByStore(items);
    return Column(
      children: groupedItems.entries.map((entry) {
        final storeName = entry.key;
        final storeItems = entry.value;

        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            color: isDarkMode(context) ? Theme.of(context).colorScheme.onSecondary : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: StoreCartSection(
            orderId: orderId,
            orderSlug: orderSlug,
            storeName: storeName,
            items: storeItems,
            deliveryTime: totalItems,
            onAddMoreItems: onAddMoreItems,
            priceColor: priceColor,
            originalPriceColor: originalPriceColor,
          ),
        );
      }).toList(),
    );
  }
}

class StoreCartSection extends StatelessWidget {
  final String storeName;
  final String orderSlug;
  final int orderId;
  final List<OrderItems> items;
  final String deliveryTime;
  final VoidCallback? onAddMoreItems;
  final Color? priceColor;
  final Color? originalPriceColor;

  const StoreCartSection({
    super.key,
    required this.storeName,
    required this.orderSlug,
    required this.orderId,
    required this.items,
    required this.deliveryTime,
    this.onAddMoreItems,
    this.priceColor,
    this.originalPriceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStoreHeader(context),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: _buildCartItem(context, item),
          ),
        ),
        _buildProductFeedbackSection(context)
      ],
    );
  }

  Widget _buildStoreHeader(BuildContext context) {
    // Find existing seller feedback
    SellerFeedbackData? existingFeedback;
    final sellerId = items.first.sellerId;
    if (sellerId != null) {
      final orderState = context.watch<OrderDetailBloc>().state;
      if (orderState is OrderDetailLoaded) {
        final orderData = orderState.cartData.first.data;
        final sellerFeedbacks = orderData?.sellerFeedbacks;
        if (sellerFeedbacks != null) {
          for (var sellerFeedback in sellerFeedbacks) {
            if (sellerFeedback.sellerId == sellerId &&
                sellerFeedback.isFeedbackGiven == true &&
                sellerFeedback.feedback != null) {
              existingFeedback = sellerFeedback.feedback;
              break;
            }
          }
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode(context) ? Theme.of(context).colorScheme.onSecondary : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    storeName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: () async {
                  if (sellerId == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ToastManager.show(
                        context: context,
                        message: AppLocalizations.of(context)!.sellerInformationNotAvailable,
                        type: ToastType.error,
                      );
                    });
                    return;
                  }

                  final result = await showModalBottomSheet<bool>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlocProvider.value(
                      value: context.read<SellerFeedbackBloc>(),
                      child: SellerFeedbackSheet(
                        orderSlug: orderSlug,
                        storeName: storeName,
                        sellerId: sellerId,
                        orderItemId: items.first.id!,
                        feedbackId: existingFeedback?.id,
                        initialTitle: existingFeedback?.title,
                        initialDescription: existingFeedback?.description,
                        initialRating: existingFeedback?.rating,
                      ),
                    ),
                  );

                  if (result == true) {
                    if(context.mounted){
                      context
                          .read<OrderDetailBloc>()
                          .add(FetchOrderDetail(orderSlug: orderSlug));
                    }
                  }
                },
                child: Text(
                  existingFeedback != null
                      ? AppLocalizations.of(context)!.editSellerFeedback
                      : AppLocalizations.of(context)!.leaveSellerFeedback,
                  style: const TextStyle(fontSize: 14, color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          Text(
            '${items.length} Product${items.length != 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: isTablet(context) ? 18 : 12.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, OrderItems item) {
    final isLastItem = items.indexOf(item) == items.length - 1;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 0.5),
          bottom: isLastItem
              ? BorderSide(color: Colors.grey[200]!, width: 0.5)
              : BorderSide.none,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Opacity(
            opacity: item.status == 'rejected' ? 0.2 : 1.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProductImage(item.product!.image!),
                SizedBox(width: 10.w),
                Expanded(child: _buildProductInfo(item, context)),
              ],
            ),
          ),
          SizedBox(height: 5.h),
          if (item.status == 'rejected')
            Text(
              AppLocalizations.of(context)!.productNotApprovedBySeller,
              style: TextStyle(color: Colors.red),
            )
        ],
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomImageContainer(
          imagePath: imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildProductInfo(OrderItems item, BuildContext context) {
    return SizedBox(
      width: 125.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.variant!.title!,
            style: TextStyle(
              fontSize: isTablet(context) ? 18 : 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppTheme.fontFamily,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProductFeedbackSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GestureDetector(
        onTap: () async {
          await GoRouter.of(context).push(
            AppRoutes.rateYourExpComments,
            extra: {
              "orderSlug": orderSlug,
              "items": items,
            },
          );
        },
        child: Text(
          AppLocalizations.of(context)!.leaveItemFeedback,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}
