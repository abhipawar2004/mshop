import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/settings_data_instance.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/cart_page/bloc/get_user_cart/get_user_cart_bloc.dart';
import '../screens/my_orders/model/order_detail_model.dart';

class AppConstant {
  static String _resolveBaseUrl() {
    const defaultBaseUrl = 'https://shop.mastropaytech.com/api/';
    final raw = dotenv.env['BASE_URL'];
    if (raw == null || raw.trim().isEmpty) return defaultBaseUrl;

    final trimmed = raw.trim();
    return trimmed.endsWith('/') ? trimmed : '$trimmed/';
  }

  static String baseUrl = _resolveBaseUrl();
  static String appName = dotenv.env['APP_NAME'] ?? 'MShop';
  static String androidMapKey = dotenv.env['ANDROID_MAP_KEY'] ??
      'AIzaSyDCLsi0UdNuIacZOlmLWA9RkFKYLmpD-bk';
  static String iosMapKey = dotenv.env['IOS_MAP_KEY']?.isNotEmpty == true
      ? dotenv.env['IOS_MAP_KEY']!
      : 'AIzaSyDCLsi0UdNuIacZOlmLWA9RkFKYLmpD-bk';
  static String androidClientId = dotenv.env['ANDROID_CLIENT_ID']
              ?.trim()
              .isNotEmpty ==
          true
      ? dotenv.env['ANDROID_CLIENT_ID']!.trim()
      : '285207710216-u0ao8ad9qro8v7e2elarbevcgghscm2g.apps.googleusercontent.com';
  static String webClientId = dotenv.env['WEB_CLIENT_ID']?.trim().isNotEmpty ==
          true
      ? dotenv.env['WEB_CLIENT_ID']!.trim()
      : '285207710216-jilseih5h5lkmk1naikv14qprods6jab.apps.googleusercontent.com';
  static String serverClientId =
      dotenv.env['SERVER_CLIENT_ID']?.trim().isNotEmpty == true
          ? dotenv.env['SERVER_CLIENT_ID']!.trim()
          : webClientId;

  static String localUserLocationHiveBoxName = 'userLocationBox';
  static String localUserLocationHiveBoxKey = 'user_location';
  static String selectedAddressHiveBoxName = 'selectedAddressBox';
  static String selectedAddressHiveBoxKey = 'selected_address';
  static String userHiveBoxName = 'UserDataBox';
  static ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  static bool get isDemo => SettingsData.instance.system?.demoMode ?? false;
  static String get demoModeMessage =>
      SettingsData.instance.system?.customerDemoModeMessage ??
      'This is operation is allowed in Demo Mode.';
  static String get demoModeLocationMessage =>
      SettingsData.instance.system?.customerLocationDemoModeMessage ??
      'Demo mode is enabled. Location will default automatically.';

  static String defaultLat = '';
  static String defaultLng = '';

  static String get currency =>
      SettingsData.instance.system?.currencySymbol ?? '₹';

  static IconData wishListedIcon = TablerIcons.bookmark_filled;
  static IconData notWishListedIcon = TablerIcons.bookmark;
  static String authMessage =
      'Please log in to continue. This helps us save your preferences and keep your shopping journey seamless.';

  static Map<String, dynamic> defaultFullAddress = {
    "address_line1": "Bhuj",
    "address_line2": "",
    "city": "Bhuj",
    "landmark": "Hospital road",
    "state": "Gujarat",
    "zipcode": "370001",
    "mobile": "9000000000",
    "address_type": "home",
    "country": "India",
    "country_code": "IN",
    "latitude": 23.2420,
    "longitude": 69.6669
  };
}

