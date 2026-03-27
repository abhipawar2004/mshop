import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/bloc/user_cart_bloc/user_cart_bloc.dart';
import 'package:hyper_local/bloc/user_cart_bloc/user_cart_state.dart';
import '../screens/cart_page/bloc/get_user_cart/get_user_cart_bloc.dart';
import '../services/cart_service.dart';
import '../utils/widgets/custom_toast.dart';

class CartStateListener extends StatelessWidget {
  final Widget child;

  const CartStateListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        CartService.updateCartFromLocal(context, state);

        if (state is GetUserCartFailed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ToastManager.show(
              context: context,
              message: 'Failed',
              type: ToastType.error,
            );
          });
        }
      },
      child: child,
    );
  }
}
