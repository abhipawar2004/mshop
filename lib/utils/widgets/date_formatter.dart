import 'package:intl/intl.dart';

class DateFormatter {
  static String formatOrderPlaced(String backendDateTime) {
    final DateTime dt = DateTime.parse(backendDateTime);
    return DateFormat('EEE, dd MMM\'yy, hh:mm a').format(dt);
    // Output: Mon, 24 Nov'25, 09:13 AM
  }

  // Bonus: Other useful formats
  static String fullDate(String backendDateTime) {
    return DateFormat('dd MMMM yyyy, hh:mm a').format(DateTime.parse(backendDateTime));
    // → 24 November 2025, 09:13 AM
  }

  static String relativeTime(String backendDateTime) {
    final DateTime date = DateTime.parse(backendDateTime);
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(date);

    if (diff.inDays >= 7) {
      return DateFormat('dd MMM yyyy').format(date); // 24 Nov 2025
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }
}