class MediaQueryHelper {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

bool isTablet(BuildContext context) {
  final shortestSide = MediaQuery.of(context).size.shortestSide;
  return shortestSide >= 600;
}

bool isCartItemReachedMaxLimit(BuildContext context) {
  final int totalCartItems = context.read<GetUserCartBloc>().totalCartItems;
  final maxCartItemLimit =
      SettingsData.instance.system?.maximumItemsAllowedInCart ?? 0;
  final bool isCartItemReachedMax = totalCartItems >= maxCartItemLimit;
  return isCartItemReachedMax;
}

double getMaxCrossAxisExtent(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth > 500) {
    return 200.w; // Large screens (e.g., desktops)
  } else if (screenWidth > 300) {
    return 150.w; // Tablets
  } else {
    return 120.w; // Phones
  }
}

String formatIsoDateToCustomFormat(String isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  final formatter = DateFormat('dd MMM yyyy', 'en_US');
  return formatter.format(dateTime);
}

String capitalizeFirstLetter(String s) {
  if (s.isEmpty) return s; // Handle empty string

  int firstLetterIndex = 0;
  while (firstLetterIndex < s.length &&
      !RegExp(r'[a-zA-Z]').hasMatch(s[firstLetterIndex])) {
    firstLetterIndex++;
  }

  if (firstLetterIndex >= s.length) return s;

  return s.substring(0, firstLetterIndex) +
      s[firstLetterIndex].toUpperCase() +
      s.substring(firstLetterIndex + 1);
}

String formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return 'N/A';

  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  final day = dateTime.day;
  final month = months[dateTime.month - 1];
  final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour >= 12 ? 'pm' : 'am';

  return '$day $month, $hour:$minute $period';
}

String normalize(String input) {
  return input.trim().replaceAll(RegExp(r'\s+'), '').toLowerCase();
}

String formatPrice(num value, {String locale = 'en_IN'}) {
  final formatter = NumberFormat.decimalPattern(locale);
  return formatter.format(value);
}

List<String> removeUnderscoresFromStringList(List<String> labels) {
  return labels.map((label) => label.replaceAll('_', ' ')).toList();
}

String removeUnderscores(String label) {
  return label.replaceAll('_', ' ').trim();
}

// 1) Add a hex parser (utility or extension)
Color? hexStringToColor(String? hex) {
  if (hex == null) return null;
  var value = hex.trim();
  if (value.isEmpty) return null;

  // Remove leading '#'
  if (value.startsWith('#')) value = value.substring(1);

  // Support shorthand 3/4-digit? If needed, expand here; otherwise only 6/8.
  if (value.length == 6) {
    // RRGGBB -> AARRGGBB with alpha FF
    value = 'FF$value';
  } else if (value.length == 8) {
    // already AARRGGBB
  } else {
    return null; // invalid length
  }

  try {
    final intColor = int.parse(value, radix: 16);
    return Color(intColor);
  } catch (_) {
    return null;
  }
}

Future<FormData> formDataWithImages({
  required Map<String, dynamic> fields,
  required List<XFile> images,
  required String imageFieldLabel,
}) async {
  final data = FormData.fromMap(fields);
  for (int i = 0; i < images.length; i++) {
    final xfile = images[i];

    // This is the MOST important part
    final multipartFile = await MultipartFile.fromFile(
      xfile.path,
      filename: xfile.name.isNotEmpty ? xfile.name : 'image_$i.jpg',
    );

    // Correct key: 'images[]' → tells PHP/Laravel to treat as array
    data.files.add(MapEntry('$imageFieldLabel[]', multipartFile));
  }
  return data;
}

class ItemStatus {
  final String? message;
  final Color color;
  final IconData icon;

  ItemStatus({this.message, required this.color, required this.icon});
}

