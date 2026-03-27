import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:hyper_local/model/user_cart_model/user_cart.dart';
import 'package:hyper_local/model/user_cart_model/cart_sync_action.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/screens/product_detail_page/model/product_detail_model.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import '../../bloc/user_cart_bloc/user_cart_bloc.dart';
import '../../bloc/user_cart_bloc/user_cart_event.dart';
import '../../bloc/user_cart_bloc/user_cart_state.dart';
import '../../services/user_cart/cart_validation.dart';
import 'custom_toast.dart';

void showVariantBottomSheet({
  required List<ProductVariants> variantsList,
  required ProductData productData,
  required String productImage,
  required int quantityStepSize,
  required BuildContext context,
  int? addressId,
  String? promoCode,
  bool? rushDelivery,
  bool? useWallet,
  bool? isFromCartPage,
}) {
  // Get storeId from the first variant (assuming all variants belong to the same store)
  final storeId = variantsList.isNotEmpty ? variantsList.first.storeId : null;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    useRootNavigator: true,
    builder: (BuildContext bottomSheetContext) {
      return VariantSelectionBottomSheet(
        variants: variantsList,
        productData: productData,
        productTitle: 'Product Variants',
        productImage: productImage,
        width: MediaQuery.of(bottomSheetContext).size.width,
        height: MediaQuery.of(bottomSheetContext).size.height,
        storeId: storeId,
        onVariantSelected: (ProductVariants selectedVariant) {},
        onClose: () {
          GoRouter.of(context).pop();
        },
        addressId: addressId,
        promoCode: promoCode,
        rushDelivery: rushDelivery,
        useWallet: useWallet,
        isFromCartPage: isFromCartPage,
      );
    },
  );
}

class VariantSelectionBottomSheet extends StatefulWidget {
  final List<ProductVariants> variants;
  final ProductData productData;
  final String productImage;
  final String productTitle;
  final Function(ProductVariants)? onVariantSelected;
  final double? width;
  final double? height;
  final int? storeId;
  final VoidCallback? onClose;
  final int? addressId;
  final String? promoCode;
  final bool? rushDelivery;
  final bool? useWallet;
  final bool? isFromCartPage;

  const VariantSelectionBottomSheet({
    super.key,
    required this.variants,
    required this.productData,
    required this.productImage,
    required this.productTitle,
    this.onVariantSelected,
    this.width,
    this.height,
    this.storeId,
    this.onClose,
    this.addressId,
    this.promoCode,
    this.rushDelivery,
    this.useWallet,
    this.isFromCartPage
  });

  @override
  State<VariantSelectionBottomSheet> createState() =>
      _VariantSelectionBottomSheetState();
}

