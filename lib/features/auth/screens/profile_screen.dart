import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/assets.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/layouts/main_layout.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../model/user.dart';

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
        currentIndex: 2,
        child: Container(
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
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  final User user = state.user;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.onPrimary,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(user.avatar),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SAText(
                        text: user.name,
                        style: textTheme.displaySmall!.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withOpacity(0.1),
                        ),
                        child: BlocListener<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is LogoutSuccess) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
                            }
                          },
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (ctx, state) {
                              return SAButton.icon(
                                child: Icon(
                                  Assets.logoutIcon,
                                  color: colorScheme.onPrimary,
                                  size: 24,
                                ),
                                onPressed: () {
                                  AlertConfirmDialog.show(
                                    context: context,
                                    title: l10n.logoutConfirmTitle,
                                    message: l10n.logoutConfirmMessage,
                                    onPressedRight: () {
                                      loadingIndicator.show(
                                        context: context,
                                        height: indicatorHeight,
                                      );
                                      ctx.read<AuthBloc>().add(
                                            const LogoutEvent(),
                                          );
                                    },
                                    onPressedLeft: () {
                                      Navigator.pop(context, false);
                                    },
                                  );
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
