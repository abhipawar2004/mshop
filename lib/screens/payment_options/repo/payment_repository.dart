import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/payment_config.dart';
import 'package:hyper_local/config/settings_data_instance.dart';
import 'package:hyper_local/screens/payment_options/widgets/webview_payment.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe hide PaymentMethodType;

/// Repository class to handle all payment gateway integrations
/// Add your payment gateway SDK imports here as needed
class PaymentRepository {
  // Singleton pattern
  static final PaymentRepository _instance = PaymentRepository._internal();
  factory PaymentRepository() => _instance;
  PaymentRepository._internal();

  Future<Map<String, dynamic>> initiatePayment({
    required BuildContext context,
    required PaymentMethodType paymentMethodType,
    required double amount,
    required bool addMoneyToWallet,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      switch (paymentMethodType) {
        case PaymentMethodType.razorpay:
          return await _initiateRazorpayPayment(
            context: context,
            amount: amount,
            additionalData: additionalData,
            addMoneyToWallet: addMoneyToWallet
          );

        case PaymentMethodType.stripe:
          return await _initiateStripePayment(
            context: context,
            amount: amount,
            additionalData: additionalData,
            addMoneyToWallet: addMoneyToWallet
          );

        case PaymentMethodType.paystack:
          return await _initiatePaystackPayment(
            context: context,
            amount: amount,
            additionalData: additionalData,
            addMoneyToWallet: addMoneyToWallet
          );

        case PaymentMethodType.paypal:
          return {};

        case PaymentMethodType.flutterwave:
          return await _initiateFlutterWavePayment(
              context: context,
              amount: amount,
              additionalData: additionalData,
              addMoneyToWallet: addMoneyToWallet
          );

        case PaymentMethodType.wallet:
          return {};

        case PaymentMethodType.cod:
          return {};

        default:
          return {
            'success': false,
            'error': 'Payment method not supported',
          };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Payment failed: ${e.toString()}',
      };
    }
  }

  // ============================================================================
  // RAZORPAY PAYMENT
  // ============================================================================

  Future<Map<String, dynamic>> _initiateRazorpayPayment({
    required BuildContext context,
    required double amount,
    Map<String, dynamic>? additionalData,
    required bool addMoneyToWallet,
  }) async {
    try {
      dynamic response;

      if(addMoneyToWallet) {
        response = await AppConstant.apiBaseHelper.postAPICall(
            ApiRoutes.prepareWalletRechargeApi,
            {
              "amount": amount.toInt(),
              "payment_method": 'razorpayPayment',
              "description": ''
            }
        );
      } else {
        response = await AppConstant.apiBaseHelper.postAPICall(
            ApiRoutes.razorpayApi,
            {
              "amount": amount,
              "currency": 'INR',
              // "currency": SettingsData.instance.system?.currency.toString(),
              "receipt": DateTime.now().toString()
            }
        );
      }

      if (response.data['success'] == true) {
        final Completer<Map<String, dynamic>> paymentCompleter = Completer<Map<String, dynamic>>();

        final razorpay = Razorpay();

        final walletResponse = response.data['data']['payment_response'];
        final normalResponse = response.data['data'];

        final int finalAmount = addMoneyToWallet
            ? (walletResponse['amount_due'] is int
            ? walletResponse['amount_due']
            : double.tryParse(walletResponse['amount_due'].toString())?.toInt() ?? 0)
            : (amount * 100).toInt();

        final String? finalOrderId = addMoneyToWallet
            ? walletResponse['id']
            : normalResponse['id'] ?? normalResponse['order_id'];

        var options = {
          'key': SettingsData.instance.payment!.razorpayKeyId,
          'amount': finalAmount,
          'name': AppConstant.appName,
          'description': addMoneyToWallet ? 'Recharge' : 'Order',
          'order_id': finalOrderId,
          'prefill': {
            'contact': additionalData?['phone'] ?? '',
            'email': additionalData?['email'] ?? ''
          },
        };

        razorpay.open(options);

        razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {

          // Complete the future with success result
          if (!paymentCompleter.isCompleted) {
            paymentCompleter.complete({
              'success': true,
              'message': 'Payment done successfully',
              'signature': response.signature,
              'order_id': response.orderId,
              'payment_id': response.paymentId,
            });
          }
          // Clean up
          razorpay.clear();
        });

        // Error callback
        razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {

          // Complete the future with error result
          if (!paymentCompleter.isCompleted) {
            paymentCompleter.complete({
              'success': false,
              'message': response.message ?? 'Payment failed',
              'error_code': response.code,
              'error_description': response.error?.toString(),
            });
          }

          // Clean up
          razorpay.clear();
        });

        // External wallet callback (optional)
        razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {

          if (!paymentCompleter.isCompleted) {
            paymentCompleter.complete({
              'success': false,
              'message': 'Payment cancelled - External wallet selected',
              'wallet_name': response.walletName,
            });
          }

          razorpay.clear();
        });

