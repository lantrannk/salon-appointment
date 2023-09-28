import 'package:flutter/material.dart';

class Customer extends StatelessWidget {
  const Customer({
    required this.name,
    required this.avatar,
    super.key,
  });

  final String name;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.onPrimary,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(avatar),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          name,
          style: textTheme.bodyLarge!.copyWith(
            color: colorScheme.primary,
            height: 24 / 14,
          ),
        )
      ],
    );
  }
}
