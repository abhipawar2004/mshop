import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/model/user_location/user_location_model.dart';
import 'package:hyper_local/screens/address_list_page/model/get_address_list_model.dart';
import '../../../config/constant.dart';
import '../../../services/location/location_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../services/location/user_location_hive.dart';

class RecentLocationsList extends StatelessWidget {
  final Function(UserLocation)? onLocationSelected;
  final bool showDeleteButton;

  const RecentLocationsList({
    super.key,
    this.onLocationSelected,
    this.showDeleteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<dynamic>(HiveLocationHelper.boxName)
          .listenable(keys: [HiveLocationHelper.recentLocationsKey]),
      builder: (context, box, _) {
        final recentLocations = HiveLocationHelper.getRecentLocations();

        if (recentLocations.isEmpty) {
          return SizedBox.shrink();
        }

        // THIS IS THE FIX: Wrap in PostFrameWidget
        return PostFrameWidget(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick access',
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[700]
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: recentLocations.length,
                  itemBuilder: (context, index) {
                    final location = recentLocations[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0,),
                      child: InkWell(
                        onTap: () async {
                          UserLocation userLocation = UserLocation(
                            latitude: location.latitude,
                            longitude: location.longitude,
                            fullAddress: location.fullAddress.trim(),
                            area: location.area.trim(),
                            city: location.city.trim(),
                            state: location.state.trim(),
                            country: location.country.trim(),
                            pincode: location.pincode.trim(),
                            landmark: location.landmark.trim(),
                          );
                          await LocationService.storeLocation(userLocation);
                          if(context.mounted){
                            GoRouter.of(context).pop({
                              'location': location,
                              'address': location.fullAddress,
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
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  TablerIcons.map_pin,
                                  color: AppTheme.primaryColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      location.city,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      location.fullAddress,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).colorScheme.onSecondaryContainer
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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