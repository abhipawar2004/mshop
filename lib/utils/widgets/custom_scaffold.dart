import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/global.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/utils/widgets/animated_button.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import '../../config/constant.dart';
import '../../config/theme.dart';
import '../../bloc/user_cart_bloc/user_cart_bloc.dart';
import '../../bloc/user_cart_bloc/user_cart_state.dart';
import 'connectivity_wrapper.dart';

class CustomScaffold extends StatefulWidget {
  final Widget body;
  final String? title;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? showAppBar;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final PreferredSizeWidget? appBar;
  final int itemCount;
  final String? itemText;
  final bool showViewCart;
  final FutureOr<void> Function(BuildContext context)? onConnectivityRestored;
  final FutureOr<void> Function(BuildContext context)? onConnectivityLost;
  final FutureOr<void> Function(bool isConnected, BuildContext context)? onConnectivityChanged;
  final bool notifyConnectivityStatusOnInit;

  const CustomScaffold({
    super.key,
    required this.body,
    this.title,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.showAppBar,
    this.appBarActions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBar,
    this.itemCount = 3,
    this.itemText,
    this.showViewCart = true,
    this.onConnectivityRestored,
    this.onConnectivityLost,
    this.onConnectivityChanged,
    this.notifyConnectivityStatusOnInit = false,
  });

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _expandController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _widthAnimation;
  late Animation<double> _contentOpacityAnimation;
  late Animation<Offset> _imageSlideAnimation;

  bool _isCartVisible = false;
  bool _isCurrentlyConnected = true;
  static bool _hasAnimatedGlobally = false;
  static bool _hasShownFullCartAnimation = false;
  int _previousItemCount = 0;
  bool _hasInitializedCart = false;
  int _stableItemCount = 0;


