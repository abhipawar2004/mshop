import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/screens/auth/bloc/auth/auth_state.dart';
import 'package:hyper_local/screens/auth/bloc/user_verification/user_verification_state.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/custom_textfield.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../config/constant.dart';
import '../../../router/app_routes.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/user_verification/user_verification_bloc.dart';
import '../bloc/user_verification/user_verification_event.dart';

class RegisterPage extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  const RegisterPage({super.key, this.userName, this.userEmail});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Phone field data
  String _completePhoneNumber = '';
  String _countryCode = '';
  String _phoneNumber = '';
  String _countryIso2 = '';
  String _countryName = '';

  @override
  void initState() {
    _nameController.text = widget.userName ?? '';
    _emailController.text = widget.userEmail ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserVerificationBloc>().add(ResetVerification());
    });
    super.initState();
  }

/*  void _phoneNumberAuthentication() async {
    if (_formKey.currentState!.validate()) {
      if (_completePhoneNumber.isEmpty) {
        final l10n = AppLocalizations.of(context)!;
        ToastManager.show(
            context: context,
            message: l10n.pleaseEnterValidPhoneNumber,
            type: ToastType.error
        );
        return;
      }

      final verificationState = context.read<UserVerificationBloc>().state;
      if (verificationState is UserVerified && verificationState.isUserVerified == true) {
        final l10n = AppLocalizations.of(context)!;
        ToastManager.show(
            context: context,
            message: l10n.emailAlreadyRegisteredUseDifferent,
            type: ToastType.error
        );
        return;
      }

      final registrationData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'mobile': _phoneNumber,
        'password': _passwordController.text,
        'country': _countryName,
        'iso2': _countryIso2,
        'countryCode': _countryCode,
        'completePhoneNumber': _completePhoneNumber,
        'confirmPassword': _confirmPasswordController.text,
      };

      context.read<AuthBloc>().add(StoreRegistrationDataEvent(
        registrationData: registrationData,
        phoneNumber: _phoneNumber,
        countryCode: _countryCode,
        isoCode: _countryIso2,
      ));

      context.read<AuthBloc>().add(SendOtpToPhoneEvent(
          number: _phoneNumber,
          countryCode: _countryCode,
          isoCode: _countryIso2
      ));
    }
  }*/

  void _phoneNumberAuthentication() async {
    final l10n = AppLocalizations.of(context)!;

    // Step 1: Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Step 2: Validate phone number completeness
    if (_completePhoneNumber.isEmpty || _phoneNumber.isEmpty) {
      ToastManager.show(
          context: context,
          message: l10n.pleaseEnterValidPhoneNumber,
          type: ToastType.error
      );
      return;
    }

    // Step 3: Check email verification state
    final verificationState = context.read<UserVerificationBloc>().state;

    // If email verification failed
    if (verificationState is UserVerificationFailed) {
      ToastManager.show(
          context: context,
          message: l10n.errorVerifyingEmail,
          type: ToastType.error
      );
      return;
    }

    // If email is already registered
    if (verificationState is UserVerified && verificationState.isUserVerified == true) {
      ToastManager.show(
          context: context,
          message: l10n.emailAlreadyRegisteredUseDifferent,
          type: ToastType.error
      );
      return;
    }

    // Step 4: Validate individual field values (double-check)
    if (_nameController.text.trim().isEmpty || _nameController.text.trim().length < 2) {
      ToastManager.show(
          context: context,
          message: l10n.pleaseEnterYourFullName,
          type: ToastType.error
      );
      return;
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (_emailController.text.trim().isEmpty || !emailRegex.hasMatch(_emailController.text.trim())) {
      ToastManager.show(
          context: context,
          message: l10n.pleaseEnterAValidEmail,
          type: ToastType.error
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
    if (_passwordController.text.length < 8) {
      ToastManager.show(
          context: context,
          message: l10n.passwordMustBeAtLeast8Characters,
          type: ToastType.error
      );
      return;
    }

    if (_confirmPasswordController.text.isEmpty || _passwordController.text != _confirmPasswordController.text) {
      ToastManager.show(
          context: context,
          message: l10n.passwordsDoNotMatch,
          type: ToastType.error
      );
      return;
    }

    // Step 5: Validate country/phone metadata
    if (_countryCode.isEmpty || _countryIso2.isEmpty || _countryName.isEmpty) {
      ToastManager.show(
          context: context,
          message: "Please select a valid country code",
          type: ToastType.error
      );
      return;
    }

    // Step 6: All validations passed - proceed with registration
    final registrationData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'mobile': _phoneNumber,
      'password': _passwordController.text,
      'country': _countryName,
      'iso2': _countryIso2,
      'countryCode': _countryCode,
      'completePhoneNumber': _completePhoneNumber,
      'confirmPassword': _confirmPasswordController.text,
    };

    // Store registration data
    context.read<AuthBloc>().add(StoreRegistrationDataEvent(
      registrationData: registrationData,
      phoneNumber: _phoneNumber,
      countryCode: _countryCode,
      isoCode: _countryIso2,
    ));

    // Send OTP
    context.read<AuthBloc>().add(SendOtpToPhoneEvent(
        number: _phoneNumber,
        countryCode: _countryCode,
        isoCode: _countryIso2
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: AppLocalizations.of(context)!.register,
      showAppBar: true,
      showViewCart: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is LoginPhoneCodeSentState) {
            _handleRegister(state.verificationId ?? '');
          }
          if (state is AuthFailed) {
            ToastManager.show(
                context: context,
                message: state.error,
                type: ToastType.error
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Welcome text
                Text(
                  AppLocalizations.of(context)!.createAccount,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.fontFamily,
                      fontSize: isTablet(context) ? 28 : 20.sp
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.pleaseFillDetailsCreateYourAccount,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: AppTheme.fontFamily
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                /// Name
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return CustomTextFormField(
                      controller: _nameController,
                      labelText: l10n.fullName,
                      hintText: l10n.enterYourFullName,
                      prefixIcon: Icons.person,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ToastManager.show(
                              context: context,
                              message: l10n.pleaseEnterYourFullName,
                              type: ToastType.error,
                            );
                          });
                          return null;
                        }
                        if (value.length < 2) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ToastManager.show(
                              context: context,
                              message: l10n.nameMustBeAtLeast2Characters,
                              type: ToastType.error,
                            );
                          });
                          return null;
                        }
                        return null;
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// Email - Fixed to use UserVerificationState
                BlocBuilder<UserVerificationBloc, UserVerificationState>(
                  builder: (BuildContext context, UserVerificationState state) {
                    bool? isUserVerified;
                    String? helperText;
                    Widget? statusIcon;

                    // Handle empty field case
                    if (_emailController.text.isEmpty) {
                      isUserVerified = null;
                      helperText = null;
                      statusIcon = null;
                    } else if (state is VerifyingUser) {
                      isUserVerified = null;
                      helperText = null;
                    } else if (state is UserVerified) {
                      isUserVerified = state.isUserVerified;
                      helperText = isUserVerified == true
                          ? AppLocalizations.of(context)!.emailAlreadyRegistered
                          : AppLocalizations.of(context)!.emailAvailable;
                      statusIcon = Icon(
                        isUserVerified == true ? Icons.cancel : Icons.check_circle,
                        color: isUserVerified == true ? Colors.red : Colors.green,
                        size: 16,
                      );
                    } else if (state is UserVerificationFailed) {
                      isUserVerified = null;
                      helperText = AppLocalizations.of(context)!.errorVerifyingEmail;
                      statusIcon = const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 16,
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ToastManager.show(
                          context: context,
                          message: state.error,
                          type: ToastType.error,
                        );
                      });
                    } else {
                      isUserVerified = null;
                      helperText = null;
                      statusIcon = null;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return IntrinsicHeight(
                              child: Stack(
                                children: [
                                  Builder(
                                    builder: (context) {
                                      final l10n = AppLocalizations.of(context)!;
                                      return CustomTextFormField(
                                        controller: _emailController,
                                        labelText: l10n.email,
                                        hintText: l10n.enterYourEmail,
                                        prefixIcon: Icons.email_outlined,
                                        keyboardType: TextInputType.emailAddress,

                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              ToastManager.show(
                                                context: context,
                                                message: l10n.pleaseEnterYourEmail,
                                                type: ToastType.error,
                                              );
                                            });
                                            return null;
                                          }
                                          if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                              .hasMatch(value)) {
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              ToastManager.show(
                                                context: context,
                                                message: l10n.pleaseEnterAValidEmail,
                                                type: ToastType.error,
                                              );
                                            });
                                            return null;
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            context.read<UserVerificationBloc>().add(ResetVerification());
                                          } else {
                                            Future.delayed(const Duration(milliseconds: 500), () {
                                              if (_emailController.text == value) {
                                                if(context.mounted) {
                                                  context.read<UserVerificationBloc>().add(VerifyUser(value: value, type: 'email'));
                                                }
                                              }
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  if (state is VerifyingUser) ...[
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                      width: 40,
                                      child: Center(
                                        child: SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                            AlwaysStoppedAnimation<Color>(Colors.blue),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                        if (helperText != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (statusIcon != null) ...[
                                statusIcon,
                                const SizedBox(width: 4),
                              ],
                              Expanded(
                                child: Text(
                                  helperText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isUserVerified == true
                                        ? Colors.red
                                        : isUserVerified == false
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// Phone Number with Country Selection
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return IntlPhoneField(
                      showDropdownIcon: false,
                      showCountryFlag: false,
                      cursorColor: Theme.of(context).colorScheme.tertiary,
                      decoration: InputDecoration(
                        labelText: l10n.phoneNumber,
                        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: isTablet(context) ? 20 : 16
                        ),
                        contentPadding: EdgeInsets.symmetric (
                          vertical: 14.h
                        ),
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: isTablet(context) ? 20 : 16
                        ),
                        hintText: l10n.enterYourPhoneNumber,
                        prefixIcon: Icon(
                            Icons.phone, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
                        ),
                        prefixStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: isTablet(context) ? 20 : 16
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                      initialCountryCode: 'IN',
                      textInputAction: TextInputAction.next,
                      onChanged: (phone) {
                        setState(() {
                          _completePhoneNumber = phone.completeNumber;
                          _countryCode = phone.countryCode;
                          _phoneNumber = phone.number;
                          _countryIso2 = phone.countryISOCode;
                          _countryName = phone.countryISOCode.toUpperCase();
                        });
                      },
                      validator: (phone) {
                        if (phone == null || phone.number.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ToastManager.show(
                              context: context,
                              message: l10n.pleaseEnterYourPhoneNumber,
                              type: ToastType.error,
                            );
                          });
                          return null;
                        }
                        return null;
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// Password
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return CustomTextFormField(
                      controller: _passwordController,
                      labelText: l10n.password,
                      hintText: l10n.enterYourPassword,
                      prefixIcon: Icons.lock,
                      suffixIcon: _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      onSuffixIconTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      obscureText: !_isPasswordVisible,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                            ToastManager.show(
                              context: context,
                              message: l10n.pleaseEnterYourPassword,
                              type: ToastType.error,
                            );
                          // });
                          return null;
                        } else if (value.length < 8) {
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                            ToastManager.show(
                              context: context,
                              message: l10n.passwordMustBeAtLeast8Characters,
                              type: ToastType.error,
                            );
                          // });
                          return null;
                        }
                        return null;
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// Confirm Password
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return CustomTextFormField(
                      controller: _confirmPasswordController,
                      labelText: l10n.confirmPassword,
                      hintText: l10n.confirmYourPassword,
                      prefixIcon: Icons.lock,
                      suffixIcon: _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      onSuffixIconTap: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                      obscureText: !_isConfirmPasswordVisible,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                            ToastManager.show(
                              context: context,
                              message: l10n.pleaseConfirmYourPassword,
                              type: ToastType.error,
                            );
                          // });
                          return null;
                        }
                        if (value != _passwordController.text) {
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                            ToastManager.show(
                              context: context,
                              message: l10n.passwordsDoNotMatch,
                              type: ToastType.error,
                            );
                          // });
                          return null;
                        }
                        return null;
                      },
                    );
                  },
                ),

                const SizedBox(height: 32),

                /// Submit button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    final isAuthLoading = authState is AuthLoading || authState is LoginCodeSentProgress;

                    return BlocBuilder<UserVerificationBloc, UserVerificationState>(
                      builder: (context, verificationState) {
                        final isVerifyingEmail = verificationState is VerifyingUser;
                        final isButtonDisabled = isAuthLoading || isVerifyingEmail;

                        return CustomButton(
                          onPressed: isButtonDisabled ? null : _phoneNumberAuthentication,
                          child: isAuthLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                              : isVerifyingEmail
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              ),
                              SizedBox(width: 12),
                              Text(AppLocalizations.of(context)!.checkingEmail),
                            ],
                          )
                              : Text(
                            AppLocalizations.of(context)!.createAccount,
                            style: TextStyle(fontSize: isTablet(context) ? 28 : 16, fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.alreadyHaveAnAccount,
                      style: TextStyle(
                          fontSize: isTablet(context) ? 18 : 14
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.login,
                        style: TextStyle(
                            color: AppTheme.primaryColor,
                          fontSize: isTablet(context) ? 18 : 14
                        ),
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
    );
  }

  void _handleRegister(String verificationId) async {

    final authBloc = context.read<AuthBloc>();
    final registrationData = authBloc.getPendingRegistrationData();
    final phoneNumber = authBloc.getPendingPhoneNumber();
    final countryCode = authBloc.getPendingCountryCode();
    final isoCode = authBloc.getPendingIsoCode();

    if (registrationData == null) {
      final l10n = AppLocalizations.of(context)!;
      ToastManager.show(
        context: context,
        message: l10n.registrationDataNotFound,
        type: ToastType.error,
      );
      return;
    }

    if (!mounted) return;

    GoRouter.of(context).push(
      AppRoutes.otpVerification,
      extra: {
        'phoneNumber': registrationData['completePhoneNumber'],
        'registrationData': registrationData,
        'verificationId': verificationId,
        'userNumber': phoneNumber,
        'countryCode': countryCode,
        'isoCode': isoCode,
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}