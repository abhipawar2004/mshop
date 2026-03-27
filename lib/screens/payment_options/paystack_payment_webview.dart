import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

class PaystackPaymentWebView extends StatefulWidget {
  final String accessCode;
  final String? authorizationUrl;
  final Function(String ref) onSuccess;
  final VoidCallback onCancel;

  const PaystackPaymentWebView({
    super.key,
    required this.accessCode,
    this.authorizationUrl,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  State<PaystackPaymentWebView> createState() => _PaystackPaymentWebViewState();
}

class _PaystackPaymentWebViewState extends State<PaystackPaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final String checkoutUrl = widget.authorizationUrl ?? 'https://checkout.paystack.com/${widget.accessCode}';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Handle error
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('standard.paystack.co/close') || request.url.contains('paystack.co/close')) {
               // Verify reference here if possible, or just treat as close/success signal
               Navigator.of(context).pop('success'); 
               return NavigationDecision.prevent;
            }
            
            if (request.url.contains('cancel')) {
               Navigator.of(context).pop('cancel');
               return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.paystackPaymentTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop('cancel'),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
