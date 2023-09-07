import 'package:flutter/material.dart';

class SAIcons extends StatelessWidget {
  const SAIcons({
    required this.icon,
    this.color,
    this.size,
    super.key,
  });

  final IconData icon;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Icon(
      icon,
      color: color ?? colorScheme.primaryContainer,
      size: size ?? 24,
    );
  }
}

class GradientIcon extends StatelessWidget {
  const GradientIcon({
    required this.icon,
    required this.gradient,
    this.size = 20,
    this.onTap,
    super.key,
  });
  final IconData icon;
  final double? size;
  final Gradient gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: ShaderMask(
          child: Icon(
            icon,
            size: size,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          shaderCallback: (bounds) {
            final Rect rect = Rect.fromLTRB(0, 0, size!, size!);
            return gradient.createShader(rect);
          },
        ),
      ),
    );
  }
}
