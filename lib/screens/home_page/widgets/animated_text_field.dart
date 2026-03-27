import 'package:animated_hint_textfield/animated_hint_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/settings_data_instance.dart';
import 'package:hyper_local/router/app_routes.dart';

class CustomAnimatedTextField extends StatelessWidget {
  const CustomAnimatedTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      child: SizedBox(
        height: 42,
        child: GestureDetector(
          onTap: () {
            GoRouter.of(context).push(AppRoutes.search);
          },
          child: Stack(
            children: [
              Directionality(
                textDirection: Localizations.localeOf(context).languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
                child: AnimatedTextField(
                  animationDuration: const Duration(milliseconds: 500),
                  animationType: Animationtype.typer,
                  showCursor: false,
                  readOnly: true,
                  enabled: false,
                  hintTextStyle: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.6),
                      // color: Colors.black38
                  ),
                  hintTexts: removeUnderscoresFromStringList(SettingsData.instance.homeGeneralSettings?.searchLabels?? [
                    'Search "ice cream"',
                    'Search "milk"',
                    'Search "rice"',
                    'Search "shampoo"',
                    'Search "namkeen"',
                  ]),
                  minLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none
                    ),
                    fillColor: isDarkMode(context) ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
                    filled: true,
                    prefixIcon: Icon(
                      HeroiconsOutline.magnifyingGlass,
                      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.6),
                      // color: Colors.black,
                    ),
                    // suffixIcon: SizedBox(
                    //   width: 100,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       GestureDetector(
                    //         onTap: () {
                    //           GoRouter.of(context).push(AppRoutes.shoppingList);
                    //         },
                    //         child: MouseRegion(
                    //           cursor: SystemMouseCursors.click,
                    //           child: Container(
                    //             padding: EdgeInsets.all(8),
                    //             child: Icon(
                    //               TablerIcons.pencil,
                    //               color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.6),
                    //               size: 22,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(width: 8),
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
              ),
              PositionedDirectional(
                end: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push(AppRoutes.shoppingList);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        TablerIcons.pencil,
                        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.6),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}