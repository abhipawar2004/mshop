import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/global.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/auth/bloc/user_verification/user_verification_bloc.dart';
import 'package:hyper_local/screens/auth/bloc/user_verification/user_verification_event.dart';
import 'package:hyper_local/screens/auth/bloc/user_verification/user_verification_state.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import 'package:hyper_local/utils/widgets/custom_textfield.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:hyper_local/utils/widgets/whole_page_progress.dart';

import '../../../config/constant.dart';
import '../../cart_page/bloc/get_user_cart/get_user_cart_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../widgets/social_button_widget.dart';
import '../../../l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _identifierFieldKey = GlobalKey<FormFieldState>();

  bool _isPasswordVisible = false;

  // Verification feedback
  bool? isUserVerified;
  String? helperText;
  Widget? statusIcon;
  String? inputHint;

  // Animation controllers
  late AnimationController _slideController;

  static const String _demoEmail = '9000000000';
  static const String _demoPassword = '12345678';

  // Debounce
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    if (AppConstant.isDemo) {
      _identifierController.text = _demoEmail;
      _passwordController.text = _demoPassword;
      // Immediately trigger the verification logic for the pre-filled demo data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleIdentifierChange(_identifierController.text);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _slideController.forward());
  }

  // Smart Detection: Email or Phone?
  String _detectInputType(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return 'empty';

    if (RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trimmed)) {
      return 'email';
    }

    final digitsOnly = trimmed.replaceAll(RegExp(r'[^\d+]'), '');
    if (digitsOnly.length >= 5 && digitsOnly.length <= 15) {
      return 'phone';
    }

    return 'invalid';
  }

  bool _isValidEmail(String s) => _detectInputType(s) == 'email';
  bool _isValidPhone(String s) => _detectInputType(s) == 'phone';
  bool _isValidIdentifier(String s) => _isValidEmail(s) || _isValidPhone(s);

  void _handleIdentifierChange(String value) {
    _debounceTimer?.cancel();

    final type = _detectInputType(value);

    if (type == 'empty' || type == 'invalid') {
      context.read<UserVerificationBloc>().add(ResetVerification());
      return;
    }

    _debounceTimer = Timer(_debounceDuration, () {
      if (_identifierController.text.trim() == value.trim()) {
        if (type == 'email') {
          context.read<UserVerificationBloc>().add(VerifyUser(
              value: value.trim(), type: type));
        } else {
          // Normalize phone: remove all non-digits except +
          String cleanPhone = value.replaceAll(RegExp(r'[^\d+]'), '');
          context.read<UserVerificationBloc>().add(VerifyUser(value: cleanPhone, type: 'mobile'));
        }
      }
    });
  }

  void _handleLogin() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    if (isUserVerified != true) {
      final l10n = AppLocalizations.of(context)!;
      ToastManager.show(
        context: context,
        message: l10n.noAccountFoundWithEmailOrPhone,
        type: ToastType.error,
      );
      return;
    }

    if (_passwordController.text.isEmpty) {
      ToastManager.show(
          context: context,
          message: l10n.pleaseEnterYourPassword,
          type: ToastType.error
      );
      return;
    }

    final identifier = _identifierController.text.trim();

    context.read<AuthBloc>().add(LoginRequest(
      email: _isValidEmail(identifier) ? identifier : null,
      phoneNumber: _isValidPhone(identifier) ? identifier : null,
      password: _passwordController.text,
    ));

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                GoRouter.of(context).pushReplacement(AppRoutes.splashScreen);
                ToastManager.show(context: context, message: state.message, type: ToastType.success);
                final getUserCartBloc = context.read<GetUserCartBloc>(); // Capture here

                Future.delayed(const Duration(seconds: 1), () {
                  getUserCartBloc.add(SyncCart()); // Use captured reference – no context needed
                });
              } else if (state is AuthFailed) {
                ToastManager.show(context: context, message: state.error, type: ToastType.error);
              } else if (state is SocialAuthSuccess) {
                if (state.newUser) {
                  GoRouter.of(context).push(AppRoutes.register, extra: {'name': state.userName, 'email': state.userEmail});
                } else {
                  GoRouter.of(context).pushReplacement(AppRoutes.splashScreen);
                }
              }
            },
            builder: (context, authState) {
              return Stack(
                children: [
                  // Static background with doodle
                  _buildStaticBackground(),

                  // Scrollable content with logo and form
                  // AnimatedBuilder(
                  //   animation: _slideController,
                  //   builder: (context, _) {
                  //     return Transform.translate(
                  //       offset: Offset(0, _slideAnimation.value * 200),
                  //       child: Transform.scale(
                  //         scale: _scaleAnimation.value,
                  //         child: Opacity(
                  //           opacity: _fadeAnimation.value,
                  //           child: ,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  _buildScrollableContent(),

                  if (authState is AuthLoading) const WholePageProgress(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStaticBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        image: DecorationImage(
          image: AssetImage('assets/images/doodle.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildScrollableContent() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

          return Stack(
            children: [
              // Fixed Logo
              Positioned(
                top: 70.h,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  child: CustomImageContainer(
                    imagePath: getAppLogoUrl(context),
                    height: 120,
                  ),
                ),
              ),

              // Skip Button
              Positioned(
                top: 10.h,
                right: 20.w,
                child: InkWell(
                  onTap: () {
                    Global.setIsFirstTime(false);
                    GoRouter.of(context).go(AppRoutes.home);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return Text(
                          l10n.skip,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet(context) ? 18 : 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Main Content (scroll only when keyboard opens)
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.32,
                child: keyboardOpen
                    ? SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: _buildLoginFormContainer(),
                )
                    : _buildLoginFormContainer(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginFormContainer() {
    return BlocBuilder<UserVerificationBloc, UserVerificationState>(
      builder: (context, verificationState){
        final isVerifying = verificationState is VerifyingUser;
        final isInteractionBlocked = isVerifying || isUserVerified == false;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome text
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      return Text(
                        l10n.welcomeBack,
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: isTablet(context) ? 32 : 22.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      return Text(
                        l10n.signInToYourAccount,
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: isTablet(context) ? 18 : 12.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),

                  _buildIdentifierField(),
                  SizedBox(height: 16.h),

                  _buildPasswordField(enabled: !isVerifying),
                  SizedBox(height: 8.h),

                  GestureDetector(
                    onTap: isInteractionBlocked
                        ? null
                        : () {
                      GoRouter.of(context).push(AppRoutes.forgotPassword);
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return Text(
                            l10n.forgotPassword,
                            style: TextStyle(
                              color: isInteractionBlocked
                                  ? Colors.grey[400]
                                  : AppTheme.primaryColor,
                              fontSize: isTablet(context) ? 18 : 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                       },
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isAuthLoading = state is AuthLoading;
                      final isButtonEnabled = !isInteractionBlocked &&
                          !isAuthLoading &&
                          isUserVerified == true;

                      return SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: isVerifying
                              ? () {}
                              : isButtonEnabled
                              ? _handleLogin : () {
                            ToastManager.show(
                              context: context,
                              message: 'Please enter the empty fields',
                              type: ToastType.error
                            );
                          },
                          child: Builder(
                            builder: (context) {
                              final l10n = AppLocalizations.of(context)!;
                              return Text(
                                isVerifying
                                    ? l10n.verifying
                                    : l10n.signIn,
                                style: TextStyle(
                                  fontSize: isTablet(context) ? 28 : 16,
                                  fontFamily: AppTheme.fontFamily,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Divider
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(child: RotatedBox(quarterTurns: 2,
                        child: customDivider())),
                        SizedBox(width: 5,),
                        Builder(
                          builder: (context) {
                            final l10n = AppLocalizations.of(context)!;
                            return Text(
                              l10n.or,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: isTablet(context) ? 18 : 14,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 5,),
                        Expanded(child: customDivider()),

                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // Social buttons (disabled during verification)
                  Opacity(
                    opacity: isVerifying ? 0.5 : 1.0,
                    child: AbsorbPointer(
                      absorbing: isVerifying,
                      child: socialButton(
                        onTap: isVerifying ? (){} : () {
                          context.read<AuthBloc>().add(GoogleLoginRequest());
                        },
                        asset: 'assets/images/icons/google-logo.png',
                        background: Theme.of(context).colorScheme.surface,
                        borderColor: Colors.grey.shade300,
                        type: LoginType.google,
                        context: context
                      ),
                    ),
                  ),

                  if (Platform.isIOS) ...[
                    SizedBox(height: 16.h),
                    Opacity(
                      opacity: isVerifying ? 0.5 : 1.0,
                      child: AbsorbPointer(
                        absorbing: isVerifying,
                        child: socialButton(
                          onTap: (){
                            context.read<AuthBloc>().add(AppleLoginRequest());
                          },
                          asset: 'assets/images/icons/apple-logo.png',
                          background: Theme.of(context).colorScheme.surface,
                          borderColor: Colors.grey.shade300,
                          type: LoginType.apple,
                          context: context
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 24.h),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return Text(
                            l10n.dontHaveAnAccount,
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              color: Colors.grey[600],
                              fontSize: isTablet(context)? 18 : 14,
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(AppRoutes.register);
                        },
                        child: Builder(
                          builder: (context) {
                            final l10n = AppLocalizations.of(context)!;
                            return Text(
                              l10n.signUp,
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: isTablet(context)? 18 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIdentifierField() {
    return BlocBuilder<UserVerificationBloc, UserVerificationState>(
      builder: (context, state) {
        // Reset on empty
        if (_identifierController.text.trim().isEmpty) {

          isUserVerified = null;
          helperText = null;
          statusIcon = null;

        } else if (state is VerifyingUser) {
          final l10n = AppLocalizations.of(context)!;
          isUserVerified = null;
          helperText = l10n.verifying;
          statusIcon = SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange,));

        } else if (state is UserVerified) {
          final l10n = AppLocalizations.of(context)!;
          isUserVerified = state.isUserVerified;
          if (isUserVerified == true) {
            helperText = _detectInputType(_identifierController.text) == 'email'
                ? l10n.emailVerifiedSuccessfully
                : l10n.phoneNumberVerifiedSuccessfully;
          } else {
            helperText = _detectInputType(_identifierController.text) == 'email'
                ? l10n.thisEmailIsNotRegistered
                : l10n.thisPhoneNumberIsNotRegistered;
          }
          statusIcon = Icon(
            isUserVerified == true ? Icons.check_circle : Icons.cancel,
            color: isUserVerified == true ? Colors.green : Colors.red,
            size: 16,
          );

        } else if (state is UserVerificationFailed) {
          final l10n = AppLocalizations.of(context)!;
          isUserVerified = false;
          helperText = l10n.unableToVerifyUser;
          statusIcon = const Icon(Icons.error, color: AppTheme.errorColor, size: 16);
        } else {
          isUserVerified = null;
          helperText = null;
          statusIcon = null;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return CustomTextFormField(
                  key: _identifierFieldKey,
                  controller: _identifierController,
                  hintText: l10n.emailOrPhoneNumber,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (state is VerifyingUser ||
                        state is UserVerified ||
                        state is UserVerificationFailed) {
                      return null;
                    }

                    if (value == null || value.isEmpty) {
                      return l10n.emailOrPhoneNumberIsRequired;
                    }
                    if (!_isValidIdentifier(value)) return l10n.enterValidEmailOrPhone;
                    return null;
                  },
                  onChanged: _handleIdentifierChange,
                );
              },
            ),

            if (helperText != null) ...[
              SizedBox(height: 6.h),
              Row(
                children: [
                  if (statusIcon != null) ...[
                    statusIcon!,
                    SizedBox(width: 6.w),
                  ],
                  Expanded(
                    child: Text(
                      helperText!,
                      style: TextStyle(
                        fontSize: isTablet(context)? 18 : 12.sp,
                        color: isUserVerified == true
                            ? Colors.green
                            : isUserVerified == false
                            ? Colors.red
                            : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPasswordField({required bool enabled}) {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return CustomTextFormField(
          controller: _passwordController,
          hintText: l10n.enterYourPassword,
          obscureText: !_isPasswordVisible,
          enabled: enabled,
          suffixIcon: _isPasswordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          onSuffixIconTap: enabled
              ? () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          }
              : null,
          validator: (value) {
            if (!enabled) return null;

            if (value == null || value.isEmpty) {
              ToastManager.show(
                context: context,
                message: l10n.passwordIsRequired
              );
              return null;
            }
            return null;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _slideController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

Widget customDivider () {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Container(
      height: 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20,),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.45),
              Colors.black.withValues(alpha: 0.35),
              Colors.black.withValues(alpha: 0.25),
              Colors.black.withValues(alpha: 0.15),
              Colors.black.withValues(alpha: 0.05),
              Colors.black.withValues(alpha: 0.0),
              Colors.transparent,
            ],
          )
      ),
    ),
  );
}
