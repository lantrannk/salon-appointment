import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/constants.dart';
import 'core/generated/l10n.dart';
import 'core/layouts/common_layout.dart';
import 'features/auth/repository/user_repository.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<UserRepository>().getUser(),
      builder: (_, snapshot) {
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l10n = S.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 118,
          child: Text(
            l10n.logo,
            style: textTheme.displayMedium!.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Positioned(
          top: 28,
          child: Text(
            l10n.logoText,
            style: textTheme.displayLarge!.copyWith(
              color: colorScheme.onPrimary.withOpacity(0.24),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
