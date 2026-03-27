import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/bloc/user_cart_bloc/user_cart_bloc.dart';
import 'package:hyper_local/bloc/user_cart_bloc/user_cart_event.dart';
import 'package:hyper_local/config/theme.dart';

import '../../../router/app_routes.dart';
import '../../cart_page/bloc/get_user_cart/get_user_cart_bloc.dart';

class OrderSuccessPage extends StatefulWidget {
  final String address;
  final String addressType;
  final String orderSlug;
  const OrderSuccessPage({super.key, required this.address, required this.addressType, required this.orderSlug});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  final confettiController = ConfettiController();
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    confettiController.play();

    stopAnimation();
    navigateBack();
    context.read<CartBloc>().add(ClearCart(context: context));
    super.initState();
  }

  Future<void> stopAnimation () async {
    Future.delayed(Duration(seconds: 5),(){
      confettiController.stop();
    });
  }

  Future<void> navigateBack() async {
    Future.delayed(Duration(seconds: 8),(){
      if(mounted) {
        GoRouter.of(context).pop();
        context.read<GetUserCartBloc>().add(RefreshUserCart());
        GoRouter.of(context).push(
            AppRoutes.orderDetail,
            extra: {
              'order-slug': widget.orderSlug
            }
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          alignment: Alignment.center,
          child: Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  TablerIcons.circle_check_filled,
                  color: AppTheme.primaryColor,
                  size: 150.r,
                ),
                SizedBox(height: 10.h,),
                Text(
                  'Order Placed',
                  style: TextStyle(
                      fontSize: 18.sp
                  ),
                ),
                SizedBox(height: 8.h,),
                Padding(
                  padding:  EdgeInsets.symmetric(
                      horizontal: 25.w,
                      vertical: 00
                  ),
                  child: Text(
                    'Delivery to ${widget.addressType.toUpperCase()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.sp
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(
                      horizontal: 25.w,
                    vertical: 0.0
                  ),
                  child: Text(
                    widget.address,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.sp
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -100,
          left: 80,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirection: pi/2,
            numberOfParticles: 30,
            gravity: 0.03,
            emissionFrequency: 0.03,
            maxBlastForce: 20,
          ),
        ),
        Positioned(
          top: -100,
          right: 80,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirection: pi/2,
            numberOfParticles: 30,
            gravity: 0.03,
            emissionFrequency: 0.03,
            maxBlastForce: 20,
          ),
        ),
      ],
    );
  }
}