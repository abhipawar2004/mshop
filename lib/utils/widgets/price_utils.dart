import '../../config/constant.dart';

class PriceUtils {
  /// Calculate discount percentage
  static int calculateDiscountPercentage(double originalPrice, double salePrice) {
    if (originalPrice <= 0 || salePrice <= 0) return 0;
    if (salePrice >= originalPrice) return 0;

    final discount = ((originalPrice - salePrice) / originalPrice) * 100;
    return discount.round();
  }

  /// Format price with currency symbol
  static String formatPrice(double price) {
    if (price == price.toInt()) {
      return '${AppConstant.currency}${price.toInt()}';
    }
    return '${AppConstant.currency}${price.toStringAsFixed(0)}';
  }

  /// Check if there's a valid discount
  static bool hasDiscount(double originalPrice, double salePrice) {
    return originalPrice > 0 && salePrice > 0 && salePrice < originalPrice;
  }

  /// Get discount amount
  static double getDiscountAmount(double originalPrice, double salePrice) {
    if (!hasDiscount(originalPrice, salePrice)) return 0.0;
    return originalPrice - salePrice;
  }
}
