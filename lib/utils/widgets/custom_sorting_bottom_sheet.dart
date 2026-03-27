import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/constant.dart';
import '../../model/sorting_model/sorting_model.dart';
import 'package:hyper_local/config/theme.dart';

class CustomSortBottomSheet extends StatefulWidget {
  final SortType currentSortType;
  final Function(SortOption) onSortSelected;

  const CustomSortBottomSheet({
    super.key,
    required this.currentSortType,
    required this.onSortSelected,
  });

  @override
  State<CustomSortBottomSheet> createState() => _CustomSortBottomSheetState();

  static void show({
    required BuildContext context,
    required SortType currentSortType,
    required Function(SortOption) onSortSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          CustomSortBottomSheet(
            currentSortType: currentSortType,
            onSortSelected: onSortSelected,
          ),
        ],
      ),
    );
  }
}

class _CustomSortBottomSheetState extends State<CustomSortBottomSheet> {
  late SortType selectedSortType;

  @override
  void initState() {
    super.initState();
    selectedSortType = widget.currentSortType;
  }

  @override
  Widget build(BuildContext context) {
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
          // Handle bar
          /*Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            height: 4.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),*/

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Text(
                  'Sort by',
                  style: TextStyle(
                    fontSize: isTablet(context) ? 24 : 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1.h, color: Theme.of(context).colorScheme.outlineVariant),

          // Sort options
          Flexible(
            child: RadioGroup<SortType>(
              groupValue: selectedSortType,
              onChanged: (SortType? value) {
                if (value != null) {
                  setState(() {
                    selectedSortType = value;
                  });
                  final sortOption = SortOption.sortOptions.firstWhere(
                        (option) => option.type == value,
                  );
                  widget.onSortSelected(sortOption);
                  Navigator.pop(context);
                }
              },
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: SortOption.sortOptions.length,
                separatorBuilder: (context, index) => SizedBox.shrink(),
                itemBuilder: (context, index) {
                  final sortOption = SortOption.sortOptions[index];
                  final isSelected = selectedSortType == sortOption.type;

                  return RadioListTile<SortType>(
                    title: Text(
                      sortOption.displayName,
                      style: TextStyle(
                        fontSize: isTablet(context) ? 20 : 14.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppTheme.primaryColor : Colors.grey[800],
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    value: sortOption.type,
                    radioScaleFactor: 1.0,
                    fillColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppTheme.primaryColor;
                      }
                      return AppTheme.primaryColor;
                    }),
                    activeColor: AppTheme.primaryColor, // Color of the selected radio
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                    dense: true, // Makes it tighter vertically
                    visualDensity: VisualDensity.compact, // Optional: even more compact
                  );
                },
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
