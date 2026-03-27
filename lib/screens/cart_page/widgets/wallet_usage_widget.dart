import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/screens/cart_page/bloc/get_user_cart/get_user_cart_bloc.dart';
import 'package:hyper_local/screens/wallet_page/bloc/user_wallet/user_wallet_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import '../../../config/constant.dart';

class WalletUsageWidget extends StatefulWidget {
  final bool isWalletEnabled;
  final Function(bool) onWalletToggle;
  final bool isLoading;

  const WalletUsageWidget({
    super.key,
    required this.isWalletEnabled,
    required this.onWalletToggle,
    this.isLoading = false,
  });

  @override
  State<WalletUsageWidget> createState() => _WalletUsageWidgetState();
}

class _WalletUsageWidgetState extends State<WalletUsageWidget> {
  double balance = 0.00;
  double remainingBalance = 0.00;
  double usedBalance = 0.00;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 12.0.w,
          right: 12.0.w,
          top: 12.h,
          bottom: 12.h
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Use Wallet Balance',
                    style: TextStyle(
                      fontSize: isTablet(context) ? 24 : 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              BlocBuilder<GetUserCartBloc, GetUserCartState>(
                builder: (context, state){
                  if(state is GetUserCartLoaded) {
                    usedBalance = double.parse(state.cartData.first.data!.paymentSummary!.walletAmountUsed!.toStringAsFixed(2));
                    remainingBalance = double.parse(state.cartData.first.data!.paymentSummary!.walletBalance!.toStringAsFixed(2)) - usedBalance;
                  }

                  return state is GetUserCartLoading
                      ? CustomCircularProgressIndicator()
                      : SizedBox(
                    height: 25,
                    child: Switch(
                      value: widget.isWalletEnabled,
                      onChanged: balance > 0.0 ? (value) {
                        widget.onWalletToggle(value);
                      } : (value){},
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      activeThumbColor: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          BlocBuilder<UserWalletBloc, UserWalletState>(
            builder: (context, state) {
              if (state is UserWalletLoaded && state.userWallet.isNotEmpty) {
                final wallet = state.userWallet.first;
                balance = double.tryParse(wallet.balance ?? '0.00') ?? 0.00;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Available Balance',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          '${AppConstant.currency}${balance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Wallet Amount Used',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          '${AppConstant.currency}${usedBalance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Remaining Wallet Balance',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          '${AppConstant.currency}${remainingBalance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    if (balance <= 0) ...[
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16.r,
                              color: Colors.orange[700],
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Insufficient wallet balance',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

