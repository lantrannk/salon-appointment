import 'dart:async';

import 'package:flutter/material.dart';

import 'core/constants/constants.dart';
import 'core/generated/l10n.dart';
import 'core/layouts/common_layout.dart';
import 'core/storage/user_storage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserStorage userStorage = UserStorage();

    return FutureBuilder(
      future: userStorage.getUser(),
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
    final l10n = S.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 180,
          child: Text(
            l10n.logo,
            style: TextStyle(
              fontSize: 70,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
        Positioned(
          top: 28,
          child: Text(
            l10n.logoText,
            style: TextStyle(
              fontSize: 220,
              color: colorScheme.onPrimary.withOpacity(0.24),
            ),
          ),
        ),
      ],
    );
  }
}
