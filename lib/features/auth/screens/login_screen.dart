import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';
import '../../../core/generated/l10n.dart';
import '../../../core/layouts/common_layout.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  final phoneNumberFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  String? phoneNumberErrorText;
  String? passwordErrorText;

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
      child: Container(
        height: screenHeight - keyboardHeight,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 52,
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: keyboardHeight > 0 ? 40 : 140,
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
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Input.phoneNumber(
                    text: l10n.phoneNumber,
                    controller: phoneNumberController,
                    focusNode: phoneNumberFocusNode,
                    onEditCompleted: () {
                      FocusScope.of(context).nextFocus();
                    },
                    errorText: state.phoneNumberErrorText,
                    onChanged: (value) {
                      context.read<AuthBloc>().add(
                            LoginPhoneNumberChanged(
                              phoneNumber: value,
                            ),
                          );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Input.password(
                    text: l10n.password,
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    onEditCompleted: () {
                      FocusScope.of(context).unfocus();
                    },
                    errorText: state.passwordErrorText,
                    onChanged: (value) {
                      context.read<AuthBloc>().add(
                            LoginPasswordChanged(
                              password: value,
                            ),
                          );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is LoginInProgress) {
                      loadingIndicator.show(
                        context: context,
                        height: indicatorHeight,
                      );
                    }
                    if (state is LoginSuccess) {
                      Navigator.pushReplacementNamed(context, Routes.calendar);
                    }
                    if (state is LoginFailure) {
                      loadingIndicator.hide(context);
                      switch (state.error) {
                        case ErrorMessage.invalidAccount:
                          SASnackBar.show(
                            context: context,
                            message: l10n.invalidAccountError,
                            isSuccess: false,
                          );
                          break;
                        case ErrorMessage.incorrectAccount:
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
            ],
          ),
        ),
      ),
    );
  }
}
