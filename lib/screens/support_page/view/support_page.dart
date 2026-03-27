import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/settings_data_instance.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/constant.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  String phoneNumber = '';
  String email = '';

  @override
  void initState() {
    // TODO: implement initState
    phoneNumber = SettingsData.instance.web?.supportNumber ?? '';
    email = SettingsData.instance.web?.supportEmail ?? '';
    super.initState();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    ToastManager.show(
      context: context,
      message: AppLocalizations.of(context)!.emailCopied
    );
  }

  @override
  Widget build(BuildContext context) {

    return CustomScaffold(
      showViewCart: false,
      title: AppLocalizations.of(context)!.support,
      showAppBar: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Phone Card
            _buildContactCard(
              context: context,
              icon: Icons.phone,
              title: AppLocalizations.of(context)!.callUs,
              subtitle: phoneNumber,
              onTap: () => _launchUrl('tel:$phoneNumber'),
              onLongPress: () => _copyToClipboard(context, phoneNumber, AppLocalizations.of(context)!.phoneNumberCopied),
            ),

            SizedBox(height: 16.h),

            // Email Card
            _buildContactCard(
              context: context,
              icon: Icons.email,
              title: AppLocalizations.of(context)!.emailUs,
              subtitle: email,
              onTap: () => _launchUrl('mailto:$email?subject=Support Request'),
              onLongPress: () => _copyToClipboard(context, email, AppLocalizations.of(context)!.emailCopied),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(15.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: isTablet(context) ? 18.r : 22.r,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              child: Icon(icon, color: AppTheme.primaryColor, size: isTablet(context) ? 22.r : 22.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: isTablet(context) ? 20 : 14.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: isTablet(context) ? 18 : 12.sp, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Icons.touch_app, size: isTablet(context) ? 14.r : 15.sp, color: Colors.grey.shade400),
                SizedBox(height: 4.h),
                Text(
                  AppLocalizations.of(context)!.tapToContact,
                  style: TextStyle(fontSize: isTablet(context) ? 14 : 8.sp, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}