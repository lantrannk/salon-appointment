import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/layouts/main_layout.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../repository/user_repository.dart';

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
      create: (context) => AuthBloc(
        context.read<UserRepository>(),
      )..add(const UserLoad()),
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
                colorScheme.secondary,
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
                    Routes.login,
                    (route) => false,
                  );
                }
              },
              builder: (context, state) {
                if (state is UserLoadFailure) {
                  return Center(
                    child: SAText(
                      text: state.error!,
                      style: textTheme.bodySmall,
                    ),
                  );
                }
                if (state is UserLoadSuccess) {
                  return Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Container(
                            constraints: const BoxConstraints(
                              minHeight: 170,
                              minWidth: 170,
                              maxHeight: 170,
                              maxWidth: 170,
                            ),
                            child: FadeInImage.assetNetwork(
                              placeholder: unknownUserImagePath,
                              image: state.avatar,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.account_circle_rounded,
                                  size: 170,
                                  color: colorScheme.secondaryContainer,
                                );
                              },
                              fit: BoxFit.cover,
                              height: 170,
                              width: 170,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        child: SAText(
                          text: state.name,
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
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
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
