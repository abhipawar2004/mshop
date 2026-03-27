import 'package:flutter/material.dart';
import 'package:hyper_local/config/constant.dart';

class SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;
  const SectionCard({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.3
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode(context) ? Colors.transparent : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: Offset(0, 2)
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 0, top: 12),
              child: Text(
                title!,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),
              ),
            ),
          child,
        ],
      ),
    );
  }
}