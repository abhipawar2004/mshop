import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../l10n/app_localizations.dart';

class WebViewPaymentPage extends StatefulWidget {
  final Function()? onPaymentSuccess;
  final Function()? onPaymentFailure;
  final String paymentUrl;

  const WebViewPaymentPage({
    super.key,
    this.onPaymentSuccess,
    required this.onPaymentFailure,
    required this.paymentUrl
  });

  @override
  State<WebViewPaymentPage> createState() => _WebViewPaymentPageState();
}

class _WebViewPaymentPageState extends State<WebViewPaymentPage> {
  late final WebViewController _controller;
  bool isLoading = true;
  late String checkoutUrl = '';

  // Flag to track if we've already handled redirection
  bool hasRedirected = false;

  @override
  void initState() {
    super.initState();
    checkoutUrl = widget.paymentUrl;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            _checkForRedirection(url);
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            _checkForRedirection(url);
          },
          onUrlChange: (UrlChange change) {
            _checkForRedirection(change.url ?? '');
          },
          onWebResourceError: (WebResourceError error) {
          },
          onNavigationRequest: (NavigationRequest request) {
            _checkForRedirection(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(checkoutUrl));
  }

  void _checkForRedirection(String url) {
    log('Redirection URL $url');
    if (hasRedirected) return;
    if (url.contains('success') ||
        url.contains('payment_intent=succeeded') ||
        url.contains('status=succeeded') ||
        url.contains('status=completed') ||
        url.contains('payment_status=paid') || url.contains('trxref')) {

      final uri = Uri.parse(url);
      final ref = uri.queryParameters['reference'] ?? uri.queryParameters['trxref'];
      hasRedirected = true;
      _handleSuccess(ref);

    } else if (url.contains('cancel') ||
        url.contains('payment_intent=failed') ||
        url.contains('status=failed') ||
        url.contains('error')) {

      hasRedirected = true;
      _handleFailure();
    }
  }

  void _handleSuccess(String? reference) {
    // Show success message
    ToastManager.show(
        context: context,
        message: AppLocalizations.of(context)!.paymentSuccessful,
        type: ToastType.success
    );

    // Delay to allow the user to see the message
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop({
          'success': true,
          'message': 'Payment completed successfully',
          'payment_id': reference,
          'signature': reference,
          'order_id': reference,
          'reference': reference,
        });
      }
    });
  }

  void _handleFailure() {
    // Show failure message
    ToastManager.show(
      context: context,
      message: AppLocalizations.of(context)!.paymentFailedOrCancelled,
      type: ToastType.error
    );

    // Delay to allow the user to see the message
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop({
          'success': false,
          'error': 'Payment cancelled or failed',
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: hasRedirected,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !hasRedirected) {
          // If user tried to pop but we're not allowing it, treat as cancellation
          _handleFailure();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0F2027),
          title: Text(
            AppLocalizations.of(context)!.paymentMethod,
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Handle manual back button press
              if (!hasRedirected) {
                _handleFailure();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (isLoading)
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF2C5364),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.loadingPaymentPage,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF203A43),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}