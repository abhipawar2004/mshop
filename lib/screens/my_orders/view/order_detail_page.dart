import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/cart_page/widgets/bill_summary_widget.dart';
import 'package:hyper_local/screens/my_orders/bloc/download_invoice/download_invoice_bloc.dart';
import 'package:hyper_local/screens/my_orders/bloc/get_my_order/get_my_order_bloc.dart';
import 'package:hyper_local/screens/my_orders/bloc/get_my_order/get_my_order_event.dart';
import 'package:hyper_local/screens/my_orders/bloc/return_order_item/return_order_item_bloc.dart';
import 'package:hyper_local/screens/my_orders/model/order_detail_model.dart';
import 'package:hyper_local/screens/my_orders/widgets/return_dialog.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/product_feedback/product_feedback_bloc.dart';
import 'package:hyper_local/utils/widgets/animated_button.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:hyper_local/utils/widgets/whole_page_progress.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/theme.dart';
import '../../../utils/widgets/dialog_box_animation.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/order_detail/order_detail_bloc.dart';
import '../widgets/order_detail_widget.dart';
import '../widgets/order_items_card.dart';
import '../widgets/order_note_display_widget.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderSlug;
  const OrderDetailPage({super.key, required this.orderSlug});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {

  @override
  void initState() {
    apiCall();
    super.initState();
  }

  Future<void> apiCall() async {
    context.read<OrderDetailBloc>().add(FetchOrderDetail(orderSlug: widget.orderSlug));
  }

  Future<void> _launchPdf(String pdfUrl) async {
    final Uri url = Uri.parse(pdfUrl);

    if (!await canLaunchUrl(url)) {
      log('Cannot launch URL: $url');
      return;
    }

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  void _showReturnDialog(List<OrderItems> items, String orderSlug, bool isDelivered) {
    openSlideUpDialog(
      context,
      ReturnItemsDialog(
        items: items,
        orderSlug: orderSlug,
        isDelivered: isDelivered
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReturnOrderItemBloc, ReturnOrderItemState>(
          listener: (context, ReturnOrderItemState state) {
            if(state is ReturnOrderItemSuccess) {
              ToastManager.show(
                context: context,
                message: state.message,
              );
              apiCall();
              context.read<GetMyOrderBloc>().add(RefreshMyOrders());
            } else if(state is ReturnOrderItemFailed){
              ToastManager.show(
                context: context,
                message: state.error,
              );
            }
          }
        )
      ],
      child: BlocConsumer<DownloadInvoiceBloc, DownloadInvoiceState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Stack(
            children: [
              Builder(
                builder: (context) {
                  return CustomScaffold(
                    showViewCart: false,
                    title: AppLocalizations.of(context)!.orderSummary,
                    showAppBar: true,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                    body: BlocBuilder<OrderDetailBloc, OrderDetailState>(
                      builder: (context, state) {
                        if (state is OrderDetailLoaded) {
                          final orderData = state.cartData.first.data;
                          return SingleChildScrollView(
                            child: RefreshIndicator(
                              onRefresh: apiCall,
                              child: Padding(
                                padding: EdgeInsets.all(12.0.h),
                                child: Column(
                                  children: [
                                    OrderItemsCard(
                                      items: orderData!.items!,
                                      totalItems: orderData.items!.length.toString(),
                                      priceColor: Colors.black,
                                      originalPriceColor: Colors.grey[500],
                                    ),
                                    if(orderData.status == 'delivered')...[
                                      rateWidget(orderData.id! ,orderData.slug!, orderData),
                                      SizedBox(height: 10.h),
                                    ],
                                    trackDeliveryAndReturnProduct(
                                      orderSlug: orderData.slug!,
                                      items: orderData.items ?? [],
                                      isDelivered: orderData.status == 'delivered' ? true : false,
                                      isDeliveryBoyAssigned: orderData.deliveryBoyId != null,
                                    ),
                                    // SizedBox(height: 10.h),
                                    OrderNoteDisplayWidget(
                                      orderNote: orderData.orderNote ?? '',
                                    ),
                                    // SizedBox(height: 10.h),
                                    BillSummaryWidget(
                                      itemsOriginalPrice: double.parse(orderData.totalPayable!),
                                      itemsDiscountedPrice: double.parse(orderData.subtotal!),
                                      itemsSavings: 0,
                                      deliveryChargeOriginal: double.parse(orderData.deliveryCharge!),
                                      handlingCharge: double.parse(orderData.handlingCharges!),
                                      perStoreDropOffFees: double.parse(orderData.perStoreDropOffFee!),
                                      grandTotal: double.parse(orderData.finalTotal!),
                                      totalSavings: 0,
                                      isFromOrderDetail: true,
                                      downloadInvoice: () {
                                        _launchPdf(orderData.invoice!);
                                      },
                                      promoCode: orderData.promoCode,
                                      promoDiscount: double.parse(orderData.promoDiscount ?? '0.0'),
                                    ),
                                    SizedBox(height: 10.h),
                                    OrderDetailCard(
                                      orderId: orderData.id.toString(),
                                      paymentMethod: orderData.paymentMethod!,
                                      deliveryAddress: orderData.shippingAddress1!,
                                      orderDate: orderData.createdAt!,
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        else if (state is OrderDetailLoading) {
                          return CustomCircularProgressIndicator();
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  );
                }
              ),
              if (state is DownloadInvoiceLoading) WholePageProgress(),
            ],
          );
        },
      ),
    );
  }

  Widget rateWidget(int orderId, String orderSlug, OrderDetailData? orderData) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return Text(
                    l10n?.howWasYourShoppingExperience ?? 'How was your shopping experience?',
                    style: TextStyle(fontSize: 12.sp),
                  );
                }
              ),
            ),
            SizedBox(width: 5.w),
            CustomButton(
              onPressed: () async {
                final storeMap = {
                  "orderSlug": orderSlug,
                  "orderId": orderId,
                };

                final result = await GoRouter.of(context).push(
                  AppRoutes.rateYourExp,
                  extra: storeMap,
                );

                if (result == true && mounted) {
                  context.read<ProductFeedbackBloc>().add(ResetProductFeedback());

                  await apiCall();

                  if (mounted) {
                    final l10n = AppLocalizations.of(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n?.orderDetailsRefreshed ?? 'Order details refreshed'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
              child: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return Text(l10n?.rateOrder ?? 'Rate Order');
                }
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget trackDeliveryAndReturnProduct(
      {
        required String orderSlug,
        required List<OrderItems> items,
        required bool isDelivered,
        required bool isDeliveryBoyAssigned,
      }) {
    return Row(
      children: [
        Expanded(
          child: AnimatedButton(
            onTap: () {
              _showReturnDialog(items, orderSlug, isDelivered);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: isDarkMode(context) ? Theme.of(context).colorScheme.surface
                    : Colors.white,
              ),

              margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      isDelivered ? AppLocalizations.of(context)!.returnItem : AppLocalizations.of(context)!.cancelItem,
                      style: TextStyle(fontSize: isTablet(context) ? 18 : 12.sp, color: Colors.red),
                    ),
                    Icon(
                      Directionality.of(context) == TextDirection.ltr ?
                      TablerIcons.chevron_right : TablerIcons.chevron_left,
                      size: 20,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),

        if(!isDelivered && isDeliveryBoyAssigned)...[
          SizedBox(width: 12.w,),
          Expanded(
            child: AnimatedButton(
              onTap: () {
                GoRouter.of(context)
                    .push(AppRoutes.deliveryTracking, extra: {'order-slug': orderSlug});
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!.trackYourDelivery,
                            style: TextStyle(
                              fontSize: isTablet(context) ? 18 : 12.sp,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
