import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:hyper_local/config/theme.dart';

import '../../../config/constant.dart';
import '../model/user_wishlist_model.dart';
import 'edit_wishlist_dialog.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistData wishlistItem;
  final Function(String)? onEdit;
  final Function()? onDelete;
  final VoidCallback onTap;

  const WishlistItemCard({
    super.key,
    required this.wishlistItem,
    this.onEdit,
    this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: wishlistItem.items != null && wishlistItem.items!.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  wishlistItem.items!.last.product?.image ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[400],
                  ),
                ),
              )
                  : Icon(
                AppConstant.wishListedIcon,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(width: 16),

            // Wishlist info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wishlistItem.title ?? 'Unnamed Wishlist',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${wishlistItem.itemsCount ?? 0} items',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[600]!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Popup menu for actions
            PopupMenuButton<String>(
              onSelected: (String value) {
                switch (value) {
                  case 'edit':
                    _showEditWishlistDialog(context);
                    break;
                  case 'delete':
                    _showDeleteConfirmationDialog(context);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.edit),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              child: SizedBox(
                height: 30,
                width: 30,
                child: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditWishlistDialog(BuildContext context) async {
    final result = await EditWishlistDialog.show(
      context,
      initialValue: wishlistItem.title,
    );
    if (result != null && result.isNotEmpty) {
      onEdit?.call(result);
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 50.h),
          title: Column(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(100)
                ),
                child: Icon(TablerIcons.trash, color: AppTheme.errorColor, size: 28.r,),
              ),
              SizedBox(height: 10.h,),
              Text('Delete ${wishlistItem.title}'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                'Are you sure you want to delete this wishlist?',
                style: TextStyle(fontSize: 14,),
              ),
              Text(
                textAlign: TextAlign.center,
                'You will be responsible for fulfilling it.',
                style: TextStyle(fontSize: 14,),
              ),
              SizedBox(height: 8),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete?.call();
              },
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}