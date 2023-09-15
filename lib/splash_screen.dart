import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/constants.dart';
import 'core/generated/l10n.dart';
import 'core/layouts/common_layout.dart';
import 'core/theme/theme.dart';
import 'features/auth/repository/user_repository.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<UserRepository>().getUser(),
      builder: (context, snapshot) {
        Timer(const Duration(seconds: 2), () {
          (snapshot.hasData)
              ? Navigator.pushReplacementNamed(context, Routes.calendar)
              : Navigator.pushReplacementNamed(context, Routes.login);
        });

        return const CommonLayout(
          child: Logo(),
        );
      },
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final l10n = S.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 118,
          child: Text(
            l10n.logo,
            style: themeData.textTheme.displayMedium,
          ),
        ),
        Positioned(
          top: 28,
          child: Text(
            l10n.logoText,
            style: themeData.textTheme.displayLarge!.copyWith(
              color: themeData.colorScheme.onPrimary.withOpacity(
                themeData.logoBackgroundOpacity,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
