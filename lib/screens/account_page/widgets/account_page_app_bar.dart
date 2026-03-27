import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/global.dart';
import '../../../config/theme.dart';
import '../../../router/app_routes.dart';
import '../../../screens/user_profile/bloc/user_profile_bloc/user_profile_bloc.dart';
import '../../../utils/widgets/animated_button.dart';

class AccountPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AccountPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      bottom: PreferredSize(
        preferredSize: Size(10, 50),
        child: Column(
          children: [
            BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, state) {
                String userName = '';
                String userEmail = '';
                String userProfile = '';
                String userNumber = '';

                if (Global.userData != null) {
                  userName = Global.userData!.name;
                  userEmail = Global.userData!.email;
                  userProfile = Global.userData!.profileImage;
                  userNumber = Global.userData!.mobile;
                }

                // Only show user data if logged in (has valid token)
                if (state is UserProfileLoaded && Global.userData != null) {
                  userName = state.userData.data?.name ?? '';
                  userEmail = state.userData.data?.email ?? '';
                  userProfile = state.userData.data?.profileImage ?? '';
                  userNumber = state.userData.data?.mobile ?? '';
                }

                return Padding(
                  padding: EdgeInsets.only(
                    left: 12.0.w,
                    right: 12.0.w,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        backgroundImage: (userProfile.isNotEmpty &&
                                userProfile != 'profile_image')
                            ? NetworkImage(userProfile)
                            : null,
                        child: (userProfile.isEmpty ||
                                userProfile == 'profile_image')
                            ? const Icon(TablerIcons.user, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userName.isNotEmpty ? userName : "Sign In",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (userEmail.isNotEmpty)
                              Text(
                                userEmail,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFEEEEEE),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (userNumber.isNotEmpty)
                              Text(
                                userNumber,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFEEEEEE),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      if (Global.userData != null &&
                          Global.userData!.token.isNotEmpty) ...[
                        AnimatedButton(
                          animationType: TapAnimationType.scale,
                          onTap: () {
                            GoRouter.of(context).push(AppRoutes.userProfile);
                          },
                          child:
                              const Icon(TablerIcons.edit, color: Colors.white),
                        ),
                      ] else ...[
                        AnimatedButton(
                          animationType: TapAnimationType.scale,
                          onTap: () {
                            GoRouter.of(context).push(AppRoutes.login);
                          },
                          child: const Icon(TablerIcons.login,
                              color: Colors.white),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 30.h);
}
