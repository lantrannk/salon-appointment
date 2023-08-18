import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/assets.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/layouts/main_layout.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final double indicatorHeight = MediaQuery.of(context).size.height / 2;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final l10n = S.of(context);

    return BlocProvider(
      create: (context) => AuthBloc()..add(const UserLoad()),
      child: MainLayout(
        title: l10n.profileAppBarTitle,
        currentIndex: 3,
        selectedDay: DateTime.now(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 100),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.onSurface,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is LogoutInProgress) {
                  loadingIndicator.show(
                    context: context,
                    height: indicatorHeight,
                  );
                }
                if (state is LogoutSuccess) {
                  loadingIndicator.hide(context);

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              builder: (context, state) {
                final String userName = state.name;
                final String userAvatar = state.avatar;
                if (state is UserLoadSuccess) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.onPrimary,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(userAvatar),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        child: SAText(
                          text: userName,
                          style: textTheme.displaySmall!.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primary.withOpacity(0.1),
                          ),
                          child: SAButton.icon(
                            child: Icon(
                              Assets.logoutIcon,
                              color: colorScheme.onPrimary,
                              size: 24,
                            ),
                            onPressed: () {
                              AlertConfirmDialog.show(
                                context: context,
                                title: l10n.logoutConfirmTitle,
                                content: l10n.logoutConfirmMessage,
                                onPressedRight: () {
                                  context.read<AuthBloc>().add(
                                        const LogoutEvent(),
                                      );
                                },
                                onPressedLeft: () {
                                  Navigator.pop(context, false);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
