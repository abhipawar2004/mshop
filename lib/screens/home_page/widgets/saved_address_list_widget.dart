import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/model/user_location/user_location_model.dart';
import 'package:hyper_local/screens/address_list_page/bloc/get_address_list_bloc/get_address_list_bloc.dart';
import 'package:hyper_local/screens/address_list_page/model/get_address_list_model.dart';
import 'package:hyper_local/screens/home_page/widgets/quick_access_widget.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';

import '../../../l10n/app_localizations.dart';
import '../../../router/app_routes.dart';
import '../../../services/location/location_service.dart';
import '../../../utils/widgets/custom_toast.dart';

class SavedAddressListWidget extends StatelessWidget {
  final Function(UserLocation)? onLocationSelected;
  final bool showDeleteButton;

  const SavedAddressListWidget({
    super.key,
    this.onLocationSelected,
    this.showDeleteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAddressListBloc, GetAddressListState>(
      builder: (context, state) {
        if (state is GetAddressListLoading) {
          return CustomCircularProgressIndicator();
        }
        if (state is! GetAddressListLoaded || state.addressList.isEmpty) {
          return RecentLocationsList();
        }

        final addresses = state.addressList;

        return PostFrameWidget(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.savedAddresses,
                  style: TextStyle(fontSize: isTablet(context) ? 18 : 12.sp, color: Colors.grey[700]),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: InkWell(
                        onTap: () async {
                          final double? latitude =
                          double.tryParse(address.latitude ?? '');
                          final double? longitude =
                          double.tryParse(address.longitude ?? '');

                          if (latitude == null || longitude == null) {
                            return;
                          }
                          final formattedAddress = formatAddress(address);
                          final userLocation = UserLocation(
                            latitude: latitude,
                            longitude: longitude,
                            fullAddress: formattedAddress,
                            area: address.addressLine1?.trim() ?? '',
                            city: address.city?.trim() ?? '',
                            state: address.state?.trim() ?? '',
                            country: address.country?.trim() ?? '',
                            pincode: address.zipcode?.trim() ?? '',
                            landmark: address.landmark?.trim() ?? '',
                          );

                          await LocationService.storeLocation(userLocation);

                          if(context.mounted) {
                            GoRouter.of(context).pop({
                              'location': userLocation,
                              'address': formattedAddress,
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDarkMode(context) ? Theme.of(context).colorScheme.onSecondary : Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: statusIcon(
                                  switch (address.addressType?.toLowerCase()) {
                                    'work' => AddressStatusType.work,
                                    'home' => AddressStatusType.home,
                                    _ => AddressStatusType.other,
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      capitalizeFirstLetter(address.addressType ?? ''),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatAddress(address),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8,),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle
                                ),
                                child: PopupMenuButton<String>(
                                  icon: Icon(
                                    TablerIcons.dots_vertical,
                                    size: 12.r,
                                    color: Colors.grey[600],
                                  ),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _navigateToEditAddress(address, context);
                                    } else if (value == 'delete') {
                                      _showDeleteDialog(address, context);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(TablerIcons.edit, size: 16.sp),
                                          SizedBox(width: 8.r),
                                          Text(AppLocalizations.of(context)!.edit),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(TablerIcons.trash, size: 16.sp, color: AppTheme.errorColor),
                                          SizedBox(width: 8.r),
                                          Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(AddressListData address, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => BlocListener<GetAddressListBloc, GetAddressListState>(
          listener: (context, state) {
            if (state is GetAddressListLoaded) {
              if(state.isRemoved) {
                Navigator.pop(context);
              }
            } else if (state is GetAddressListFailed) {
              Navigator.pop(context);
              ToastManager.show(
                  context: context,
                  message: AppLocalizations.of(context)!.failedToDeleteAddress,
                  type: ToastType.error
              );
            }
          },
          child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                return AlertDialog(
                  title: Text(l10n?.deleteAddress ?? 'Delete Address'),
                  content: Text(l10n?.areYouSureYouWantToDeleteThisAddress ??
                      'Are you sure you want to delete this address?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l10n?.cancel ?? 'Cancel',
                        style: TextStyle(color: Theme
                            .of(context)
                            .colorScheme
                            .tertiary),
                      ),
                    ),
                    BlocBuilder<GetAddressListBloc, GetAddressListState>(
                      builder: (context, state) {
                        bool isRemoving = false;
                        if (state is GetAddressListLoaded) {
                          // setState(() {
                          isRemoving = state.isRemoving;
                          // });
                        }
                        return TextButton(
                          onPressed: isRemoving
                              ? null
                              : () {
                            context.read<GetAddressListBloc>().add(
                              RemoveAddressRequest(addressId: address.id!),
                            );
                          },
                          child: isRemoving
                              ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          )
                              : Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
                        );
                      },
                    ),
                  ],
                );
              }
          ),
        ));
  }

  void _navigateToEditAddress(AddressListData address, BuildContext context) async {
    await GoRouter.of(context).push(
      AppRoutes.locationPicker,
      extra: {
        'isFromAddressPage': true,
        'lat': double.parse(address.latitude!),
        'lng': double.parse(address.longitude!),
        'address': '${address.addressLine1 ?? ''}${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}',
        'isEdit': true,
        'addressId': address.id,
        'addressType': address.addressType
      },
    );
  }

}

class PostFrameWidget extends StatelessWidget {
  final Widget child;
  const PostFrameWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    return child;
  }
}

String formatAddress(AddressListData address) {
  final parts = [
    address.addressLine1,
    address.addressLine2,
    address.city,
    address.state,
    address.zipcode,
    address.country,
  ].where((part) => part != null && part.trim().isNotEmpty).toList();

  return parts.join(', ');
}


enum AddressStatusType { work, home, other}

Widget statusIcon(AddressStatusType status) {
  switch (status) {
    case AddressStatusType.work:
      return Icon(TablerIcons.building_skyscraper, color: Colors.grey, size: 20);
    case AddressStatusType.home:
      return Icon(TablerIcons.home, color: Colors.grey,size: 20,);
    case AddressStatusType.other:
      return Icon(TablerIcons.map_pin, color: Colors.grey, size: 20,);
  }
}