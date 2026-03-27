import 'package:flutter/material.dart';
import 'package:hyper_local/config/theme.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: AppTheme.primaryColor,
        onRefresh: onRefresh,
        child: child
    );
  }
}