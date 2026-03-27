import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../address_list_page/model/get_address_list_model.dart';

class DeliveryAddressWidget extends StatefulWidget {
  final VoidCallback? onTap;
  final AddressListData? selectedAddress;

  const DeliveryAddressWidget({
    super.key,
    this.onTap,
    this.selectedAddress,
  });

  @override
  State<DeliveryAddressWidget> createState() => _DeliveryAddressWidgetState();
}

class _DeliveryAddressWidgetState extends State<DeliveryAddressWidget> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final displayAddress = widget.selectedAddress != null 
        ? formatAddressFromModel(widget.selectedAddress!)
        : null;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode(context) ? null : Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          children: [
            // Location pin icon
            Icon(
              TablerIcons.map_pin_filled,
              color: AppTheme.primaryColor,
              size: 25.r,
            ),
            const SizedBox(width: 12),
            // Address content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.deliverTo ?? 'Deliver to',
                    style: TextStyle(
                      fontSize: isTablet(context) ? 20 : 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayAddress ??'',
                    style: TextStyle(
                      fontSize: isTablet(context) ? 16 : 12.sp,
                      color: Colors.grey[600],
                      height: 1,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),
            // Change button
            GestureDetector(
              onTap: widget.onTap,
              child: Text(
                l10n?.change ?? 'Change',
                style: TextStyle(
                  fontSize: isTablet(context) ? 22 : 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


String formatAddressFromModel(AddressListData address) {
  List<String> addressParts = [];

  if (address.addressLine1?.isNotEmpty == true) {
    addressParts.add(address.addressLine1!);
  }
  if (address.addressLine2?.isNotEmpty == true) {
    addressParts.add(address.addressLine2!);
  }
  if (address.city?.isNotEmpty == true) {
    addressParts.add(address.city!);
  }
  if (address.state?.isNotEmpty == true) {
    addressParts.add(address.state!);
  }
  if (address.zipcode?.isNotEmpty == true) {
    addressParts.add(address.zipcode!);
  }
  if (address.country?.isNotEmpty == true) {
    addressParts.add(address.country!);
  }

  return addressParts.join(', ');
}