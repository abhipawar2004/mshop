import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/address_list_page/bloc/get_address_list_bloc/get_address_list_bloc.dart';
import 'package:hyper_local/screens/address_list_page/model/get_address_list_model.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';

import '../../../config/constant.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/address/selected_address_hive.dart';
import '../../home_page/widgets/quick_access_widget.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  int? selectedAddressId;

  @override
  void initState() {
    super.initState();
    context.read<GetAddressListBloc>().add(FetchUserAddressList());
  }

  void _loadSelectedAddress() {
    final selectedAddress = HiveSelectedAddressHelper.getSelectedAddress();
    setState(() {
      selectedAddressId = selectedAddress?.id;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showViewCart: false,
      title: 'My Addresses',
      showAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: BlocBuilder<GetAddressListBloc, GetAddressListState>(
        builder: (context, state) {
          if (state is GetAddressListLoading) {
            return CustomCircularProgressIndicator();
          } else if (state is GetAddressListLoaded) {
            return _buildAddressList(state);
          } else if (state is GetAddressListFailed) {
            return _buildErrorState(state.error);
          } else {
            return _buildEmptyState();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddAddress(),
        backgroundColor: AppTheme.primaryColor,
        child: Icon(
          TablerIcons.plus,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildAddressList(GetAddressListLoaded state) {
    if (state.addressList.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetAddressListBloc>().add(FetchUserAddressList());
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16.sp),
        itemCount: state.addressList.length,
        itemBuilder: (context, index) {
          final address = state.addressList[index];
          return _buildAddressCard(address);
        },
      ),
    );
  }

  Widget _buildAddressCard(AddressListData address) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                    maxLines: 3,
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
                  size: 12.sp,
                  color: Colors.grey[600],
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _navigateToEditAddress(address);
                  } else if (value == 'delete') {
                    _showDeleteDialog(address);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(TablerIcons.edit, size: 16.sp),
                        SizedBox(width: 8.sp),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(TablerIcons.trash, size: 16.sp, color: AppTheme.errorColor),
                        SizedBox(width: 8.sp),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            TablerIcons.map_pin_off,
            size: 80.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.sp),
          Text(
            AppLocalizations.of(context)!.noAddressFound,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.sp),
          Text(
            AppLocalizations.of(context)!.addYourFirstAddressToStart,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24.sp),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddAddress(),
            icon: Icon(TablerIcons.plus, size: 16.sp),
            label: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return Text(l10n?.addAddress ?? 'Add Address');
                }
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 12.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            TablerIcons.alert_circle,
            size: 80.sp,
            color: Colors.red[400],
          ),
          SizedBox(height: 16.sp),
          Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              return Text(
                l10n?.somethingWentWrong ?? 'Something went wrong',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              );
            }
          ),
          SizedBox(height: 8.sp),
          Text(
            error,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.sp),
          ElevatedButton.icon(
            onPressed: () => context.read<GetAddressListBloc>().add(FetchUserAddressList()),
            icon: Icon(TablerIcons.refresh, size: 16.sp),
            label: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                return Text(l10n?.retry ?? 'Retry');
              }
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 12.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddAddress() async {
    await GoRouter.of(context).push(
      AppRoutes.locationPicker,
      extra: {
        'isFromAddressPage': true,
        'isEdit': false
      },
    );
    _loadSelectedAddress();
  }

  void _navigateToEditAddress(AddressListData address) async {
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
    // Reload selected address when coming back
    _loadSelectedAddress();
  }

  void _showDeleteDialog(AddressListData address) {
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
              message: 'Failed to delete address',
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
                      isRemoving = state.isRemoving;
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
}