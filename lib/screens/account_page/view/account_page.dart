import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/account_page/widgets/account_page_app_bar.dart';
import 'package:hyper_local/screens/auth/bloc/auth/auth_state.dart';
import 'package:hyper_local/screens/cart_page/bloc/get_user_cart/get_user_cart_bloc.dart';
import 'package:hyper_local/screens/policies/view/app_policies_page.dart';
import 'package:hyper_local/screens/user_profile/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:hyper_local/services/auth_guard.dart';
import 'package:hyper_local/services/shopping_list_hive.dart';
import '../../../bloc/theme_bloc/theme_bloc.dart';
import '../../../bloc/theme_bloc/theme_event.dart';
import '../../../bloc/language_bloc/language_bloc.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/global.dart';
import '../../../config/theme.dart';
import '../../../model/selected_address/selected_address_model.dart';
import '../../../services/address/selected_address_hive.dart';
import '../../../services/location/location_service.dart';
import '../../../utils/widgets/animated_button.dart';
import '../../../utils/widgets/custom_scaffold.dart';
import '../../../utils/widgets/language_bottom_sheet.dart';
import '../../auth/bloc/auth/auth_bloc.dart';
import '../../auth/bloc/auth/auth_event.dart';
import '../widgets/icon_box_widget.dart';
import '../widgets/quick_action_widget.dart';
import '../widgets/section_card_widget.dart';
import '../widgets/settings_tile_widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();

  /// Theme Dialog
  static void _showThemeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ThemeMode? selectedTheme = context.read<ThemeBloc>().state;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
          title: Text(l10n?.appearance ?? 'Appearance'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return RadioGroup<ThemeMode>(
                groupValue: selectedTheme,
                onChanged: (ThemeMode? value) {
                  setState(() => selectedTheme = value);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<ThemeMode>(
                      visualDensity: const VisualDensity(horizontal: -4),
                      activeColor: AppTheme.primaryColor,
                      title: Text(l10n?.systemMode ?? 'System mode'),
                      value: ThemeMode.system,
                    ),
                    RadioListTile<ThemeMode>(
                      visualDensity: const VisualDensity(horizontal: -4),
                      activeColor: AppTheme.primaryColor,
                      title: Text(l10n?.lightMode ?? 'Light mode'),
                      value: ThemeMode.light,
                    ),
                    RadioListTile<ThemeMode>(
                      visualDensity: const VisualDensity(horizontal: -4),
                      activeColor: AppTheme.primaryColor,
                      title: Text(l10n?.darkMode ?? 'Dark mode'),
                      value: ThemeMode.dark,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: Text(
                l10n?.apply ?? 'Apply',
                style:
                const TextStyle(color: AppTheme.primaryColor, fontSize: 16),
              ),
              onPressed: () {
                if (selectedTheme != null) {
                  context.read<ThemeBloc>().add(ThemeChanged(selectedTheme!));
                }
                GoRouter.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _AccountPageState extends State<AccountPage> {
  String? userLocation;
  SelectedAddress? selectedAddress;

  @override
  void initState() {
    // TODO: implement initState
    initiateLocation();
    loadSelectedAddress();
    context.read<UserProfileBloc>().add(FetchUserProfile());
    super.initState();
  }

  Future<void> initiateLocation() async {
    final location = LocationService.getStoredLocation();
    userLocation = location!.fullAddress;
  }

  void loadSelectedAddress() {
    final address = HiveSelectedAddressHelper.getSelectedAddress();
    setState(() {
      selectedAddress = address;
    });
  }

  Future<bool> checkUserLoggedIn() async {
    final isLoggedIn = await AuthGuard.ensureLoggedIn(context);

    return isLoggedIn;
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<UserProfileBloc, UserProfileState>(
            listener: (context, state) {}
        ),
        BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if(state is LogoutUserSuccess){
                Global.clearUserData();
                ShoppingListHiveHelper.clearLastList();
                context.read<GetUserCartBloc>().add(FetchUserCart());
                // CartService.triggerCartAnimation(context);
                GoRouter.of(context).pushReplacement(AppRoutes.login);
              }
              if(state is DeleteUserSuccess){
                Global.clearUserData();
                ShoppingListHiveHelper.clearLastList();
                context.read<GetUserCartBloc>().add(FetchUserCart());
                // CartService.triggerCartAnimation(context);
                GoRouter.of(context).pushReplacement(AppRoutes.login);
              }
            }
        ),
      ],
      child: CustomScaffold(
        showViewCart: false,
        onConnectivityRestored: (_) async {
          context.read<UserProfileBloc>().add(FetchUserProfile());
        },
        appBar: AccountPageAppBar(),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.outlineVariant,
                                width: 0.3
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: isDarkMode(context) ? Colors.transparent : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                  offset: Offset(0, 2)
                              ),
                            ]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: AnimatedButton(
                                    animationType: TapAnimationType.scale,
                                    onTap: () {
                                      if(Global.userData == null) {
                                        GoRouter.of(context)
                                            .push(AppRoutes.login);
                                      } else {
                                        GoRouter.of(context)
                                            .push(AppRoutes.myOrders);
                                      }

                                    },
                                    child: QuickAction(
                                        label: l10n?.myOrders ?? 'My Orders',
                                        icon: TablerIcons
                                            .shopping_cart_filled)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                child: VerticalDivider(width: 0.8, color: Theme.of(context).colorScheme.outline),
                              ),
                              Expanded(
                                child: AnimatedButton(
                                  animationType: TapAnimationType.scale,
                                  onTap: () {
                                    GoRouter.of(context).push(AppRoutes.supportPage);
                                  },
                                  child: QuickAction(
                                      label: l10n?.support ?? "Support",
                                      icon: TablerIcons.headphones_filled),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                child: VerticalDivider(width: 0.8, color: Theme.of(context).colorScheme.outline),
                              ),
                              Expanded(
                                child: AnimatedButton(
                                    animationType: TapAnimationType.scale,
                                    onTap: (){
                                      if(Global.userData == null) {
                                        GoRouter.of(context)
                                            .push(AppRoutes.login);
                                      } else {
                                        GoRouter.of(context).push(AppRoutes.wallet);
                                      }
                                    },
                                    child: QuickAction(label: l10n?.wallet ?? "Wallet", icon: HeroiconsSolid.wallet)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),


                      if (Global.userData != null) ...[
                        ValueListenableBuilder(
                          // Listen only to the specific key — super efficient!
                          valueListenable: Hive.box<SelectedAddress>(AppConstant.selectedAddressHiveBoxName)
                              .listenable(keys: [AppConstant.selectedAddressHiveBoxKey]),

                          builder: (context, Box<SelectedAddress> box, _) {
                            final selectedAddressData = box.get(AppConstant.selectedAddressHiveBoxKey);

                            return GestureDetector(
                              onTap: () async {
                                await GoRouter.of(context).push(AppRoutes.addressList);
                                // No need to call loadSelectedAddress() → Hive listener does it instantly!
                              },
                              child: SectionCard(
                                title: l10n?.yourDeliveryAddress ?? 'Your Delivery Address',
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                  leading: iconBox(
                                    TablerIcons.map_pin_filled,
                                    Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                                  ),
                                  title: Text(
                                    selectedAddressData?.addressLine1?.isNotEmpty == true
                                        ? selectedAddressData!.addressLine1!
                                        : 'Please add your delivery address',
                                    style: const TextStyle(fontSize: 14),
                                  ),

                                  trailing: const Icon(TablerIcons.edit, color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                      // Settings Section
                      SectionCard(
                        child: Column(
                          children: [
                            SettingsTile(
                              title: l10n?.shoppingList ?? "Shopping List",
                              icon: TablerIcons.pencil,
                              onTap: () {
                                GoRouter.of(context).push(AppRoutes.shoppingList);
                              },
                            ),
                            customDivider(),
                            // Appearance
                            SettingsTile(
                              title: l10n?.appearance ?? "Appearance",
                              icon: TablerIcons.palette,
                              onTap: () => AccountPage._showThemeDialog(context),
                            ),
                            customDivider(),

                            SettingsTile(
                              title: l10n?.wishlist ?? "Wishlist",
                              icon: AppConstant.notWishListedIcon,
                              onTap: () {
                                if(Global.userData == null) {
                                  GoRouter.of(context)
                                      .push(AppRoutes.login);
                                } else {
                                  GoRouter.of(context)
                                      .push(AppRoutes.wishlistPage);
                                }
                              },
                            ),
                            customDivider(),

                            if (Global.userData != null)...[
                              SettingsTile(
                                title: l10n?.savedForLater ?? "Save for later",
                                icon: TablerIcons.archive,
                                onTap: () {
                                  GoRouter.of(context).push(AppRoutes.saveForLater);
                                },
                              ),
                              customDivider(),
                            ],

                            // Language
                            BlocBuilder<LanguageBloc, LanguageState>(
                              builder: (context, state) {
                                String currentLanguage = 'English';
                                if (state is LanguageLoaded) {
                                  final language = Global.supportedLanguages.firstWhere(
                                        (lang) => lang['code'] == state.languageCode,
                                    orElse: () => {'name': 'English', 'nativeName': 'English'},
                                  );
                                  currentLanguage = language['nativeName']!;
                                }
                                return SettingsTile(
                                  title: l10n?.language ?? "Language",
                                  icon: TablerIcons.language,
                                  subtitle: "${l10n?.currentLanguage ?? 'Current'}: $currentLanguage",
                                  onTap: () => LanguageBottomSheet.show(context),
                                );
                              },
                            ),
                            customDivider(),

                            SettingsTile(
                              title: l10n?.termsCondition ?? "Terms & Condition",
                              icon: TablerIcons.info_circle,
                              onTap: (){
                                GoRouter.of(context).push(
                                    AppRoutes.policyPage,
                                    extra: {
                                      'policy-type': PolicyType.termsAndConditions
                                    }
                                );
                              },
                            ),
                            customDivider(),

                            // const SettingsTile(title: "Notification", icon: TablerIcons.bell),

                            SettingsTile(
                              title: l10n?.privacyPolicy ?? "Privacy Policy",
                              icon: TablerIcons.lock,
                              onTap: (){
                                GoRouter.of(context).push(
                                    AppRoutes.policyPage,
                                    extra: {
                                      'policy-type': PolicyType.privacyPolicy
                                    }
                                );
                              },
                            ),
                            customDivider(),

                            SettingsTile(
                              title: l10n?.refundPolicy ?? "Refund Policy",
                              icon: TablerIcons.rotate,
                              onTap: (){
                                GoRouter.of(context).push(
                                    AppRoutes.policyPage,
                                    extra: {
                                      'policy-type': PolicyType.refundPolicy
                                    }
                                );
                              },
                            ),
                            customDivider(),

                            SettingsTile(
                              title: l10n?.shippingPolicy ?? "Shipping Policy",
                              icon: HeroiconsOutline.truck,
                              onTap: (){
                                GoRouter.of(context).push(
                                    AppRoutes.policyPage,
                                    extra: {
                                      'policy-type': PolicyType.shippingPolicy
                                    }
                                );
                              },
                            ),
                            customDivider(),

                            SettingsTile(
                              title: l10n?.aboutUs ?? "About us",
                              icon: TablerIcons.info_circle,
                              onTap: (){
                                GoRouter.of(context).push(
                                    AppRoutes.policyPage,
                                    extra: {
                                      'policy-type': PolicyType.aboutUs
                                    }
                                );
                              },
                            ),
                            customDivider(),

                            // Show Logout and Delete Account only if user is logged in
                            if (Global.userData != null)...[
                              SettingsTile(
                                title: l10n?.logout ?? "Logout",
                                icon: TablerIcons.logout,
                                isLast: false,
                                onTap: () {
                                  _showLogoutConfirmationDialog(context);
                                },
                              ),
                              customDivider(),
                            ],


                            if (Global.userData != null)...[
                              SettingsTile(
                                title: l10n?.deleteAccount ?? "Delete Account",
                                icon: TablerIcons.trash,
                                isLast: true,
                                onTap: () {
                                  _showDeleteAccountConfirmationDialog(context);
                                },
                              ),
                            ],

                            // Show Sign In button if user is not logged in
                            if (Global.userData == null)
                              SettingsTile(
                                title: "Sign In",
                                icon: TablerIcons.login,
                                isLast: true,
                                onTap: () {
                                  GoRouter.of(context).push(AppRoutes.login);
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customDivider () {
    return Divider(
        height: 0.5,
        color: isDarkMode(context) ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.outline
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(TablerIcons.logout, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  Text(l10n?.logout ?? "Logout"),
                ],
              ),
              content: Text(l10n?.logoutConfirmation ?? "Are you sure you want to log out?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    l10n?.cancel ?? "Cancel",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: isLoading
                      ? null // Disable button while loading
                      : () async {
                    setState(() => isLoading = true);

                    // Trigger logout
                    context.read<AuthBloc>().add(LogoutUserRequest());

                  },
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(l10n?.logout ?? 'Logout'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteAccountConfirmationDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: !isLoading,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(TablerIcons.trash, color: Colors.red[700]),
                  const SizedBox(width: 12),
                  Text(
                    l10n?.deleteAccount ?? "Delete Account",
                  ),
                ],
              ),
              content: Text(
                "${AppLocalizations.of(context)!.thisActionIsPermanent}\n${AppLocalizations.of(context)!.allYourDataWillBeLostForever}\n",
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.of(ctx).pop(),
                  child: Text(l10n?.cancel ?? "Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                    setState(() => isLoading = true);

                    // Trigger delete account
                    context.read<AuthBloc>().add(DeleteUserAccount());

                    // Dialog will be closed automatically by BlocListener
                    // (you already handle navigation on DeleteUserSuccess)
                  },
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(AppLocalizations.of(context)!.delete, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

