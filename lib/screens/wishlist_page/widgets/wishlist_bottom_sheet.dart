import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';

import '../../../utils/widgets/custom_toast.dart';
import '../bloc/get_user_wishlist_bloc/get_user_wishlist_bloc.dart';
import '../bloc/get_user_wishlist_bloc/get_user_wishlist_state.dart';
import 'create_wishlist_dialog.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

void openAddToWishlistSheet({
  required BuildContext context,
  required int productId,
  required int productVariantId,
  required int storeId,
  required int wishlistItemId,
}) async {
  context.read<UserWishlistBloc>().add(GetUserWishlistRequest());
  await showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    constraints: const BoxConstraints(maxHeight: 500.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return AddToWishlistSheetBody(
        productId: productId,
        productVariantId: productVariantId,
        storeId: storeId,
        wishlistItemId: wishlistItemId,
      );
    },
  );
}


class AddToWishlistSheetBody extends StatelessWidget {
  final int productId;
  final int productVariantId;
  final int storeId;
  final int wishlistItemId;
  const AddToWishlistSheetBody({
    super.key,
    required this.productId,
    required this.productVariantId,
    required this.storeId,
    required this.wishlistItemId
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context)!.addTo, style: textTheme.titleMedium),
              ),
            ),
            const SizedBox(height: 12),

            // Create new wishlist
            InkWell(
              onTap: () async {
                _showCreateWishlistDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.createNewWishlistTitle,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primaryColor, width: 1.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, size: 18, color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // Wishlist list from Bloc
            Flexible(
              child: BlocBuilder<UserWishlistBloc, UserWishlistState>(
                builder: (context, state) {
                  if (state is UserWishlistLoading) {
                    return SizedBox(
                      height: 150.h,
                      child: CustomCircularProgressIndicator(),
                    );
                  }
                  if (state is UserWishlistFailed) {
                    Navigator.pop(context);
                    ToastManager.show(
                        context: context,
                        message: state.message
                    );

                  }
                  if (state is UserWishlistLoaded) {
                    final items = state.wishlistData;
                    if (items.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(AppLocalizations.of(context)!.noWishlistsYet),
                      );
                    }
                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo){
                        if (scrollInfo is ScrollUpdateNotification &&
                            !state.hasReachedMax &&
                            scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent - 50) {
                          context.read<UserWishlistBloc>().add(
                            GetMoreUserWishlistRequest(),
                          );
                        }
                        return false;
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: state.hasReachedMax ? state.wishlistData.length : state.wishlistData.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          if (index >= state.wishlistData.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CustomCircularProgressIndicator(),
                              ),
                            );
                          }
                          final item = items[index];
                          // final isFav = (item.items.first.isDefault ?? false); // or your field
                          final countText = '${item.itemsCount ?? 0} items';

                          // Check if product is wishlisted - check items array first
                          final bloc = context.read<UserWishlistBloc>();
                          final isWishListedInItems = item.items!.any((wishlistItem) => wishlistItem.product!.id == productId);

                          // Check if there's a pending add operation for THIS specific wishlist
                          // This ensures optimistic updates only affect the wishlist being modified
                          final isPendingAddForThisWishlist = bloc.isAddOperationPending(
                            productId,
                            productVariantId,
                            storeId,
                            item.title ?? ''
                          );

                          // Icon should show as wishlisted if:
                          // 1. Item is in items array (actual data), OR
                          // 2. There's a pending add operation for THIS specific wishlist (optimistic)
                          final isWishListedForIcon = isWishListedInItems || isPendingAddForThisWishlist;

                          // But isWishListed check for actual data (to find item ID) only checks items array
                          final isWishListed = isWishListedInItems;

                          // Find the actual wishlist item ID for this product in this wishlist
                          int? wishlistItemIdForThisWishlist;
                          if (isWishListed && item.items != null) {
                            try {
                              final matchingItem = item.items!.firstWhere(
                                (wishlistItem) => wishlistItem.product!.id == productId,
                              );
                              wishlistItemIdForThisWishlist = matchingItem.id;
                            } catch (e) {
                              wishlistItemIdForThisWishlist = null;
                            }
                          }
                          // If optimistically added to this wishlist, use temporary ID from cache
                          if (wishlistItemIdForThisWishlist == null && isPendingAddForThisWishlist) {
                            final cachedId = bloc.getWishlistItemId(productId, productVariantId, storeId);
                            if (cachedId != null && cachedId == -1) {
                              wishlistItemIdForThisWishlist = -1; // Temporary ID for optimistic add
                            }
                          }

                          return InkWell(
                            onTap: () {
                              if(item.title!.isNotEmpty) {
                                // Use isWishListedForIcon to determine action (includes cache check)
                                if(isWishListedForIcon && wishlistItemIdForThisWishlist != null) {
                                  context.read<UserWishlistBloc>().add(
                                      RemoveItemFromWishlist(
                                          itemId: wishlistItemIdForThisWishlist
                                      )
                                  );
                                  Navigator.of(context).pop();
                                }
                                else {
                                  // Add product to wishlist
                                  context.read<UserWishlistBloc>().add(
                                    AddItemInWishlist(
                                      wishlistTitle: item.title ?? '',
                                      productId: productId,
                                      productVariantId: productVariantId,
                                      storeId: storeId,
                                    ),
                                  );
                                  // Close the bottom sheet immediately after adding
                                  Navigator.of(context).pop();
                                }
                              } else {
                                Navigator.pop(context);
                                ToastManager.show(
                                    context: context,
                                    message: AppLocalizations.of(context)!.somethingWentWrong
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: item.items != null && item.items!.isNotEmpty
                                        ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        item.items!.first.product?.image ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    )
                                        : Icon(
                                      AppConstant.wishListedIcon,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.title ?? '-', style: textTheme.bodyLarge),
                                        const SizedBox(height: 2),
                                        Text(
                                          countText,
                                          style: textTheme.bodySmall?.copyWith(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  BlocBuilder<UserWishlistBloc, UserWishlistState>(
                                    builder: (context, blocState) {
                                      final bloc = context.read<UserWishlistBloc>();
                                      final isAdding = bloc.isAddOperationPending(
                                        productId,
                                        productVariantId,
                                        storeId,
                                        item.title ?? ''
                                      );
                                      final isRemoving = wishlistItemIdForThisWishlist != null
                                          ? bloc.isRemoveOperationPending(wishlistItemIdForThisWishlist)
                                          : false;
                                      final isLoading = isAdding || isRemoving;

                                      return IconButton(
                                        onPressed: isLoading ? null : () {
                                          if(item.title!.isNotEmpty) {
                                            // Use isWishListedForIcon to determine action (includes cache check)
                                            if(isWishListedForIcon && wishlistItemIdForThisWishlist != null) {
                                              context.read<UserWishlistBloc>().add(
                                                  RemoveItemFromWishlist(
                                                    itemId: wishlistItemIdForThisWishlist
                                                  )
                                              );
                                              Navigator.of(context).pop();
                                            }
                                            else {
                                              // Add product to wishlist
                                              context.read<UserWishlistBloc>().add(
                                                AddItemInWishlist(
                                                  wishlistTitle: item.title ?? '',
                                                  productId: productId,
                                                  productVariantId: productVariantId,
                                                  storeId: storeId,
                                                ),
                                              );
                                              // Close the bottom sheet immediately after adding
                                              Navigator.of(context).pop();
                                            }
                                          } else {
                                            Navigator.pop(context);
                                            ToastManager.show(
                                              context: context,
                                              message: AppLocalizations.of(context)!.somethingWentWrong
                                            );
                                          }
                                        },
                                        icon: isLoading
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CustomCircularProgressIndicator(),
                                            )
                                          : Icon(
                                              isWishListedForIcon ? AppConstant.wishListedIcon : AppConstant.notWishListedIcon,
                                              color: isWishListedForIcon ? AppTheme.primaryColor : isDarkMode(context) ? Colors.white38 : Colors.black45,
                                            ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _showCreateWishlistDialog(BuildContext context) async {
    final result = await CreateWishlistDialog.show(context);

    if (result != null && result.isNotEmpty) {
      if (context.mounted) {
        context.read<UserWishlistBloc>().add(CreateNewWishlist(title: result));
      }
    }
  }

}
