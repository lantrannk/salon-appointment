import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:salon_appointment/features/auth/screens/login_screen.dart';

void main() {
  late AuthBloc authBloc;
  late Widget loginScreen;

  setUpAll(() {
    authBloc = AuthBloc();
    loginScreen = MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider.value(
        value: authBloc,
        child: const LoginScreen(),
      ),
    );
  });

  tearDownAll(() {
    authBloc.close();
  });

  group('test login screen widgets -', () {
    testWidgets('Login Screen has one logo text', (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.pumpAndSettle();

      expect(find.text('avisit'), findsOneWidget);
    });

    testWidgets('Login Screen has two text form field', (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('Login Screen has one outlined button', (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.pumpAndSettle();

      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });
}
