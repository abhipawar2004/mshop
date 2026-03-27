import 'package:flutter/material.dart';

/// Custom gesture detector with smooth tap animations
///
/// Example usage:
/// ```
/// AnimatedButton(
///   onTap: () => print('Tapped!'),
///   animationType: TapAnimationType.scale,
///   child: Container(...),
/// )
/// ```
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final TapAnimationType animationType;
  final Duration duration;
  final double scaleAmount;
  final bool hapticFeedback;
  final Curve curve;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onTap,
    this.animationType = TapAnimationType.scale,
    this.duration = const Duration(milliseconds: 100),
    this.scaleAmount = 0.90,
    this.hapticFeedback = true,
    this.curve = Curves.easeOut,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    // Setup animations...
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleAmount)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Auto-reverse when forward completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _handleTap() {
    // if (widget.hapticFeedback) HapticFeedback.lightImpact();
    if (mounted && _controller.status != AnimationStatus.forward) {
      _controller.forward();
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          switch (widget.animationType) {
            case TapAnimationType.scale:
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );

            case TapAnimationType.opacity:
              return Opacity(
                opacity: _opacityAnimation.value,
                child: child,
              );

            case TapAnimationType.scaleAndOpacity:
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: child,
                ),
              );

            case TapAnimationType.bounce:
            // Improved bounce with proper spring physics
              final bounceValue = _controller.status == AnimationStatus.forward
                  ? Tween<double>(begin: 1.0, end: 0.88)
                  .animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOutQuart,
              ))
                  .value
                  : Tween<double>(begin: 0.88, end: 1.0)
                  .animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.elasticOut,
              ))
                  .value;

              return Transform.scale(
                scale: _controller.isAnimating ? bounceValue : 1.0,
                child: child,
              );

            case TapAnimationType.rotate:
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );

            case TapAnimationType.press:
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, (1 - _scaleAnimation.value) * 3), // Reduced translation
                  child: child,
                ),
              );
          }
        },
        child: widget.child,
      ),
    );
  }
}

enum TapAnimationType {
  scale,           // Simple scale down
  opacity,         // Fade effect
  scaleAndOpacity, // Scale + fade
  bounce,          // Bouncy scale
  rotate,          // Slight rotation + scale
  press,           // Press down effect
}
