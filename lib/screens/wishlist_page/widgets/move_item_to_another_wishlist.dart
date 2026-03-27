import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';

import '../../../utils/widgets/custom_toast.dart';
import '../bloc/get_user_wishlist_bloc/get_user_wishlist_bloc.dart';
import '../bloc/get_user_wishlist_bloc/get_user_wishlist_state.dart';
import 'create_wishlist_dialog.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

class MoveToWishlistSheetBody extends StatelessWidget {
  final int productId;
  final int productVariantId;
  final int storeId;
  final int currentWishlistId;

  const MoveToWishlistSheetBody({
    super.key,
    required this.productId,
    required this.productVariantId,
    required this.storeId,
    required this.currentWishlistId,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title (Updated for move context)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context)!.moveTo, style: textTheme.titleMedium),
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
                    final allItems = state.wishlistData;
                    final filteredItems = allItems.where((item) => item.id != currentWishlistId).toList();

                    if (filteredItems.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(AppLocalizations.of(context)!.noOtherWishlistsAvailable),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final countText = '${item.itemsCount ?? 0} items';

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pop(item.id);
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
                                    Icons.favorite_border,
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
                              ],
                            ),
                          ),
                        );
                      },
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
        // Create the new wishlist; parent will handle moving the item to it
        context.read<UserWishlistBloc>().add(CreateNewWishlist(title: result));
        // Optionally, pop here or let parent listen for the new ID via Bloc
        Navigator.pop(context, null); // Or handle new ID if your dialog/bloc returns it
      }
    }
  }
}