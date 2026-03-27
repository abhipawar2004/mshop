import 'package:flutter/material.dart';

import '../../config/connectivity_service.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  final ValueChanged<bool>? onStatusChange;
  final bool notifyStatusChangeOnInit;

  const ConnectivityWrapper({
    super.key,
    required this.child,
    this.onStatusChange,
    this.notifyStatusChangeOnInit = false,
  });

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late final ConnectivityService _connectivityService;
  late final Future<void> _initialization;
  bool? _lastNotifiedStatus;

  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();
    _initialization = _connectivityService.initialize();
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        return StreamBuilder<bool>(
          stream: _connectivityService.onConnectionChanged,
          initialData: _connectivityService.isConnected,
          builder: (context, snapshot) {
            final isConnected =
                snapshot.data ?? _connectivityService.isConnected;

            _notifyStatusChange(isConnected);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                widget.child,
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    bottom: false,
                    minimum: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: isConnected
                          ? const SizedBox.shrink(key: ValueKey('online'))
                          : const _OfflineBanner(key: ValueKey('offline')),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _notifyStatusChange(bool status) {
    final callback = widget.onStatusChange;
    final previous = _lastNotifiedStatus;
    final isInitial = previous == null;
    _lastNotifiedStatus = status;

    if (callback == null) {
      return;
    }

    if (isInitial && !widget.notifyStatusChangeOnInit) {
      return;
    }

    if (!isInitial && previous == status) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      callback(status);
    });
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 20,
              color: colorScheme.onError,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                'No internet connection',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onError,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
