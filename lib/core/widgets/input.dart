import 'package:flutter/material.dart';
import 'package:salon_appointment/core/validations/validations.dart';

class Input extends StatelessWidget {
  const Input({
    required this.text,
    required this.controller,
    required this.focusNode,
    required this.onEditCompleted,
    this.color,
    this.height,
    this.maxLines,
    this.border,
    this.textInputAction,
    super.key,
  });

  const factory Input.phoneNumber({
    required String text,
    required TextEditingController controller,
    required FocusNode focusNode,
    required VoidCallback onEditCompleted,
    double? height,
    String? errorText,
    Function(String)? onChanged,
  }) = _PhoneNumberInput;

  const factory Input.password({
    required String text,
    required TextEditingController controller,
    required FocusNode focusNode,
    required VoidCallback onEditCompleted,
    double? height,
    String? errorText,
    Function(String)? onChanged,
  }) = _PasswordInput;

  final String text;
  final Color? color;
  final FocusNode focusNode;
  final VoidCallback onEditCompleted;
  final TextEditingController controller;
  final double? height;
  final int? maxLines;
  final OutlineInputBorder? border;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        enableInteractiveSelection: true,
        focusNode: focusNode,
        style: textTheme.labelSmall!.copyWith(
          color: color,
          letterSpacing: -0.24,
        ),
        decoration: InputDecoration(
          hintText: text,
          hintStyle: textTheme.labelSmall!.copyWith(
            color: color,
          ),
          contentPadding: const EdgeInsets.only(
            left: 20,
          ),
          border: border,
        ),
        maxLines: maxLines,
        textInputAction: textInputAction,
        onEditingComplete: onEditCompleted,
      ),
    );
  }
}

class _PhoneNumberInput extends Input {
  const _PhoneNumberInput({
    required super.text,
    required super.controller,
    required super.focusNode,
    required super.onEditCompleted,
    super.height,
    this.errorText,
    this.onChanged,
  });

  final String? errorText;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        enableInteractiveSelection: true,
        focusNode: focusNode,
        keyboardType: TextInputType.phone,
        style: textTheme.labelSmall!.copyWith(
          color: colorScheme.onPrimary,
          letterSpacing: -0.24,
        ),
        decoration: InputDecoration(
          hintText: text,
          errorText: errorText,
          contentPadding: const EdgeInsets.only(
            left: 20,
          ),
        ),
        onEditingComplete: onEditCompleted,
        validator: FormValidation.isValidPhoneNumber,
        textInputAction: TextInputAction.next,
        onChanged: onChanged,
      ),
    );
  }
}

@immutable
class _PasswordInput extends Input {
  const _PasswordInput({
    required super.text,
    required super.controller,
    required super.focusNode,
    required super.onEditCompleted,
    super.height,
    this.errorText,
    this.onChanged,
  });

  final String? errorText;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        enableInteractiveSelection: true,
        focusNode: focusNode,
        obscureText: true,
        style: textTheme.labelSmall!.copyWith(
          color: colorScheme.onPrimary,
          letterSpacing: -0.24,
        ),
        decoration: InputDecoration(
          hintText: text,
          errorText: errorText,
          contentPadding: const EdgeInsets.only(
            left: 20,
          ),
        ),
        onEditingComplete: onEditCompleted,
        validator: FormValidation.isValidPassword,
        onChanged: onChanged,
      ),
    );
  }
}
