import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/constants/constants.dart';
import 'core/generated/l10n.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/appointments/screens/appointment/appointments_screen.dart';
import 'features/appointments/screens/calendar/calendar_screen.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/repository/user_repository.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/profile_screen.dart';
import 'splash_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      devices: [
        DeviceInfo.genericPhone(
          platform: TargetPlatform.iOS,
          id: 'iPhone7Plus',
          name: 'iPhone 7 Plus',
          screenSize: const Size(414, 736),
        ),
        DeviceInfo.genericPhone(
          platform: TargetPlatform.iOS,
          id: 'iPhone5',
          name: 'iPhone 5',
          screenSize: const Size(320, 568),
        ),
        DeviceInfo.genericPhone(
          platform: TargetPlatform.android,
          id: 'GooglePixel7Pro',
          name: 'Google Pixel 7 Pro',
          screenSize: const Size(412, 771),
        ),
        ...Devices.all,
      ],
      builder: (context) {
        return ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
          child: const MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(context.read<UserRepository>()),
        child: MaterialApp(
          title: 'Salon Appointment',
          theme: AppTheme().themeData,
          darkTheme: AppDarkTheme().themeData,
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          initialRoute: Routes.home,
          routes: {
            Routes.home: (context) => const SplashScreen(),
            Routes.login: (context) => const LoginScreen(),
            Routes.calendar: (context) => const CalendarScreen(),
            Routes.appointment: (context) => const AppointmentScreen(),
            Routes.profile: (context) => const ProfileScreen(),
          },
        ),
      ),
    );
  }
}
