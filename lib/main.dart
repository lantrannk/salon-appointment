import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/constants/constants.dart';
import 'core/generated/l10n.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/appointments/screens/appointments_screen.dart';
import 'features/appointments/screens/calendar_screen.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/repository/user_repository.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/profile_screen.dart';
import 'splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
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
          themeMode:
              Provider.of<ThemeProvider>(context, listen: true).themeMode,
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
