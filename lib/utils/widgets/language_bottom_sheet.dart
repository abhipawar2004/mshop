import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import '../../bloc/language_bloc/language_bloc.dart';
import '../../config/global.dart';
import '../../l10n/app_localizations.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();

  // Static show method - clean and consistent with your sort sheet
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Floating close button (same as sort sheet)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, size: 20,),
                ),
              ),
            ),
          ),
          const LanguageBottomSheet(),
        ],
      ),
    );
  }
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.r),
          topRight: Radius.circular(14.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Text(
                  l10n?.selectLanguage ?? 'Select Language',
                  style: TextStyle(
                    fontSize: isTablet(context) ? 22 : 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1.h, color: Theme.of(context).colorScheme.outlineVariant),

          // Language List
          Flexible(
            child: BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, state) {
                final currentCode = state is LanguageLoaded ? state.languageCode : 'en';

                return RadioGroup<String>(
                  groupValue: currentCode,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<LanguageBloc>().add(ChangeLanguage(value));
                      Navigator.pop(context);
                    }
                  },
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: Global.supportedLanguages.length,
                    separatorBuilder: (context, index) => const SizedBox.shrink(),
                    itemBuilder: (context, index) {
                      final language = Global.supportedLanguages[index];
                      final code = language['code']!;
                      final isSelected = currentCode == code;

                      return RadioListTile<String>(
                        title: Text(
                          language['nativeName']!,
                          style: TextStyle(
                            fontSize: isTablet(context) ? 18 : 14.sp,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? AppTheme.primaryColor : Colors.grey[800],
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                        subtitle: Text(
                          language['name']!,
                          style: TextStyle(
                            fontSize: isTablet(context) ? 16 : 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        value: code,
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppTheme.primaryColor;
                          }
                          return AppTheme.primaryColor;
                        }),
                        activeColor: AppTheme.primaryColor,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 10.h),
        ],
      ),
    );
  }
}