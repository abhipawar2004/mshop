import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_textfield.dart';

class EditWishlistDialog extends StatefulWidget {
  final Function(String) onConfirm;
  final String? initialValue;

  const EditWishlistDialog({
    super.key,
    required this.onConfirm,
    this.initialValue,
  });

  @override
  State<EditWishlistDialog> createState() => _EditWishlistDialogState();

  /// Simple static method to show the dialog
  static Future<String?> show(BuildContext context, {String? initialValue}) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String? result;
        return EditWishlistDialog(
          initialValue: initialValue,
          onConfirm: (value) {
            result = value;
            Navigator.of(context).pop(result);
          },
        );
      },
    );
  }
}

class _EditWishlistDialogState extends State<EditWishlistDialog> {
  late TextEditingController _textController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 50.h),
      title: Row(
        children: [
          Icon(Icons.edit_outlined, color: AppTheme.primaryColor, size: 24),
          SizedBox(width: 12),
          Text(AppLocalizations.of(context)!.editWishlist),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update your wishlist name',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            CustomTextFormField(
              controller: _textController,
              hintText: AppLocalizations.of(context)!.enterWishlistName,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a wishlist name';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleConfirm(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            'Cancel',
            style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary
            ),
          ),
        ),
        CustomButton(
          onPressed: _handleConfirm,
          child: Text(AppLocalizations.of(context)!.update),
        ),
      ],
    );
  }

  void _handleConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onConfirm(_textController.text.trim());
    }
  }
}