class _VariantSelectionBottomSheetState
    extends State<VariantSelectionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.height! * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Select variant',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),

          // Variants List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, bottom: 40),
              itemCount: widget.variants.length,
              separatorBuilder: (context, index) => SizedBox.shrink(),
              itemBuilder: (context, index) {
                return _buildVariantItem(widget.variants[index],
                    widget.productData.mainImage, widget.productData);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantItem(
      ProductVariants variant, String mainImage, ProductData product) {
    String? imageUrl;
    if (variant.image.isNotEmpty && variant.image != '') {
      imageUrl = variant.image;
    } else if (mainImage.isNotEmpty && mainImage != '') {
      imageUrl = mainImage;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CustomImageContainer(
                        imagePath: imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder:
                            Center(child: CustomCircularProgressIndicator()),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.grey[400],
                        size: 24,
                      ),
                    ),
            ),

            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variant.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withValues(alpha: 0.6),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Price
                  Row(
                    children: [
                      Text(
                        '${AppConstant.currency}${(variant.specialPrice).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // Original Price (if special price exists)
                      if (variant.specialPrice < variant.price)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '${AppConstant.currency}${variant.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Add Button / Stepper
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  final cartItem =
                      _getCartItem(state, variant.id, widget.storeId ?? 0);
                  final isInCart = cartItem != null;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    width: isInCart ? 80 : 70, // Adjust width
                    height: 32,
                    decoration: BoxDecoration(
                      color: isInCart ? AppTheme.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.85, end: 1.0)
                                .animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: isInCart
                          ? _QuantityStepperInner(
                              key: const ValueKey('stepper_inner'),
                              quantity: cartItem.quantity,
                              currentLocalQty: cartItem.quantity,
                              stepSize: product.quantityStepSize,
                              isStoreOpen: product.storeStatus?.isOpen ?? false,
                              stock: variant.stock,
                              minQty: product.minimumOrderQuantity,
                              totalAllowedQuantity:
                                  product.totalAllowedQuantity,
                              onIncrement: () async {
                                await HapticFeedback.lightImpact();
                                if (context.mounted) {
                                  final error =
                                  CartValidation.validateProductAddToCart(
                                    context: context,
                                    requestedQuantity:
                                    cartItem.quantity + product.quantityStepSize,
                                    minQty: product.minimumOrderQuantity,
                                    maxQty: product.totalAllowedQuantity,
                                    stock: variant.stock,
                                    isStoreOpen: product.storeStatus!.isOpen,
                                  );

                                  if (error != null) {
                                    ToastManager.show(
                                        context: context,
                                        message: error,
                                        type: ToastType.error);
                                    return;
                                  } else {
                                    context.read<CartBloc>().add(
                                      UpdateCartQty(
                                          cartKey:  cartItem.cartKey,
                                          quantity:  cartItem.quantity + product.quantityStepSize,
                                          cartItemId:  cartItem.serverCartItemId,
                                          context:  context,
                                          isFromCartPage:  widget.isFromCartPage,
                                          useWallet:  widget.useWallet,
                                          rushDelivery:  widget.rushDelivery,
                                          addressId:  widget.addressId,
                                          promoCode:  widget.promoCode
                                      ),
                                    );

                                    // Trigger server update
                                    // widget.onQuantityChanged(item.id.toString(), newQty);
                                  }


                                }
                              },
                              onDecrement: () async {
                                await HapticFeedback.lightImpact();
                                if (cartItem.quantity > product.quantityStepSize) {
                                  if (context.mounted) {
                                    context.read<CartBloc>().add(
                                          UpdateCartQty(
                                              cartKey:  cartItem.cartKey,
                                              quantity:  cartItem.quantity - product.quantityStepSize,
                                              cartItemId:  cartItem.serverCartItemId,
                                              context: context,isFromCartPage:  widget.isFromCartPage,
                                              useWallet:  widget.useWallet,
                                              rushDelivery:  widget.rushDelivery,
                                              addressId:  widget.addressId,
                                              promoCode:  widget.promoCode
                                          ),
                                        );
                                  }
                                } else {
                                  if (context.mounted) {
                                    context.read<CartBloc>().add(
                                          RemoveFromCart(
                                              cartKey:  cartItem.cartKey,context:  context,
                                              isFromCartPage:  widget.isFromCartPage,
                                              useWallet:  widget.useWallet,
                                              rushDelivery:  widget.rushDelivery,
                                              addressId:  widget.addressId,
                                              promoCode:  widget.promoCode
                                          ),
                                        );
                                  }
                                }
                              },
                            )
                          : _AddButtonInner(
                              key: const ValueKey('add_button_inner'),
                              currentLocalQty: cartItem?.quantity ?? 0,
                              stepSize: product.quantityStepSize,
                              isStoreOpen: product.storeStatus?.isOpen ?? false,
                              stock: variant.stock,
                              minQty: product.minimumOrderQuantity,
                              totalAllowedQuantity:
                                  product.totalAllowedQuantity,
                              onTap: () async {
                                if (widget.storeId == null) {
                                  Navigator.pop(context);
                                  return;
                                }

                                // final isLoggedIn =
                                //     await AuthGuard.ensureLoggedIn(context);
                                // if (!isLoggedIn) {
                                //   return;
                                // }
                                final newItem = UserCart(
                                    productId: widget.productData.id.toString(),
                                    variantId: variant.id.toString(),
                                    variantName: variant.title,
                                    vendorId: widget.storeId.toString(),
                                    name: widget.productTitle,
                                    image: imageUrl ?? '',
                                    price: variant.specialPrice > 0
                                        ? variant.specialPrice.toDouble()
                                        : variant.price.toDouble(),
                                    originalPrice: variant.price.toDouble(),
                                    quantity:
                                        widget.productData.quantityStepSize,
                                    minQty:
                                        widget.productData.minimumOrderQuantity,
                                    maxQty:
                                        widget.productData.totalAllowedQuantity,
                                    isOutOfStock: variant.stock <= 0,
                                    isSynced: false,
                                    updatedAt: DateTime.now(),
                                    syncAction: CartSyncAction.add);
                                if (context.mounted) {
                                  context
                                      .read<CartBloc>()
                                      .add(AddToCart(
                                    item: newItem,
                                    context:  context,
                                    isFromCartPage:  widget.isFromCartPage,
                                    useWallet:  widget.useWallet,
                                    rushDelivery:  widget.rushDelivery,
                                    addressId:  widget.addressId,
                                    promoCode:  widget.promoCode
                                  ));
                                }
                              },
                              opacity: 1.0,
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  UserCart? _getCartItem(CartState state, int variantId, int storeId) {
    if (state is CartLoaded) {
      try {
        return state.items.firstWhere(
          (item) =>
              int.parse(item.variantId) == variantId &&
              int.parse(item.vendorId) == storeId,
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}

class _AddButtonInner extends StatelessWidget {
  final VoidCallback? onTap;
  final double opacity;
  final int currentLocalQty;
  final int stepSize;
  final int minQty;
  final int totalAllowedQuantity;
  final int stock;
  final bool isStoreOpen;

  const _AddButtonInner({
    required Key key,
    required this.onTap,
    required this.opacity,
    required this.currentLocalQty,
    required this.stepSize,
    required this.minQty,
    required this.totalAllowedQuantity,
    required this.stock,
    required this.isStoreOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: () {
          final error = CartValidation.validateProductAddToCart(
            context: context,
            requestedQuantity: currentLocalQty + stepSize,
            minQty: minQty,
            maxQty: totalAllowedQuantity,
            stock: stock,
            isStoreOpen: isStoreOpen,
          );
          if (error != null) {
            ToastManager.show(
                context: context, message: error, type: ToastType.error);
            return;
          } else {
            onTap!();
          }
        },
        child: Text(
          AppLocalizations.of(context)?.add ?? 'Add',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}

class _QuantityStepperInner extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int currentLocalQty;
  final int stepSize;
  final int minQty;
  final int totalAllowedQuantity;
  final int stock;
  final bool isStoreOpen;

  const _QuantityStepperInner({
    required Key key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.currentLocalQty,
    required this.stepSize,
    required this.minQty,
    required this.totalAllowedQuantity,
    required this.stock,
    required this.isStoreOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: onDecrement,
          child: Icon(
            TablerIcons.minus,
            size: 16.r,
            color: Colors.white,
          ),
        ),
        Text(
          quantity.toString(),
          style: TextStyle(
            fontSize: isTablet(context) ? 18 : 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            final error = CartValidation.validateProductAddToCart(
              context: context,
              requestedQuantity: currentLocalQty + stepSize,
              minQty: minQty,
              maxQty: totalAllowedQuantity,
              stock: stock,
              isStoreOpen: isStoreOpen,
            );
            if (error != null) {
              ToastManager.show(
                  context: context, message: error, type: ToastType.error);
              return;
            } else {
              onIncrement();
            }
          },
          child: Icon(
            TablerIcons.plus,
            size: 16.r,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
