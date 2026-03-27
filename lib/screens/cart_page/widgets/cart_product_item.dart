import 'dart:async';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/save_for_later_page/bloc/save_for_later_bloc/save_for_later_event.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_dotted_divider.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import 'package:open_filex/open_filex.dart';
import '../../../bloc/user_cart_bloc/user_cart_bloc.dart';
import '../../../bloc/user_cart_bloc/user_cart_event.dart';
import '../../../bloc/user_cart_bloc/user_cart_state.dart';
import '../../../services/user_cart/cart_validation.dart';
import '../../../utils/widgets/custom_toast.dart';
import '../../../utils/widgets/debounce_function.dart';
import '../../../utils/widgets/price_utils.dart';
import '../../save_for_later_page/bloc/save_for_later_bloc/save_for_later_bloc.dart';
import '../bloc/attachment/attachment_bloc.dart';
import '../model/get_cart_model.dart';
import '../../../l10n/app_localizations.dart';
import 'package:path/path.dart' as path;


class CartItemAttachment {
  final String id;
  final String fileName;
  final String filePath;
  final String fileType;
  final int fileSize;

  CartItemAttachment({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
  });
}

class StoreGroup {
  final String name;
  final String? slug;
  final String? logo;
  final bool? storeStatus;
  final List<CartItems> items;

  StoreGroup({
    required this.name,
    required this.slug,
    required this.logo,
    this.storeStatus = false,
    required this.items,
  });
}

List<StoreGroup> groupCartItemsByStore(List<CartItems> items) {
  Map<String, StoreGroup> groupedItems = {};

  for (var item in items) {
    String storeKey = item.store?.name ?? 'Unknown Store';
    if (!groupedItems.containsKey(storeKey)) {
      groupedItems[storeKey] = StoreGroup(
        name: storeKey,
        slug: item.store?.slug,
        logo: item.product!.image,
        storeStatus: item.store!.status!.isOpen,
        items: [],
      );
    }
    groupedItems[storeKey]!.items.add(item);
  }

  return groupedItems.values.toList();
}

class CartWidget extends StatelessWidget {
  final List<CartItems> items;
  final String deliveryTime;
  final Function(String itemId, int newQuantity) onQuantityChanged;
  final Function(String itemId) onRemoveItem;
  final VoidCallback? onAddMoreItems;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final TextStyle? headerTextStyle;
  final TextStyle? deliveryTextStyle;
  final Color? quantityButtonColor;
  final Color? priceColor;
  final Color? originalPriceColor;
  final BorderRadius? borderRadius;
  final int? totalItem;

  final int? addressId;
  final String? promoCode;
  final bool? rushDelivery;
  final bool? useWallet;

  const CartWidget({
    super.key,
    required this.items,
    required this.deliveryTime,
    required this.onQuantityChanged,
    required this.onRemoveItem,
    this.onAddMoreItems,
    this.padding,
    this.backgroundColor,
    this.headerTextStyle,
    this.deliveryTextStyle,
    this.quantityButtonColor,
    this.priceColor,
    this.originalPriceColor,
    this.borderRadius,
    this.totalItem,
    this.addressId,
    this.promoCode,
    this.rushDelivery,
    this.useWallet,
  });

