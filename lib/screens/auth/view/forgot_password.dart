import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/auth/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/custom_textfield.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:hyper_local/utils/widgets/whole_page_progress.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  bool _isDisabled = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorMessage = null;
        _isDisabled = true;
      });
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      setState(() {
        _errorMessage = "Please enter valid email.";
        _isDisabled = true;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isDisabled = false;
    });
  }

  void _handleSendResetLink(BuildContext context) {
    if (_emailController.text.isNotEmpty && !_isDisabled) {
      context
          .read<ForgotPasswordBloc>()
          .add(UserForgotPassword(email: _emailController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        log('Forgot Password State $state');
        if (state is ForgotPasswordSuccess) {
          ToastManager.show(
            context: context,
            message: state.message.isNotEmpty
                ? state.message
                : 'Password reset link sent to your email',
            type: ToastType.success,
          );
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              GoRouter.of(context).pushReplacement(AppRoutes.login);
            }
          });
        }
        else if (state is ForgotPasswordFailed) {
          setState(() {
            _errorMessage = state.message.isNotEmpty
                ? state.message
                : "We can't find a user with that email address.";
          });
          ToastManager.show(
            context: context,
            message: state.message.isNotEmpty
                ? state.message
                : 'Failed to send reset link',
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;
        return Stack(
          children: [
            CustomScaffold(
              showViewCart: false,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, size: 20.sp),
                  onPressed: () => GoRouter.of(context).pop(),
                ),
                title: const Text(''),
                elevation: 0,
              ),
              body: _buildBody(isLoading),
            ),
            if(isLoading)
              WholePageProgress()
          ],
        );
      },
    );
  }

  Widget _buildBody(bool isLoading) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),

            // Icon Container with subtle shadow
            Container(
              padding: EdgeInsets.all(28.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.lock_reset_rounded,
                color: Colors.white,
                size: 48.sp,
              ),
            ),

            SizedBox(height: 32.h),

            // Title
            Text(
              'Forgot Password?',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),

            SizedBox(height: 12.h),

            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                "Don't worry! Enter your email and we'll send you instructions to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 15.sp,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            ),

            SizedBox(height: 40.h),

            // Email Input with enhanced styling
            CustomTextFormField(
              controller: _emailController,
              hintText: AppLocalizations.of(context)!.emailAddress,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              enabled: !isLoading,
              onChanged: _validateEmail,
            ),

            // Error Message
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _errorMessage != null ? null : 0,
              child: _errorMessage != null
                  ? Column(
                children: [
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.red[200]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red[700],
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 13.sp,
                              color: Colors.red[700],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  : const SizedBox.shrink(),
            ),

            SizedBox(height: 32.h),

            // Send Button
            CustomButton(
              text: isLoading ? 'Sending...' : 'Send Reset Link',
              onPressed: () => _handleSendResetLink(context),
              isDisabled: _isDisabled || isLoading,
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}