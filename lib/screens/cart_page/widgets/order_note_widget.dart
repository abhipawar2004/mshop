import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/utils/widgets/custom_textfield.dart';
import '../../../config/constant.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
// import your bloc if you use one for order note

class OrderNoteWidget extends StatefulWidget {
  final String? initialNote;
  final Function(String note)? onNoteChanged; // optional callback
  final bool isEnabled; // to disable when order is processing

  const OrderNoteWidget({
    super.key,
    this.initialNote,
    this.onNoteChanged,
    this.isEnabled = true,
  });

  @override
  State<OrderNoteWidget> createState() => _OrderNoteWidgetState();
}

class _OrderNoteWidgetState extends State<OrderNoteWidget> {
  late TextEditingController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote ?? '');
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.onNoteChanged != null) {
      widget.onNoteChanged!(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: isDarkMode(context)
            ? Theme.of(context).colorScheme.surface
            : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (always visible)
          InkWell(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Icon(
                    TablerIcons.note,
                    size: 22.sp,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      "Add Order Note",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode(context) ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? TablerIcons.chevron_up : TablerIcons.chevron_down,
                    size: 20.sp,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Any special instructions for the store (e.g., delivery time, fragile items, etc.)",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  CustomTextFormField(
                    controller: _controller,
                    maxLines: 4,
                    minLines: 3,
                    enabled: widget.isEnabled,
                    hintText: l10n?.writeYourNoteHere ?? "Write your note here...",
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_controller.text.length}/300',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: _controller.text.length > 300
                            ? Colors.red
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState:
            _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}