  @override
  void initState() {
    super.initState();

    // Controller for slide up/down animation - made faster
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Controller for expand/collapse animation - made faster
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Slide animation with smoother curve
    _slideAnimation = Tween<double>(
      begin: -100.0,
      end: 25.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Scale animation with smoother pop
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    // Opacity for smoother fade
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    // Width animation for expand/collapse
    _widthAnimation = Tween<double>(
      begin: 40.0.w,
      end: 190.0.w,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOutCubic,
    ));

    // Content opacity with better timing
    _contentOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));

    // Image slide animation
    _imageSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.8, 0.0),
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void didUpdateWidget(CustomScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget update logic removed - handled in build method
  }

  List<String> _getCartItems(CartState state) {
    if (state is CartLoaded) {
      return state.items
          .map((item) => item.image)
          .where((image) => image.isNotEmpty)
          .take(3)
          .toList();
    }
    return [];
  }

  Future<void> _animateIn() async {
    if (_slideController.isAnimating || _expandController.isAnimating) {
      return;
    }

    await _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 80));
    await _expandController.forward();
    _hasShownFullCartAnimation = true;
  }

  Future<void> _animateOut() async {
    if (_slideController.isAnimating || _expandController.isAnimating) {
      return;
    }

    await _expandController.reverse();
    await Future.delayed(const Duration(milliseconds: 80));
    await _slideController.reverse();
    setState(() {
      _isCartVisible = false;
    });
    _hasShownFullCartAnimation = false;
  }

  void _showCartWithoutAnimation() {
    _slideController.value = 1.0;
    _expandController.value = 1.0;
    setState(() {
      _isCartVisible = true;
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      onStatusChange: _handleConnectivityStatus,
      notifyStatusChangeOnInit: widget.notifyConnectivityStatusOnInit,
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartBlocState) {
          final hasCartItems = cartBlocState is CartLoaded &&
              cartBlocState.items.isNotEmpty;

          int currentItemCount = 0;
          bool isValidCart = false;

          if (cartBlocState is CartLoaded) {
            currentItemCount = cartBlocState.totalItems;
            // Valid only if items exist
            isValidCart = currentItemCount > 0;
          }

          if (isValidCart) {
            _stableItemCount = currentItemCount;
          } else {}

          // Only process animation logic when cart data is actually loaded
          final isCartDataLoaded = cartBlocState is CartLoaded;

          // Animation logic
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Skip processing if cart data hasn't loaded yet
            if (!isCartDataLoaded) {
              log('Cart data not loaded yet, skipping animation logic');
              return;
            }

            log('Has cart items: $hasCartItems, Is cart visible: $_isCartVisible, Item count: $currentItemCount');

            // Initialize cart state on first load
            if (!_hasInitializedCart) {
              _hasInitializedCart = true;
              _previousItemCount = currentItemCount;

              if (hasCartItems) {
                setState(() {
                  _isCartVisible = true;
                });

                // Show animation only on app startup with existing items
                if (!_hasAnimatedGlobally && !_hasShownFullCartAnimation && currentItemCount > 0) {
                  log('Initial load: Animating app startup with existing cart');
                  _hasAnimatedGlobally = true;
                  _animateIn();
                } else {
                  log('Initial load: Showing cart without animation');
                  _showCartWithoutAnimation();
                }
              }
              return;
            }
            if (hasCartItems && !_isCartVisible) {
              // Cart has items and is not visible
              setState(() {
                _isCartVisible = true;
              });

              // Check if we should show full cart animation
              bool shouldShowFullAnimation = false;

              // Condition 1: First product added (cart was empty, now has 1 item)
              if (_previousItemCount == 0 && currentItemCount == 1) {
                log('Animating: First product added to cart (full animation)');
                shouldShowFullAnimation = true;
              }

              // Show full animation or just display cart
              if (shouldShowFullAnimation) {
                _animateIn();
              } else if ((_slideController.value != 1.0 || _expandController.value != 1.0) &&
                  !_slideController.isAnimating &&
                  !_expandController.isAnimating) {
                log('Showing cart without full animation (page navigation or additional product)');
                _showCartWithoutAnimation();
              }
            }
            else if (!hasCartItems && _isCartVisible && _hasInitializedCart) {
              log('Animating out: Cart is now empty');
              _animateOut();
              _hasInitializedCart = false;
            }

            // Update previous count
            _previousItemCount = currentItemCount;
          });

          log('Building CustomScaffold: hasCartItems=$hasCartItems, itemCount=$currentItemCount, _isCartVisible=$_isCartVisible');

          return Scaffold(
            backgroundColor: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
            appBar: widget.appBar ??
                (widget.showAppBar == true
                    ? AppBar(
                  title: widget.title != null ? Text(
                    widget.title!,) : null,
                  titleTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: isTablet(context) ? 24 : 16.sp
                  ),
                  actions: widget.appBarActions,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shadowColor: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.2),
                )
                    : null),
            body: Stack(
              children: [
                widget.body,
                /// Animated VIEW CART
                if (_isCartVisible && widget.showViewCart && _previousItemCount > 0)
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_slideController, _expandController]),
                      builder: (context, child) {
                        return Positioned(
                          bottom: _slideAnimation.value,
                          left: 0,
                          right: 0,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Opacity(
                              opacity: _opacityAnimation.value,
                              child: Center(
                                child: _buildCartButton(context, cartBlocState),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: widget.bottomNavigationBar,
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
          );
        },
      ),
    );
  }

  void _handleConnectivityStatus(bool isConnected) {
    if (_isCurrentlyConnected == isConnected) {
      _invokeConnectivityChangedCallback(isConnected);
      return;
    }

    _isCurrentlyConnected = isConnected;
    _invokeConnectivityChangedCallback(isConnected);

    if (isConnected) {
      _invokeFutureOr(widget.onConnectivityRestored);
    } else {
      _invokeFutureOr(widget.onConnectivityLost);
    }
  }

  Widget _buildCartButton(BuildContext context, CartState cartBlocState) {
    return AnimatedButton(
      animationType: TapAnimationType.scale,
      onTap: () {
        if(Global.userData != null) {
          GoRouter.of(context).push(AppRoutes.cart);
        } else {
          GoRouter.of(context).push(AppRoutes.login);
        }
      },
      child: Container(
        width: _widthAnimation.value,
        height: isTablet(context) ? 40.h : 40.h,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Product images - only show if cart has items
            if (_getCartItems(cartBlocState).isNotEmpty)
              Positioned(
                left: _widthAnimation.value < 48.0.w ? 5.2.w : 22.w,
                top: 5.h,
                bottom: 5.h,
                child: Center(
                  child: Transform.translate(
                    offset: _widthAnimation.value < 48.0.w
                        ? Offset.zero
                        : _imageSlideAnimation.value * 20.w,
                    child: _widthAnimation.value < 48.0.w
                        ? SingleProductImage(
                      imageUrl: _getCartItems(cartBlocState).first,
                    )
                        : AnimatedFacePile(
                      cartItems: _getCartItems(cartBlocState),
                    ),
                  ),
                ),
              ),

            // Product count and arrow
            if (_widthAnimation.value > 48.0.w)
              Center(
                child: Opacity(
                  opacity: _contentOpacityAnimation.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 53.w),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$_stableItemCount",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _stableItemCount > 1 ? 'items' : 'item',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _invokeConnectivityChangedCallback(bool isConnected) {
    final callback = widget.onConnectivityChanged;
    if (callback == null) return;

    final result = callback(isConnected, context);
    if (result is Future<void>) {
      unawaited(result);
    }
  }

  void _invokeFutureOr(FutureOr<void> Function(BuildContext context)? callback) {
    if (callback == null) return;

    final result = callback(context);
    if (result is Future<void>) {
      unawaited(result);
    }
  }
}

class SingleProductImage extends StatefulWidget {
  final String imageUrl;

  const SingleProductImage({
    super.key,
    required this.imageUrl,
  });

  @override
  State<SingleProductImage> createState() => _SingleProductImageState();
}

class _SingleProductImageState extends State<SingleProductImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              height: 30.h,
              width: 30.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.6,
                  color: Colors.white,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CustomImageContainer(
                  imagePath: widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedFacePile extends StatefulWidget {
  final List<String> cartItems;

  const AnimatedFacePile({
    super.key,
    required this.cartItems,
  });

  @override
  State<AnimatedFacePile> createState() => _AnimatedFacePileState();
}

class _AnimatedFacePileState extends State<AnimatedFacePile> with TickerProviderStateMixin {
  late AnimationController _pileController;
  late AnimationController _newItemController;
  late List<Animation<double>> _slideAnimations;
  late Animation<double> _newItemScaleAnimation;
  late Animation<double> _newItemOpacityAnimation;
  int _lastAvatarCount = 0;
  bool _isNewItemAnimating = false;

  List<String> get avatars {
    // Take up to 3 items
    return widget.cartItems.reversed.take(3).toList();
  }

  @override
  void initState() {
    super.initState();
    _pileController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Controller for new item pop animation
    _newItemController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Scale animation for new item
    _newItemScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _newItemController,
      curve: Curves.elasticOut,
    ));

    // Opacity animation for new item
    _newItemOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _newItemController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _buildAnimationsForCount(avatars.length);
    _lastAvatarCount = avatars.length;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pileController.forward();
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedFacePile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentCount = avatars.length;

    // Check if a new item was added (count increased)
    if (currentCount > _lastAvatarCount) {
      _isNewItemAnimating = true;
      _newItemController.forward(from: 0.0).then((_) {
        setState(() {
          _isNewItemAnimating = false;
        });
      });
      _buildAnimationsForCount(currentCount);
      _pileController.forward(from: 1.0);
    } else if (currentCount != _lastAvatarCount) {
      _buildAnimationsForCount(currentCount);
      _pileController
        ..reset()
        ..forward();
    }

    _lastAvatarCount = currentCount;
  }

  @override
  void dispose() {
    _pileController.dispose();
    _newItemController.dispose();
    super.dispose();
  }

  void _buildAnimationsForCount(int count) {
    _slideAnimations = List.generate(count, (index) {
      return Tween<double>(
        begin: 0.0,
        end: index * 15.0,
      ).animate(CurvedAnimation(
        parent: _pileController,
        curve: Interval(
          (index * 0.15).clamp(0.0, 1.0),
          (0.7 + (index * 0.1)).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pileController, _newItemController]),
      builder: (context, child) {
        final count = avatars.length;
        if (_slideAnimations.length != count) {
          _buildAnimationsForCount(count);
        }

        return SizedBox(
          height: 38.h,
          width: 75.w,
          child: Stack(
            children: List.generate(
              count,
                  (index) {
                final slide = index < _slideAnimations.length
                    ? _slideAnimations[index]
                    : AlwaysStoppedAnimation<double>(index * 10.0);

                final isNewestItem = index == 0;
                final scale = (_isNewItemAnimating && isNewestItem)
                    ? _newItemScaleAnimation.value
                    : 1.0;
                final opacity = (_isNewItemAnimating && isNewestItem)
                    ? _newItemOpacityAnimation.value
                    : 1.0;

                return Positioned(
                  left: slide.value,
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        height: 30.h,
                        width: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: isTablet(context) ? 1.0 : 1.4.sp,
                            color: Colors.white,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CustomImageContainer(
                            imagePath: avatars[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
