import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/generated/l10n.dart';
import '../../../core/layouts/common_layout.dart';
import '../../../core/validations/validations.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../repository/user_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userRepo = UserRepository();

  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  final phoneNumberFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  String? phoneNumberErrorText;
  String? passwordErrorText;

  String phoneNumber = '';
  String password = '';

  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double indicatorHeight = screenHeight / 2;
    final l10n = S.of(context);

    return CommonLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 102,
              ),
              child: Container(
                padding: EdgeInsets.only(
                  bottom: keyboardHeight > 0 ? 100 : 140,
                ),
                child: SAText(
                  text: l10n.logo,
                  style: TextStyle(
                    fontSize: 40,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            Input.phoneNumber(
              text: l10n.phoneNumber,
              controller: phoneNumberController,
              height: 72,
              focusNode: phoneNumberFocusNode,
              onEditCompleted: () {
                FocusScope.of(context).nextFocus();
              },
              errorText: phoneNumberErrorText,
              onChanged: (value) {
                setState(() {
                  phoneNumberErrorText =
                      FormValidation.isValidPhoneNumber(value);
                  phoneNumber = phoneNumberController.text;
                });
              },
            ),
            const SizedBox(height: 16),
            Input.password(
              text: l10n.password,
              controller: passwordController,
              height: 72,
              focusNode: passwordFocusNode,
              onEditCompleted: () {
                FocusScope.of(context).unfocus();
              },
              errorText: passwordErrorText,
              onChanged: (value) {
                setState(() {
                  passwordErrorText = FormValidation.isValidPassword(value);
                  password = passwordController.text;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is LoginLoading) {
                    loadingIndicator.show(
                      context: context,
                      height: indicatorHeight,
                    );
                  }
                  if (state is LoginSuccess) {
                    Navigator.pushReplacementNamed(context, '/calendar');
                  }
                  if (state is LoginError) {
                    loadingIndicator.hide(context);
                    switch (state.error) {
                      case 'invalid-account':
                        SASnackBar.show(
                          context: context,
                          message: l10n.invalidAccountError,
                          isSuccess: false,
                        );
                        break;
                      case 'incorrect-account':
                        SASnackBar.show(
                          context: context,
                          message: l10n.incorrectAccountError,
                          isSuccess: false,
                        );
                        break;
                      default:
                        SASnackBar.show(
                          context: context,
                          message: state.error,
                          isSuccess: false,
                        );
                        break;
                    }
                  }
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (ctx, state) {
                    return SAButton.outlined(
                      child: SAText(
                        text: l10n.loginButton,
                        style: textTheme.labelMedium!.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        ctx.read<AuthBloc>().add(
                              LoginEvent(
                                phoneNumber: phoneNumberController.text,
                                password: passwordController.text,
                              ),
                            );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
