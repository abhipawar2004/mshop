import 'package:flutter/material.dart';
import '../../config/settings_data_instance.dart';
import '../../l10n/app_localizations.dart';

class CartValidation {
  CartValidation._();

  /// PRODUCT-LEVEL VALIDATIONS
  /// Used when adding/updating a single product in cart
  static String? validateProductAddToCart({
    required BuildContext context,
    required int requestedQuantity,
    required int minQty,
    required int maxQty,
    required int stock,
    bool isStoreOpen = true,
  }) {
    final l10n = AppLocalizations.of(context)!;

    // Out of stock
    if (stock <= 0) {
      return l10n.outOfStock;
    }

    // Store closed
    if (!isStoreOpen) {
      return l10n.looksLikeTheStoreCatchingSomeRest;
    }

    // Below minimum quantity
    if (requestedQuantity < minQty) {
      return l10n.minimumQuantityRequired(minQty);
    }

    // Exceeds max allowed per product
    if (requestedQuantity > maxQty) {
      return l10n.maximumQuantityAllowed(maxQty);
    }

    // Exceeds available stock
    if (requestedQuantity > stock) {
      return l10n.onlyXItemsInStock(stock);
    }

    return null; // Valid
  }

  static String? validateBeforeAddToCart({
    required BuildContext context,
    required int currentCartItemCount,        // total number of items currently in cart (sum of quantities)
    required int requestedAddQuantity,        // how many of this product the user wants to add now
    required Set<int> currentStoreIdsInCart,  // set of store IDs already present in cart
    required int thisProductStoreId,          // store ID of the product being added
  }) {
    final l10n = AppLocalizations.of(context)!;
    final system = SettingsData.instance.system!;

    final newTotalItemsCount = currentCartItemCount + requestedAddQuantity;

    // 1. Check maximum items allowed in cart (global limit)
    if (newTotalItemsCount > system.maximumItemsAllowedInCart) {
      final remaining = system.maximumItemsAllowedInCart - currentCartItemCount;
      if (remaining <= 0) {
        return l10n.youHaveReachedMaximumLimitOfTheCart;
      }
      return l10n.cannotAddMoreThanXItems(remaining);
    }

    if(currentStoreIdsInCart.isNotEmpty) {
      if (system.checkoutType == 'single_store' && currentStoreIdsInCart.first != thisProductStoreId) {
        return l10n.onlyOneStoreAtATime;
      }
    }

    // 2. Multi-store restriction — only if checkout type enforces single store


    // All checks passed
    return null;
  }

  /// CART-LEVEL VALIDATIONS
  /// Used before checkout or when showing warnings
  static String? validateCartForCheckout({
    required BuildContext context,
    required double cartTotal,
    required int totalItemsCount,
    required Set<int> storeIds,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final system = SettingsData.instance.system!;

    // Minimum cart amount
    if (cartTotal < system.minimumCartAmount) {
      final minAmount = system.minimumCartAmount;
      return l10n.minimumCartAmountRequired(minAmount - cartTotal, minAmount);
    }

    // Maximum items in cart
    if (totalItemsCount > system.maximumItemsAllowedInCart) {
      return l10n.youHaveReachedMaximumLimitOfTheCart;
    }

    // Multi-store restriction (if your app supports only single store)
    if (system.checkoutType == 'single_store' && storeIds.length > 1) {
      return l10n.onlyOneStoreAtATime;
    }

    return null;
  }

  /// Helper: Get user-friendly stock message (not error, just info)
  static String getStockMessage({
    required int stock,
    required BuildContext context,
  }) {
    final l10n = AppLocalizations.of(context)!;

    if (stock <= 0) {
      return l10n.outOfStock;
    } else if (stock <= 5) {
      return l10n.onlyFewLeft(stock);
    }
    return l10n.inStock;
  }
}