ItemStatus getItemStatus(OrderItems item) {
  // 1. Cancelled or Rejected
  if (item.status == 'rejected') {
    return ItemStatus(
      message: 'This product was not approved by the seller',
      color: AppTheme.errorColor,
      icon: Icons.error_outline,
    );
  }

  if (item.status == 'cancelled') {
    return ItemStatus(
      message: 'This item has been cancelled',
      color: AppTheme.errorColor,
      icon: Icons.cancel_outlined,
    );
  }

  // 2. No return → normal item
  if (item.returns == null || item.returns!.isEmpty) {
    return ItemStatus(color: Colors.transparent, icon: Icons.info);
  }

  final returnData = item.returns!.first;
  final returnStatus = returnData.returnStatus;
  final pickupStatus = returnData.pickupStatus ?? 'pending';
  final refundAmount = returnData.refundAmount ?? 0;

  switch (returnStatus) {
    case 'requested':
      return ItemStatus(
        message: 'Return request submitted successfully',
        color: Colors.orange.shade700,
        icon: Icons.access_time,
      );

    case 'seller_approved':
      switch (pickupStatus) {
        case 'scheduled':
          return ItemStatus(
            message: 'Pickup scheduled! Delivery partner will contact you soon',
            color: Colors.blue.shade600,
            icon: Icons.schedule,
          );
        case 'in_transit':
          return ItemStatus(
            message: 'Delivery partner is on the way to collect your return',
            color: Colors.blue.shade700,
            icon: Icons.local_shipping_outlined,
          );
        case 'picked_up':
          return ItemStatus(
            message: 'Return picked up successfully',
            color: AppTheme.successColor,
            icon: Icons.check_circle_outline,
          );
        case 'failed':
          return ItemStatus(
            message: 'Pickup failed. Will be rescheduled soon',
            color: AppTheme.errorColor,
            icon: Icons.error_outline,
          );
        default: // pending
          return ItemStatus(
            message: 'Return approved! Waiting for pickup to be scheduled',
            color: Colors.orange.shade700,
            icon: Icons.pending_actions,
          );
      }

    case 'picked_up':
      return ItemStatus(
        message: 'Return collected & on the way to warehouse',
        color: AppTheme.successColor,
        icon: Icons.inventory_2_outlined,
      );

    case 'received':
      return ItemStatus(
        message: 'Return received at warehouse. Processing your refund...',
        color: AppTheme.successColor,
        icon: Icons.warehouse_outlined,
      );

    case 'refund_processed':
      return ItemStatus(
        message: '₹$refundAmount refunded successfully!',
        color: AppTheme.successColor,
        icon: Icons.check_circle,
      );

    case 'rejected':
      return ItemStatus(
        message: 'Return request rejected by seller',
        color: AppTheme.errorColor,
        icon: Icons.block,
      );

    case 'cancelled':
      return ItemStatus(
        message: 'Return request has been cancelled.',
        color: AppTheme.successColor,
        icon: Icons.check_circle,
      );

    default:
      return ItemStatus(
        message: 'Return in progress',
        color: Colors.orange.shade700,
        icon: Icons.sync,
      );
  }
}

Future<void> makePhoneCall(
    {required String phoneNumber, required BuildContext context}) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    if (context.mounted) {
      ToastManager.show(context: context, message: 'Could not launch dialer');
    }
  }
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

String getAppLogoUrl(BuildContext context) {
  // bool isDark = Theme.of(context).brightness == Brightness.dark;
  // const String lightLogoUrl = 'assets/images/app_logos/app-logo-light.png';
  const String darkLogoUrl = "assets/images/app_logos/app-logo-dark.png";
  return darkLogoUrl;
}

String getAppLogoWhite(BuildContext context) {
  // bool isDark = Theme.of(context).brightness == Brightness.dark;
  const String lightLogoUrl = 'assets/images/app_logos/app-logo-light.png';
  // const String darkLogoUrl = "assets/images/app_logos/app-logo-dark.png";
  return lightLogoUrl;
}

String generateId(double lat, double lng, String? address) {
  final cleanAddress = (address ?? '').trim().toLowerCase();
  final key =
      '${lat.toStringAsFixed(6)}_${lng.toStringAsFixed(6)}_$cleanAddress';
  return key.hashCode.toString(); // or use uuid.v5 if you want
}