        // Wait for payment completion and return result
        return await paymentCompleter.future;

      } else {
        return {
          'success': false,
          'error': 'Razorpay integration pending',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Razorpay payment failed: ${e.toString()}',
      };
    }
  }


  // ============================================================================
  // STRIPE PAYMENT
  // ============================================================================
  Future<Map<String, dynamic>> _initiateStripePayment({required BuildContext context, required double amount, Map<String, dynamic>? additionalData, required bool addMoneyToWallet,}) async {
    try {
      final paymentSettings = SettingsData.instance.payment;

      // Validation
      if (paymentSettings?.stripePublishableKey.isEmpty != false) {
        return {'success': false, 'error': 'Stripe not configured'};
      }

      // Initialize Stripe
      stripe.Stripe.publishableKey = paymentSettings!.stripePublishableKey;

      // Create Payment Intent
      final currency = paymentSettings.stripeCurrencyCode.isNotEmpty
          ? paymentSettings.stripeCurrencyCode
          : SettingsData.instance.system?.currency.toString();

      dynamic response;

      if(addMoneyToWallet) {
        response = await AppConstant.apiBaseHelper.postAPICall(
            ApiRoutes.prepareWalletRechargeApi,
            {
              "amount": amount.toInt(),
              "payment_method": 'stripePayment',
              "description": ''
            }
        );
      } else {
        response = await AppConstant.apiBaseHelper.postAPICall(
          ApiRoutes.stripeCreatePaymentIntentApi,
          {
            'amount': (amount * 100).round(),
            'currency': currency,
            if (additionalData != null) 'additionalData': additionalData,
          },
        );
      }

      if (response.data['success'] != true) {
        return {
          'success': false,
          'error': response.data['data']?['error'] ?? response.data['message'] ?? 'Payment failed'
        };
      }

      // Get client secret
      final data = response.data['data'] ?? {};
      final clientSecret = addMoneyToWallet ? data['payment_response']['clientSecret'].toString() : data['clientSecret'].toString();

      if (response.data['data'].isEmpty || response.data['data'] == null) {
        return {'success': false, 'error': 'Invalid payment response'};
      }

      if(context.mounted){
        await stripe.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
            merchantDisplayName: AppConstant.appName,
            paymentIntentClientSecret: clientSecret,
            googlePay: stripe.PaymentSheetGooglePay(
              merchantCountryCode: 'US',
              testEnv: true,
              currencyCode: currency,
            ),
            billingDetailsCollectionConfiguration: const stripe.BillingDetailsCollectionConfiguration(
              name: stripe.CollectionMode.always,
              email: stripe.CollectionMode.always,
            ),
            allowsDelayedPaymentMethods: true,
            style: Theme.of(context).brightness == Brightness.dark ? ThemeMode.light : ThemeMode.light,
          ),
        );
      }

      await stripe.Stripe.instance.presentPaymentSheet();

      // Extract payment ID and return success
      final paymentId = _extractPaymentId(clientSecret);

      return {
        'success': true,
        'message': 'Payment completed successfully',
        'payment_id': paymentId,
        'signature': clientSecret,
        'order_id': clientSecret,
      };

    } on stripe.StripeException catch (e) {
      return {
        'success': false,
        'error': e.error.message ?? 'Payment cancelled'
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Payment failed: ${e.toString()}'
      };
    }
  }

  // Helper function (place outside the main function)
  String _extractPaymentId(String clientSecret) {
    final parts = clientSecret.split('_');
    return parts.length >= 2 ? '${parts[0]}_${parts[1]}' : clientSecret;
  }



