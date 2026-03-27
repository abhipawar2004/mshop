import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/wallet_page/bloc/user_wallet/user_wallet_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'dart:math' as math;

import '../../../l10n/app_localizations.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  late AnimationController _coinFlipController;
  late AnimationController _glowController;
  late Animation<double> _flipAnimation;
  late Animation<double> _glowAnimation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    context.read<UserWalletBloc>().add(FetchUserWallet());

    // Coin flip animation controller
    _coinFlipController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Glow pulse animation controller
    _glowController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _coinFlipController, curve: Curves.easeInOutBack),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _coinFlipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _coinFlipController.reset();
        setState(() => _isRefreshing = false);
      }
    });
  }

  @override
  void dispose() {
    _coinFlipController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _refreshBalance() {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);
    _coinFlipController.forward();
    _glowController.repeat(reverse: true);

    // Call API to refresh balance
    context.read<UserWalletBloc>().add(FetchUserWallet());

    // Stop glow after coin flip
    Future.delayed(Duration(milliseconds: 1200), () {
      _glowController.stop();
      _glowController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight * 0.4;

    return CustomScaffold(
      backgroundColor: Colors.white,
      showViewCart: false,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),

          Container(
            height: 450,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage('assets/images/wallet/wallet-bg-image.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          SafeArea(child: _buildAppBar(context)),

          Positioned(
            top: backgroundHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 100, left: 20, right: 20),
                    child: Column(
                      children: [
                        _buildTransactionsRow(),
                        Expanded(child: Container()),
                        _buildBottomButtons(context),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: backgroundHeight - 60,
            left: 20,
            right: 20,
            child: _buildBalanceCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.wallet,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet(context) ? 24 : 16.sp,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2196F3),
                Color(0xFF0861B9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.balance,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    BlocBuilder<UserWalletBloc, UserWalletState>(
                      builder: (BuildContext context, UserWalletState state) {
                        if (state is UserWalletLoaded) {
                          return Text(
                            state.userWallet.first.balance ?? '0.00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else if (state is UserWalletLoading) {
                          return Container(
                            height: 30,
                            width: 60,
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            ),
                          );
                        }
                        return Container(
                          height: 30,
                          width: 60,
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    // Tap to refresh hint with animated icon
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: _flipAnimation,
                          builder: (context, child) {
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(_flipAnimation.value),
                              child: Icon(
                                TablerIcons.coin,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 16,
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 6),
                        Text(
                          AppLocalizations.of(context)!.tapCoinToRefresh,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Interactive coin with flip animation
              GestureDetector(
                onTap: _refreshBalance,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    final angle = _flipAnimation.value;
                    final isFront = (angle / math.pi) % 2 < 1;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..rotateY(angle),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: _isRefreshing ? [
                            BoxShadow(
                              color: Colors.yellow.withValues(alpha: 0.5 * _glowAnimation.value),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ] : [],
                        ),
                        child: isFront
                            ? CustomImageContainer(
                          imagePath:  'assets/images/wallet/wallet-coins.png',
                          width: 100,
                          height: 100,
                        )
                            : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(math.pi),
                          child: CustomImageContainer(
                            imagePath:  'assets/images/wallet/wallet-coins.png',
                            width: 100,
                            height: 100,
                          ),

                          // child: Image.asset(
                          //   'assets/images/wallet/wallet-coins.png',
                          //   width: 100,
                          //   height: 100,
                          //   color: Colors.white.withOpacity(0.9),
                          //   colorBlendMode: BlendMode.modulate,
                          // ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionsRow() {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(AppRoutes.transactions);
        // Navigate to transactions page
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode(context) ? Theme.of(context).colorScheme.onSecondary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFF2196F3).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                TablerIcons.notebook,
                color: Color(0xFF2196F3),
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.viewTransactions,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade600,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            AppLocalizations.of(context)!.addMoney,
            AppTheme.primaryColor,
            Colors.white,
            Colors.transparent,
                () {
              GoRouter.of(context).push(AppRoutes.addMoney);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String text,
      Color backgroundColor,
      Color textColor,
      Color borderColor,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor != Colors.transparent
                ? borderColor
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}