import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/auth/widgets/otp_input_boxes.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:hyper_local/utils/widgets/whole_page_progress.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

class OTPVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final Map<String, dynamic> registrationData;
  final String verificationId;
  final String number;
  final String countryCode;
  final String isoCode;

  const OTPVerificationPage(
      {super.key,
      required this.phoneNumber,
      required this.registrationData,
      required this.verificationId,
      required this.number,
      required this.countryCode,
      required this.isoCode});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _verificationId;
  int _resendTimer = 60;
  bool _canResend = false;
  StreamSubscription? _registrationSubscription;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    log('📱 OTP Page initialized with:');
    log('   Phone: ${widget.phoneNumber}');
    log('   VerificationId: $_verificationId');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _sendOTP();
      _startResendTimer();
    });
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!_isActive || !mounted) return;
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
        _startResendTimer();
      } else {
        setState(() {
          _canResend = true;
        });
      }
    });
  }


  void _resendOTP() {
    if (_canResend) {
      setState(() {
        _canResend = false;
        _resendTimer = 60;
      });

      // ✅ Resend OTP
      context.read<AuthBloc>().add(SendOtpToPhoneEvent(
          number: widget.number,
          countryCode: widget.countryCode,
          isoCode: widget.isoCode));

      _startResendTimer();
    }
  }

  // void _verifyOTP() {
  //   context.read<AuthBloc>().add(VerifySentOtp(
  //     verificationId: _verificationId!,
  //     otpCode: _otpController.text.trim(),
  //   ));
  //   if (_verificationId == null) {
  //     ToastManager.show(
  //       context: context,
  //       message: 'Please wait for OTP to be sent',
  //       type: ToastType.error,
  //     );
  //     return;
  //   }
  // }

  void _verifyOTP() {
    if (_otpController.text.length < 6) {
      ToastManager.show(
        context: context,
        message: AppLocalizations.of(context)!.pleaseEnterCompleteOTP,
        type: ToastType.error,
      );
      return;
    }

    if (_verificationId == null || _verificationId!.isEmpty) {
      ToastManager.show(
        context: context,
        message: AppLocalizations.of(context)!.verificationIdNotFound,
        type: ToastType.error,
      );
      return;
    }

    // ✅ Send OTP verification event
    context.read<AuthBloc>().add(VerifySentOtp(
          verificationId: _verificationId!,
          otpCode: _otpController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // if (state is OTPSent) {
        //   _verificationId = state.verificationId;
        //   ToastManager.show(
        //     context: context,
        //     message: 'OTP sent to ${state.phoneNumber}',
        //     type: ToastType.success,
        //   );
        // }
        if (!_isActive || !mounted) return;
        if (state is LoginPhoneCodeSentState) {
          if (!mounted) return;

          setState(() {
            _verificationId = state.verificationId;
          });
          ToastManager.show(
            context: context,
            message: AppLocalizations.of(context)!.otpSentTo(widget.phoneNumber),
            type: ToastType.success,
          );
        }
        else if (state is OTPVerified) {
          _completeRegistration();
        }
        else if (state is AuthSuccess) {
          if (!mounted) return;
          context.read<AuthBloc>().add(ClearRegistrationDataEvent());
          ToastManager.show(
            context: context,
            message: state.message,
            type: ToastType.success,
          );
          if (mounted) {
            GoRouter.of(context).pushReplacement(AppRoutes.splashScreen);
          }
          // GoRouter.of(context).pushReplacement(AppRoutes.splashScreen);
        }
        else if (state is AuthFailed) {
          if (!mounted) return;
          ToastManager.show(
            context: context,
            message: state.error,
            type: ToastType.error,
          );
          // GoRouter.of(context).pop();
        }
        else if (state is OTPFailed) {
          if (!mounted) return;
          ToastManager.show(
            context: context,
            message: state.error,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is VerifyingOTP ||
            state is AuthLoading ||
            state is LoginCodeSentProgress;

        return Stack(
          children: [
            CustomScaffold(
              showViewCart: false,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: (){
                    GoRouter.of(context).pushReplacement(AppRoutes.login);
                  },
                  icon: Icon(TablerIcons.chevron_left)
                ),
                title: Text(
                  AppLocalizations.of(context)!.verifyOtp,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 16.sp
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // Header
                      Text(
                        'Verify Your Phone',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 20.sp,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We sent a verification code to',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.phoneNumber,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 16.sp,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // OTP Input
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is OTPLoading;


                          return AbsorbPointer(
                            absorbing: isLoading,
                            child: OTPInputBoxes(
                              onCompleted: (otp) {
                                _otpController.text = otp; // keep controller in sync if needed elsewhere
                                // Auto-verify when 6 digits are filled
                                // if (otp.length == 6) {
                                //   _verifyOTP();
                                // }

                                // Auto verify as soon as user types 6th digit
                                if (otp.length == 6 && _verificationId != null) {
                                  context.read<AuthBloc>().add(VerifySentOtp(
                                    verificationId: _verificationId!,
                                    otpCode: otp,
                                  ));
                                }
                              },
                            ),
                          );

                        },
                      ),

                      const SizedBox(height: 24),

                      CustomButton(
                        onPressed: isLoading ? null : _verifyOTP,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Verify OTP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),

                      const SizedBox(height: 16),

                      // Resend OTP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive code?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 8),
                          if (_canResend)
                            TextButton(
                              onPressed: _resendOTP,
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else
                            Text(
                              'Resend in $_resendTimer s',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading) WholePageProgress()
          ],
        );
      },
    );
  }

  void _completeRegistration() {
    final bloc = context.read<AuthBloc>();
    log('✅ Completing registration...');

    final registrationData = bloc.getPendingRegistrationData();

    if (registrationData == null) {
      ToastManager.show(
        context: context,
        message: AppLocalizations.of(context)!.registrationDataNotFound,
        type: ToastType.error,
      );
      return;
    }


    bloc.add(RegisterRequest(
      name: widget.registrationData['name'].toString(),
      email: widget.registrationData['email'].toString(),
      mobile: widget.registrationData['mobile'].toString(),
      password: widget.registrationData['password'].toString(),
      country: widget.registrationData['country'].toString(),
      iso2: widget.registrationData['iso2'].toString(),
      countryCode: widget.registrationData['countryCode'].toString(),
      completePhoneNumber:
          widget.registrationData['completePhoneNumber'].toString(),
      confirmPassword: widget.registrationData['confirmPassword'].toString(),
    ));



    bloc.add(ClearRegistrationDataEvent());
  }

  @override
  void dispose() {
    _isActive = false;
    _otpController.dispose();
    _registrationSubscription?.cancel();
    super.dispose();
  }
}