// ============================================================================
// PAYSTACK PAYMENT
// ============================================================================

  Future<Map<String, dynamic>> _initiatePaystackPayment({
    required BuildContext context,
    required double amount,
    Map<String, dynamic>? additionalData,
    required bool addMoneyToWallet,
  }) async {
    try {
      final paymentSettings = SettingsData.instance.payment;

      // Validation
      if (paymentSettings?.paystackPublicKey.isEmpty != false) {
        return {'success': false, 'error': 'Paystack not configured'};
      }

      dynamic response;
      if (addMoneyToWallet) {
        response = await AppConstant.apiBaseHelper.postAPICall(
            ApiRoutes.prepareWalletRechargeApi, {
          "amount": amount.toInt(),
          "payment_method": 'paystackPayment',
          "description": ''
        });
      } else {
        response = await AppConstant.apiBaseHelper.postAPICall(
          ApiRoutes.paystackCreateOrderApi,
          {
            'amount': amount.toInt(),
          },
        );
      }

      // Check if order creation was successful
      if (response.data['success'] != true) {
        return {
          'success': false,
          'error': response.data['message'] ?? 'Failed to create order',
        };
      }

      // Extract order details from response
      final data = response.data['data'] ?? {};
      // Access code is required for the new SDK
      final accessCode = data['payment_response']['access_code']?.toString();
      final authorizationUrl = data['payment_response']['authorization_url']?.toString();

      if (accessCode == null || accessCode.isEmpty || accessCode == 'null') {
        return {
          'success': false,
          'error': 'Access code not received from server',
        };
      }


      final orderId = addMoneyToWallet
          ? (data['wallet_transaction_id']?.toString() ?? accessCode)
          : (data['order_id']?.toString() ?? accessCode);

      if (!context.mounted) {
        return {'success': false, 'error': 'Context not mounted'};
      }

      // Launch Paystack WebView
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WebViewPaymentPage(
            paymentUrl: authorizationUrl!,
            onPaymentSuccess: () {},
            onPaymentFailure: () {},
          ),
        ),
      );

      if (result['success'] == true) {
        // We assume success if we got the redirect signal.
        // Ideally verify on backend with reference.

        return {
          'success': true,
          'message': 'Payment completed successfully',
          'payment_id': result['payment_id'],
          'signature': result['signature'],
          'order_id': orderId,
          'reference': result['reference'],
        };
      } else {
        return {
          'success': false,
          'error': 'Payment cancelled or failed',
        };
      }
    } catch (e) {
      log('Paystack error: $e');
      return {
        'success': false,
        'error': 'Paystack payment failed: ${e.toString()}'
      };
    }
  }

  /*Future<Map<String, dynamic>> _initiatePaystackPayment({
    required BuildContext context,
    required double amount,
    Map<String, dynamic>? additionalData,
    required bool addMoneyToWallet,
  }) async {
    try {
      final paymentSettings = SettingsData.instance.payment;

      if (paymentSettings?.paystackPublicKey.isEmpty ?? true) {
        return {'success': false, 'error': 'Paystack not configured'};
      }

      // 1. Call backend to initialize transaction (uses secret key there)
      dynamic response;
      if (addMoneyToWallet) {
        response = await AppConstant.apiBaseHelper.postAPICall(
          ApiRoutes.prepareWalletRechargeApi,
          {
            "amount": amount.toInt(),
            "payment_method": "paystack",
            "description": "",
          },
        );
      } else {
        response = await AppConstant.apiBaseHelper.postAPICall(
          ApiRoutes.paystackCreateOrderApi,
          {'amount': amount.toInt()},
        );
      }

      if (response.data['success'] != true) {
        return {
          'success': false,
          'error': response.data['message'] ?? 'Failed to initialize payment',
        };
      }

      final serverData = response.data['data'] ?? {};
      final accessCode = serverData['payment_response']['access_code']?.toString();
      final reference = serverData['payment_response']['reference']?.toString();
      final transactionId = serverData['transaction_id'] ?? serverData['id'];
      final orderId = addMoneyToWallet
          ? serverData['wallet_transaction_id'] ?? 'wallet_${DateTime.now().millisecondsSinceEpoch}'
          : serverData['order_id'] ?? 'order_${DateTime.now().millisecondsSinceEpoch}';

      print('UFBOUIFBEUIOF  ${accessCode}');
      print('UFBOUIFBEUIOF  ${reference}');
      if (accessCode == null || reference == null) {
        return {'success': false, 'error': 'Missing access_code or reference from server'};
      }

      // Amount should come from server already in **kobo** (Paystack uses smallest unit)
      final amountInKobo = serverData['amount'] ?? (amount * 100).round();

      if (context.mounted) {
        final paystack = PaystackService.instance;
        final paymentResult = await paystack.launch(accessCode);
        developer.log('Launch result - status: ${paymentResult.status}, message: ${paymentResult.message}, ref: ${paymentResult.reference}');
        // Initialize with public key (do this once in app, e.g. in main or provider)
        // paystack.initialize(publicKey: paymentSettings.paystackPublicKey);

        // Now launch payment
        // final paymentResult = await paystack.launch(
        //   accessCode,
        // );

        print('Paystack patment  ${paymentResult.status}');
        print('Paystack patment  ${paymentResult.message}');
        print('Paystack patment  ${paymentResult.reference}');

        if (paymentResult.status == 'success') {
          // Payment appears successful on client → but always verify on backend!
          log('Payment UI completed: ${paymentResult.reference}');

          // You should still call your backend to verify & update wallet/order
          // e.g. await verifyPaymentOnBackend(reference);

          return {
            'success': true,
            'message': 'Payment completed',
            'reference': paymentResult.reference,
            'order_id': orderId,
            'payment_id': reference,
          };
        } else {
          return {
            'success': false,
            'error': paymentResult.message ?? 'Payment cancelled or failed',
          };
        }
      } else {
        return {'success': false, 'error': 'Context not mounted'};
      }
    } catch (e) {
      log('Paystack error: $e');
      return {'success': false, 'error': 'Payment initiation failed: $e'};
    }
  }*/



  String generateSimpleReference() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'REF_$timestamp';
  }



  Future<Map<String, dynamic>> _initiateFlutterWavePayment({
    required BuildContext context,
    required double amount,
    Map<String, dynamic>? additionalData,
    required bool addMoneyToWallet,
  }) async {
    try {
      dynamic response;

      if(addMoneyToWallet) {
        response = await AppConstant.apiBaseHelper.postAPICall(
            ApiRoutes.prepareWalletRechargeApi,
            {
              "amount": amount.toInt(),
              "payment_method": 'flutterwavePayment',
              "description": ''
            }
        );
      }

      if (response.data['success'] != true) {
        return {
          'success': false,
          'error': response.data['data']?['error'] ?? response.data['message'] ?? 'Payment failed'
        };
      }

      // Get client secret
      final data = response.data['data'] ?? {};

      if (response.data['data'].isEmpty || response.data['data'] == null) {
        return {'success': false, 'error': 'Invalid payment response'};
      }

      return {
        'success': true,
        'message': 'Payment completed successfully',
        'payment_id': data['payment_response']['link'],
        'signature': data['payment_response']['link'],
        'order_id': data['payment_response']['link'],
      };

    } catch (e) {
      return {
        'success': false,
        'error': 'Payment failed: ${e.toString()}'
      };
    }
  }
}