  @override
  Widget build(BuildContext context) {
    // Group items by store
    final groupedStores = groupCartItemsByStore(items);
    return Column(
      children: groupedStores.map((storeGroup) {
        return Container(
          margin: EdgeInsets.only(bottom: 9.h),
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              StoreCartSection(
                storeName: storeGroup.name,
                items: storeGroup.items,
                storeStatus: storeGroup.storeStatus ?? false,
                deliveryTime: deliveryTime,
                onQuantityChanged: onQuantityChanged,
                onRemoveItem: onRemoveItem,
                onAddMoreItems: onAddMoreItems,
                padding: padding,
                backgroundColor: backgroundColor,
                headerTextStyle: headerTextStyle,
                deliveryTextStyle: deliveryTextStyle,
                quantityButtonColor: quantityButtonColor,
                priceColor: priceColor,
                originalPriceColor: originalPriceColor,
                borderRadius: borderRadius,
                totalItems: totalItem,
                addressId: addressId,
                promoCode: promoCode,
                useWallet: useWallet,
                rushDelivery: rushDelivery,
              ),
              buildDottedLine(context),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).push(
                      AppRoutes.nearbyStoreDetails,
                      extra: {
                        'store-slug': storeGroup.slug,
                        'store-name': storeGroup.name,
                      },
                    );
                  },
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r)
                  ),
                  child: Ink(
                    child: Opacity(
                      opacity: (storeGroup.storeStatus == false) ? 0.3 : 1,
                      child: SizedBox(
                        height: 55,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              TablerIcons.circle_plus,
                              size: isTablet(context) ? 28 : 18.r,
                              color: (storeGroup.storeStatus == false) ? Theme.of(context).colorScheme.outlineVariant : AppTheme.primaryColor,
                            ),
                            SizedBox(width: 5.w,),
                            Text(
                              AppLocalizations.of(context)!.addMoreItemsTapped,
                              style: TextStyle(
                                  color: (storeGroup.storeStatus == false) ? Theme.of(context).colorScheme.outlineVariant : AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: isTablet(context) ? 20 : 14.sp
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Store-specific cart section widget
class StoreCartSection extends StatefulWidget {
  final String storeName;
  final List<CartItems> items;
  final bool storeStatus;
  final String deliveryTime;
  final Function(String itemId, int newQuantity) onQuantityChanged;
  final Function(String itemId) onRemoveItem;
  final VoidCallback? onAddMoreItems;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final TextStyle? headerTextStyle;
  final TextStyle? deliveryTextStyle;
  final Color? quantityButtonColor;
  final Color? priceColor;
  final Color? originalPriceColor;
  final BorderRadius? borderRadius;
  final int? totalItems;

  final int? addressId;
  final String? promoCode;
  final bool? rushDelivery;
  final bool? useWallet;

  const StoreCartSection({
    super.key,
    required this.storeName,
    required this.items,
    required this.storeStatus,
    required this.deliveryTime,
    required this.onQuantityChanged,
    required this.onRemoveItem,
    this.onAddMoreItems,
    this.padding,
    this.backgroundColor,
    this.headerTextStyle,
    this.deliveryTextStyle,
    this.quantityButtonColor,
    this.priceColor,
    this.originalPriceColor,
    this.borderRadius,
    this.totalItems,
    this.addressId,
    this.promoCode,
    this.rushDelivery,
    this.useWallet,
  });

  @override
  State<StoreCartSection> createState() => _StoreCartSectionState();
}

class _StoreCartSectionState extends State<StoreCartSection> {
  final Debounce _debounce = Debounce(delay: const Duration(milliseconds: 500));
  Timer? _apiThrottleTimer;
  // Change from List to single nullable
  Map<int, CartItemAttachment?> itemAttachments = {};

  @override
  void dispose() {
    _apiThrottleTimer?.cancel();
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStoreHeader(context),
        ...widget.items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: _buildCartItem(context, item),
        )),
      ],
    );
  }

  Widget _buildStoreHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode(context) ? Theme.of(context).colorScheme.secondary : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.storeName,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: widget.headerTextStyle ??
                  TextStyle(
                    fontSize: isTablet(context) ? 24 : 15.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontFamily,
                  ),
            ),
          ),
          SizedBox(width: 10,),
          if(!widget.storeStatus)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(TablerIcons.x, color: AppTheme.errorColor, size: 16,),
                SizedBox(width: 5,),
                Text(
                  'Currently closed',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ],
            )
          else
            Text(
            '${widget.items.length} Product${widget.items.length != 1 ? 's' : ''}',
            style: widget.deliveryTextStyle ??
                TextStyle(
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

  Widget _buildCartItem(BuildContext context, CartItems item) {
    final attachment = itemAttachments[item.id];

    return Dismissible(
      key: Key(item.id.toString()),
      direction: DismissDirection.horizontal,

      // Backgrounds (same as before)
      background: Container(
        color: AppTheme.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            const Icon(Icons.bookmark_add, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)?.saveForLater ?? "Save for Later",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: AppTheme.errorColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context)?.delete ?? "Delete",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.delete, color: Colors.white, size: 28),
          ],
        ),
      ),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {

          // Save for Later → trigger API, but don't dismiss yet
          context.read<SaveForLaterBloc>().add(SaveForLaterRequest(
            cartItemId: item.id!,
            cartItemName: item.product!.name!,
          ));
          return false; // Don't dismiss
        }

        if (direction == DismissDirection.endToStart) {
          // Show confirmation dialog
          final bool? shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              return AlertDialog(
                title: Text(l10n?.removeItem ?? "Remove item"),
                content: Text(
                  l10n?.areYouSureYouWantToRemoveItemFromCart(item.product!.name!) ??
                      "Are you sure you want to remove ${item.product!.name} from cart?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n?.cancel ?? "Cancel"),
                  ),
                  CustomButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l10n?.delete ?? "Delete"),
                  ),
                ],
              );
            },
          );

          if (shouldDelete == true) {
            if(context.mounted) {
              context.read<CartBloc>().add(RemoveFromCart(
                  cartKey: '${item.product!.id}_${item.productVariantId}', context: context,
                addressId: widget.addressId,
                promoCode: widget.promoCode,
                useWallet: widget.useWallet,
                rushDelivery: widget.rushDelivery,
                isFromCartPage: true
              ));
            }
            // Trigger remove API
            widget.onRemoveItem(item.id.toString());
            return false; // Don't dismiss yet — wait for Bloc success
          }
        }

        return false;
      },

      // REMOVE onDismissed completely → we control dismissal manually
      // onDismissed: null, // ← Remove this entirely

      child: Opacity(
        opacity: (widget.storeStatus == false) ? 0.3 : 1,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: isDarkMode(context) ? Colors.grey.shade800 : Colors.grey[200]!, width: 0.5)),
          ),
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProductImage(item.product!.image!),
                  SizedBox(width: 10.w),
                  Expanded(child: _buildProductInfo(item)),
                  SizedBox(width: 10.w),
                  _buildQuantityControl(item),
                  SizedBox(width: 12.w),
                  _buildPriceSection(item),
                ],
              ),

              if(item.product!.isAttachmentRequired!)
              // Attachments section
                if (attachment != null) ...[
                  SizedBox(height: 12.h),
                  _buildAttachmentsSection(item, attachment),
                ] else ...[
                  SizedBox(height: 8.h),
                  _buildAddAttachmentButton(item),
                ]


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomImageContainer(imagePath: imageUrl, fit: BoxFit.contain,),
      ),
    );
  }

  Widget _buildProductInfo(CartItems item) {
    return SizedBox(
      width: 125.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.product!.name!,
            style: TextStyle(
                fontSize: isTablet(context) ? 20 : 12.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.fontFamily
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item.variant!.title!,
            style: TextStyle(
                fontSize: isTablet(context) ? 15 : 8.sp,
                fontWeight: FontWeight.w300,
                fontFamily: AppTheme.fontFamily
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControl(CartItems item) {
    final String cartKey = '${item.product!.id}_${item.productVariantId}';

    return BlocSelector<CartBloc, CartState, int?>(
      selector: (state) {
        if (state is CartLoaded) {
          final localItem = state.items.firstWhereOrNull(
                (i) => i.cartKey == cartKey,
          );
          return localItem?.quantity;
        }
        return null; // will fallback to item.quantity
      },
      builder: (context, localQty) {
        // Fallback to server/API quantity if local not found yet
        final   displayQty = localQty ?? item.quantity ?? 1;

        if (item.variant!.stock! <= 0) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Out of Stock',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          );
        }

        return Container(
          height: 34,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Minus / Remove
              _buildQtyBtn(
                icon: Icons.remove,
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (displayQty <= item.product!.quantityStepSize!) {
                    // Remove from local
                    context.read<CartBloc>().add(RemoveFromCart(
                        cartKey: cartKey,
                        context: context,
                      addressId: widget.addressId,
                      promoCode: widget.promoCode,
                      useWallet: widget.useWallet,
                      rushDelivery: widget.rushDelivery,
                        isFromCartPage: true
                    ));
                    // Trigger server remove
                    // widget.onRemoveItem(item.id.toString());
                  } else {
                    final newQty = displayQty - item.product!.quantityStepSize!;
                    // Update local
                    context.read<CartBloc>().add(UpdateCartQty(
                        cartKey: cartKey,
                        quantity: newQty,
                        cartItemId: item.id,
                        context: context,
                      addressId: widget.addressId,
                      promoCode: widget.promoCode,
                      useWallet: widget.useWallet,
                      rushDelivery: widget.rushDelivery,
                        isFromCartPage: true
                    ));
                    // Trigger server update (in background)
                    // widget.onQuantityChanged(item.id.toString(), newQty);
                  }
                },
              ),

              // Quantity display
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '$displayQty',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Plus
              _buildQtyBtn(
                icon: Icons.add,
                onTap: () {
                  HapticFeedback.lightImpact();
                  final newQty = displayQty + item.product!.quantityStepSize!;
                  // Update local
                  final error =
                  CartValidation.validateProductAddToCart(
                    context: context,
                    requestedQuantity:
                    displayQty + item.product!.quantityStepSize!,
                    minQty: item.product!.minimumOrderQuantity!,
                    maxQty: item.product!.totalAllowedQuantity!,
                    stock: item.variant!.stock!,
                    isStoreOpen: item.product!.storeStatus!.isOpen!,
                  );

                  if (error != null) {
                    ToastManager.show(
                        context: context,
                        message: error,
                        type: ToastType.error);
                    return;
                  } else {
                    context.read<CartBloc>().add(UpdateCartQty(
                        cartKey: cartKey,
                        quantity: newQty,
                        cartItemId: item.id,
                        context: context,

                      addressId: widget.addressId,
                      promoCode: widget.promoCode,
                      useWallet: widget.useWallet,
                      rushDelivery: widget.rushDelivery,
                        isFromCartPage: true
                    ));
                    // Trigger server update
                    // widget.onQuantityChanged(item.id.toString(), newQty);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQtyBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(
          icon,
          size: 18,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildPriceSection(CartItems item) {
    final String cartKey = '${item.product!.id}_${item.productVariantId}';

    return BlocSelector<CartBloc, CartState, int?>(
      selector: (state) {
        if (state is CartLoaded) {
          final localItem = state.items.firstWhereOrNull(
                (i) => i.cartKey == cartKey,
          );
          return localItem?.quantity;
        }
        return null;
      },
      builder: (context, localQty) {
        // Use local quantity if available, fallback to server quantity
        final displayQty = localQty ?? item.quantity ?? 1;

        // Parse prices safely
        final double regularPrice = item.variant?.price?.toDouble() ?? 0.0;
        final double salePrice = item.variant?.specialPrice?.toDouble() ?? 0.0;

        // Determine if there's a meaningful discount
        final bool hasRealDiscount = salePrice > 0 &&
            salePrice < regularPrice &&
            (regularPrice - salePrice).abs() > 0.01; // avoid floating-point noise

        // What price to show as main (bold) price
        final double mainPrice = hasRealDiscount ? salePrice : regularPrice;

        // Format prices (assuming you have a helper like PriceUtils.formatPrice)
        final String formattedMain = PriceUtils.formatPrice(mainPrice * displayQty);
        final String formattedRegular = PriceUtils.formatPrice(regularPrice * displayQty);

        return SizedBox(
          width: isTablet(context) ? 80 : 70, // slightly wider to avoid overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show struck-through original price ONLY when there's real discount
              if (hasRealDiscount) ...[
                Text(
                  formattedRegular,
                  style: TextStyle(
                    fontSize: isTablet(context) ? 16 : 11.sp,
                    fontFamily: AppTheme.fontFamily,
                    color: widget.originalPriceColor ?? Colors.grey[600],
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.grey[600],
                    decorationThickness: 1.5,
                  ),
                ),
                SizedBox(height: 2.h),
              ],

              // Main price (bold) – use sale price when discounted, regular otherwise
              Text(
                formattedMain,
                style: TextStyle(
                  fontSize: isTablet(context) ? 20 : 14.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildAttachmentsSection(CartItems item, CartItemAttachment? attachment) {
    if (attachment == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10
      ),
      decoration: BoxDecoration(
        color: isDarkMode(context) ? Colors.grey.shade800.withValues(alpha: 0.4) : Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(TablerIcons.paperclip, size: 16, color: Colors.grey.shade500,),
              SizedBox(width: 5,),
              Text(
                'Attachment',
                style: TextStyle(
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () => _openAttachment(attachment),
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(top: 8, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  _buildFileIcon(attachment.fileType),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attachment.fileName,
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1),
                        Text(
                          _formatFileSize(attachment.fileSize),
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _removeAttachment(item.id!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(TablerIcons.x, size: 18, color: AppTheme.errorColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _showAttachmentOptions(item),
            child: Row(
              children: [
                Icon(TablerIcons.plus, size: 16, color: AppTheme.primaryColor,),
                SizedBox(width: 5,),
                Text(
                  'Replace attachment',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icon(TablerIcons.file_type_pdf, color: Colors.red, size: 28);
      case 'doc':
      case 'docx':
        return Icon(TablerIcons.file_type_docx, color: Colors.blue, size: 28);
      case 'image':
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icon(TablerIcons.photo, color: Colors.green, size: 28);
      default:
        return Icon(TablerIcons.file, color: Colors.grey, size: 28);
    }
  }

  Widget _buildAddAttachmentButton(CartItems item) {
    final attachment = itemAttachments[item.id];
    final hasAttachment = attachment != null;

    return Align(
      alignment: AlignmentGeometry.topLeft,
      child: InkWell(
        onTap: () {
          if (hasAttachment) {
            _openAttachment(attachment);
          } else {
            _showAttachmentOptions(item);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                hasAttachment ? TablerIcons.eye : TablerIcons.paperclip,
                size: 16,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 8),
              Text(
                hasAttachment ? 'View Attachment' : 'Add Attachment',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAttachmentOptions(CartItems item) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Attachment',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Choose file type to upload',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 20),
                _buildAttachmentOption(
                  icon: TablerIcons.photo,
                  label: AppLocalizations.of(context)!.imagesLabel,
                  subtitle: AppLocalizations.of(context)!.imagesSubtitle,
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _pickFile(item, 'image');
                  },
                ),
                SizedBox(height: 12),
                _buildAttachmentOption(
                  icon: TablerIcons.file_type_pdf,
                  label: AppLocalizations.of(context)!.pdfDocumentLabel,
                  subtitle: AppLocalizations.of(context)!.pdfDocumentSubtitle,
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _pickFile(item, 'pdf');
                  },
                ),
                SizedBox(height: 12),
                _buildAttachmentOption(
                  icon: TablerIcons.file_type_docx,
                  label: AppLocalizations.of(context)!.wordDocumentLabel,
                  subtitle: AppLocalizations.of(context)!.wordDocumentSubtitle,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _pickFile(item, 'docx');
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile(CartItems item, String fileType) async {
    FilePickerResult? result;

    if (fileType == 'image') {
      result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
    } else if (fileType == 'pdf') {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
    } else if (fileType == 'docx') {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx'],
        allowMultiple: false,
      );
    }

    if (result == null || result.files.isEmpty) {
      // User canceled
      return;
    }

    final platformFile = result.files.first;

    if (platformFile.path == null) {
      if(mounted) {
        ToastManager.show(
          context: context,
          message: 'Could not get file path',
          type: ToastType.error,
        );
      }
      return;
    }

    final filePath = platformFile.path!;
    final fileName = platformFile.name;
    final fileSize = platformFile.size;
    final extension = path.extension(fileName).toLowerCase().replaceAll('.', '');

    String detectedType = 'other';
    if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
      detectedType = 'image';
    }
    else if (extension == 'pdf'){
      detectedType = 'pdf';
    } else if (['doc', 'docx'].contains(extension)) {
      detectedType = 'docx';
    }

    final attachment = CartItemAttachment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fileName: fileName,
      filePath: filePath,
      fileType: detectedType,
      fileSize: fileSize,
    );

    if(mounted){
      context.read<AttachmentBloc>().add(AddOrUpdateAttachment(
        productId: item.productId!,
        attachment: attachment,
      ));
    }

    setState(() {
      itemAttachments[item.id!] = attachment;
    });

  }

  Future<void> _openAttachment(CartItemAttachment attachment) async {
    try {
      final result = await OpenFilex.open(attachment.filePath);

      if (result.type != ResultType.done) {
        if(mounted) {
          ToastManager.show(
            context: context,
            message: 'Cannot open file: ${result.message}',
            type: ToastType.error,
          );
        }
      }
    } catch (e) {
      if(mounted){
        ToastManager.show(
          context: context,
          message: 'Error opening file: $e',
          type: ToastType.error,
        );
      }
    }
  }

  void _removeAttachment(int itemId) {
    context.read<AttachmentBloc>().add(RemoveAttachment(
      productId: itemId,
    ));

    setState(() {
      itemAttachments.remove(itemId);
    });
    // ToastManager.show(
    //   context: context,
    //   message: 'Attachment removed',
    // );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
