import 'package:flutter/material.dart';
import 'icon_box_widget.dart';

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const QuickAction({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconBox(icon, Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3)),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                overflow: TextOverflow.ellipsis
              ),
            )
          ),
        ],
      ),
    );
  }
}