import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';

import '../../../config/settings_data_instance.dart';

/// Enum that represents every policy you need.
enum PolicyType {
  aboutUs,
  privacyPolicy,
  termsAndConditions,
  refundPolicy,
  shippingPolicy,
  // add more here if needed
}

/// Extension to get a human-readable title for the AppBar.
extension PolicyTitle on PolicyType {
  String get title {
    switch (this) {
      case PolicyType.aboutUs:
        return 'About Us';
      case PolicyType.privacyPolicy:
        return 'Privacy Policy';
      case PolicyType.termsAndConditions:
        return 'Terms & Conditions';
      case PolicyType.refundPolicy:
        return 'Refund Policy';
      case PolicyType.shippingPolicy:
        return 'Shipping Policy';
    }
  }

  /// Returns the HTML string from SettingsData (or an empty string if missing).
  String get htmlContent {
    final web = SettingsData.instance.web;
    switch (this) {
      case PolicyType.aboutUs:
        return web?.aboutUs ?? '';
      case PolicyType.privacyPolicy:
        return web?.privacyPolicy ?? '';
      case PolicyType.termsAndConditions:
        return web?.termsCondition ?? '';
      case PolicyType.refundPolicy:
        return web?.returnRefundPolicy ?? '';
      case PolicyType.shippingPolicy:
        return web?.shippingPolicy ?? '';
    }
  }
}

/// Reusable policy page.
class PolicyPage extends StatelessWidget {
  final PolicyType policyType;

  const PolicyPage({super.key, required this.policyType});

  @override
  Widget build(BuildContext context) {
    final String html = policyType.htmlContent;
    final String title = policyType.title;

    return CustomScaffold(
      showViewCart: false,
      showAppBar: true,
      title: title,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: SingleChildScrollView(
          child: Html(
            shrinkWrap: true,
            data: html,
          ),
        ),
      ),
    );
  }
}