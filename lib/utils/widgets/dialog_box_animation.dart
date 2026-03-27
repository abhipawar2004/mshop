import 'package:flutter/material.dart';

Future<void> openSlideUpDialog(BuildContext context, Widget dialog) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dialog',
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, anim, secondaryAnim) => Center(child: dialog),
    transitionBuilder: (context, anim, secondaryAnim, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeInCubic);
      return SafeArea(
        child: FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}
