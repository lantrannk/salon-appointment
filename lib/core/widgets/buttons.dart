import 'package:flutter/material.dart';

class SAButton extends StatelessWidget {
  const SAButton({
    required this.child,
    this.onPressed,
    super.key,
  });

  const factory SAButton.floating({
    required Widget child,
    VoidCallback? onPressed,
    double height,
    double width,
    Color bgColor,
    double elevation,
  }) = _SAFloatingActionButton;

  const factory SAButton.text({
    required Widget child,
    VoidCallback? onPressed,
    ButtonStyle style,
  }) = _SATextButton;

  const factory SAButton.icon({
    required Widget child,
    VoidCallback? onPressed,
  }) = _SAIconButton;

  const factory SAButton.outlined({
    required Widget child,
    VoidCallback? onPressed,
    double height,
    double width,
  }) = _SAOutlinedButton;

  const factory SAButton.elevated({
    required Widget child,
    VoidCallback? onPressed,
    double height,
    double width,
    Color bgColor,
  }) = _SAElevatedButton;

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}

class _SAOutlinedButton extends SAButton {
  const _SAOutlinedButton({
    required super.child,
    super.onPressed,
    this.height = 44,
    this.width = double.infinity,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 2,
            color: colorScheme.onPrimary,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: child,
      ),
    );
  }
}

class _SATextButton extends SAButton {
  const _SATextButton({
    required super.child,
    this.style,
    super.onPressed,
  });

  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );
  }
}

class _SAIconButton extends SAButton {
  const _SAIconButton({
    required super.child,
    super.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: onPressed,
      icon: child,
    );
  }
}

class _SAElevatedButton extends SAButton {
  const _SAElevatedButton({
    required super.child,
    this.bgColor,
    this.height,
    this.width,
    super.onPressed,
  });

  final Color? bgColor;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

class _SAFloatingActionButton extends SAButton {
  const _SAFloatingActionButton({
    required super.child,
    super.onPressed,
    this.height = 56,
    this.width = 56,
    this.bgColor = Colors.transparent,
    this.elevation = 0,
  });

  final double height;
  final double width;
  final Color bgColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton(
      backgroundColor: bgColor,
      elevation: elevation,
      onPressed: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.onPrimary,
            width: 6,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary,
              colorScheme.onSurface,
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
