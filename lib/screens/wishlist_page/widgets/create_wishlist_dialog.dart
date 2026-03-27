import 'package:flutter/material.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_textfield.dart';
import '../../../l10n/app_localizations.dart';

class CreateWishlistDialog extends StatefulWidget {
  final Function(String) onConfirm;
  final String? initialValue;

  const CreateWishlistDialog({
    super.key,
    required this.onConfirm,
    this.initialValue,
  });

  @override
  State<CreateWishlistDialog> createState() => _CreateWishlistDialogState();

  /// Simple static method to show the dialog
  static Future<String?> show(BuildContext context, {String? initialValue}) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String? result;
        return CreateWishlistDialog(
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

class _CreateWishlistDialogState extends State<CreateWishlistDialog> {
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
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 40.0),
      title: Text(l10n?.createNewWishlistTitle ?? 'Create New Wishlist'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              controller: _textController,
              hintText: l10n?.enterWishlistName ?? 'Enter wishlist name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n?.pleaseEnterAWishlistName ?? 'Please enter a wishlist name';
                }
                if (value.trim().length < 2) {
                  return l10n?.nameMustBeAtLeast2Characters ?? 'Name must be at least 2 characters';
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
            l10n?.cancel ?? 'Cancel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary
            ),
          ),
        ),
        CustomButton(
          onPressed: _handleConfirm,
          child: Text(l10n?.create ?? 'Create'),
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
