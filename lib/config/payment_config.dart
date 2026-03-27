import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import 'settings_data_instance.dart';

/// Enum for payment method types
enum PaymentMethodType {
  razorpay,
  stripe,
  paystack,
  phonepe,
  paypal,
  flutterwave,
  wallet,
  cod,
}

/// Model class for payment method configuration
class PaymentMethod {
  final PaymentMethodType type;
  final String id;
  final String name;
  final String? logoPath;
  final IconData? icon;
  final Color? color;
  final bool isOnline;
  final bool isAvailable;

  const PaymentMethod({
    required this.type,
    required this.id,
    required this.name,
    this.logoPath,
    this.icon,
    this.color,
    required this.isOnline,
    this.isAvailable = true,
  });

  /// Get the display logo/icon widget
  Widget getDisplayWidget({double size = 24.0}) {
    if (logoPath != null) {
      return CustomImageContainer(
        imagePath:  logoPath!,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    } else if (icon != null) {
      return Icon(
        icon!,
        size: size,
        color: color ?? Colors.grey,
      );
    } else {
      return Icon(
        Icons.payment,
        size: size,
        color: Colors.grey,
      );
    }
  }
}

/// Centralized payment configuration class
class PaymentConfig {
  static const String _logoBasePath = 'assets/images/payment-logos/';

  /// All available payment methods configuration
  static final List<PaymentMethod> _paymentMethods = [
    // Online Payment Methods
    PaymentMethod(
      type: PaymentMethodType.razorpay,
      id: 'razorpay',
      name: 'Razorpay',
      logoPath: '${_logoBasePath}razorpay.png',
      isOnline: true,
    ),
    PaymentMethod(
      type: PaymentMethodType.stripe,
      id: 'stripe',
      name: 'Stripe',
      logoPath: '${_logoBasePath}stripe.png',
      isOnline: true,
    ),
    PaymentMethod(
      type: PaymentMethodType.paystack,
      id: 'paystack',
      name: 'Paystack',
      logoPath: '${_logoBasePath}paystack.png',
      isOnline: true,
    ),
    PaymentMethod(
      type: PaymentMethodType.paypal,
      id: 'paypal',
      name: 'PayPal',
      logoPath: '${_logoBasePath}pay-pal.png',
      isOnline: true,
    ),
    PaymentMethod(
      type: PaymentMethodType.flutterwave,
      id: 'flutterwave',
      name: 'Flutterwave',
      logoPath: '${_logoBasePath}pay-pal.png',
      isOnline: true,
    ),

    PaymentMethod(
      type: PaymentMethodType.cod,
      id: 'cod',
      name: 'Cash on Delivery',
      logoPath: '${_logoBasePath}cash-on-delivery.png',
      icon: TablerIcons.coins,
      color: Colors.grey,
      isOnline: false,
    ),
  ];

  /// Get all online payment methods
  static List<PaymentMethod> get onlinePaymentMethods {
    return _paymentMethods.where((method) => method.isOnline).toList();
  }

  /// Get all wallet and COD payment methods
  static List<PaymentMethod> get walletAndCODPaymentMethods {
    return _paymentMethods.where((method) => !method.isOnline).toList();
  }

  /// Get all available payment methods
  static List<PaymentMethod> get allPaymentMethods {
    return _paymentMethods.where((method) => method.isAvailable).toList();
  }

  /// Get payment method by ID
  static PaymentMethod? getPaymentMethodById(String id) {
    try {
      return _paymentMethods.firstWhere((method) => method.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get payment method by type
  static PaymentMethod? getPaymentMethodByType(PaymentMethodType type) {
    try {
      return _paymentMethods.firstWhere((method) => method.type == type);
    } catch (e) {
      return null;
    }
  }

  /// Get payment method display name
  static String getPaymentMethodName(String id) {
    final method = getPaymentMethodById(id);
    return method?.name ?? 'Unknown';
  }

  /// Get payment method display widget
  static Widget getPaymentMethodWidget(String id, {double size = 24.0}) {
    final method = getPaymentMethodById(id);
    return method?.getDisplayWidget(size: size) ?? 
           Icon(Icons.payment, size: size, color: Colors.grey);
  }

  /// Check if a payment method is enabled in settings
  static bool isPaymentMethodEnabledInSettings(String id) {
    final paymentSettings = SettingsData.instance.payment;
    if (paymentSettings == null) return true; // Default to enabled if settings not loaded
    
    switch (id) {
      case 'stripe':
        return paymentSettings.stripePayment;
      case 'razorpay':
        return paymentSettings.razorpayPayment;
      case 'cod':
        return paymentSettings.cod;
      case 'paystack':
        return paymentSettings.paystackPayment;
      case 'paypal':
        return false;
      case 'flutterwave':
        return paymentSettings.flutterWavePayment;
      default:
        return false;
    }
  }

  /// Get payment methods filtered by settings availability
  static List<PaymentMethod> getEnabledPaymentMethods() {
    return _paymentMethods.where((method) => 
      method.isAvailable && isPaymentMethodEnabledInSettings(method.id)
    ).toList();
  }

}