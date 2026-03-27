/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_state_bloc/cart_state_bloc.dart';
import '../screens/cart_page/bloc/get_user_cart/get_user_cart_bloc.dart';

class CartService {
  static void updateCartState(BuildContext context, GetUserCartState state) {
    final cartStateBloc = context.read<CartStateBloc>();
    
    if (state is GetUserCartLoaded) {
      if (state.cartData.isNotEmpty) {
        final cartData = state.cartData.first;
        final itemCount = cartData.data?.itemsCount ?? 0;
        final totalQuantity = cartData.data?.totalQuantity ?? 0;

        cartStateBloc.add(UpdateCartVisibility(showViewCart: itemCount > 0));
        cartStateBloc.add(UpdateCartItemCount(itemCount: itemCount));

        if (totalQuantity > 0) {
          cartStateBloc.add(UpdateCartItemText(
            itemText: '$totalQuantity ITEM${totalQuantity > 1 ? 'S' : ''}',
          ));
        }
      } else {
        cartStateBloc.add(UpdateCartVisibility(
          showViewCart: false,
        ));
        cartStateBloc.add(UpdateCartItemCount(itemCount: 0));
        cartStateBloc.add(UpdateCartItemText(itemText: null));
      }
    } else if (state is GetUserCartFailed) {
      cartStateBloc.add(UpdateCartVisibility(showViewCart: false));
    }
  }

  /// Trigger cart animation when first item is added
  static void triggerCartAnimation(BuildContext context) {
    final cartStateBloc = context.read<CartStateBloc>();
    final currentState = cartStateBloc.state;
    
    // Only trigger animation if it hasn't been shown before
    if (currentState is CartStateUpdated && !currentState.hasAnimationBeenShown) {
      cartStateBloc.add(UpdateCartVisibility(showViewCart: true));
    } else if (currentState is! CartStateUpdated) {
      cartStateBloc.add(UpdateCartVisibility(showViewCart: true));
    }
  }
}*/





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_state_bloc/cart_state_bloc.dart';
import '../bloc/user_cart_bloc/user_cart_state.dart';

class CartService {

  /// 🔹 Sync CartStateBloc from LOCAL Hive cart
  static void updateCartFromLocal(
      BuildContext context,
      CartState cartState,
      ) {
    final cartStateBloc = context.read<CartStateBloc>();

    if (cartState is CartLoaded) {
      final items = cartState.items;

      final totalQuantity = items.fold<int>(
        0,
            (sum, item) => sum + item.quantity,
      );

      final itemCount = items.length;

      debugPrint('🛒 Local cart update → items: $itemCount qty: $totalQuantity');

      cartStateBloc.add(
        UpdateCartVisibility(showViewCart: itemCount > 0),
      );

      cartStateBloc.add(
        UpdateCartItemCount(itemCount: itemCount),
      );

      if (totalQuantity > 0) {
        cartStateBloc.add(
          UpdateCartItemText(
            itemText:
            '$totalQuantity ITEM${totalQuantity > 1 ? 'S' : ''}',
          ),
        );
      } else {
        cartStateBloc.add(
          UpdateCartItemText(itemText: null),
        );
      }
    }
  }

  /// 🎯 Trigger animation ONLY on first add
  static void triggerCartAnimationOnFirstAdd(
      BuildContext context,
      CartState current,
      ) {
    if ( current is CartLoaded) {
      if (current.items.isNotEmpty) {
        debugPrint('🎉 Cart animation triggered (first item added)');
        _showCart(context);
      }
    }
  }

  static void _showCart(BuildContext context) {
    final cartStateBloc = context.read<CartStateBloc>();
    cartStateBloc.add(UpdateCartVisibility(showViewCart: true));
  }
}
