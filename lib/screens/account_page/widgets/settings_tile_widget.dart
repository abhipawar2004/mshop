import 'package:flutter/material.dart';

import 'icon_box_widget.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool? isLast;
  final VoidCallback? onTap;
  const SettingsTile({super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          leading: iconBox(icon, Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3)),
          title: Text(title, style: const TextStyle(fontSize: 15,)),
          subtitle: subtitle != null
              ? Text(subtitle!, style: const TextStyle(fontSize: 13, color: Color(0xFF888888)))
              : null,
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        ),
        if (isLast == false) Divider(height: 1, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
      ],
    );
  }
}