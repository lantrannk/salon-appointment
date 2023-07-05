import 'package:flutter/material.dart';

class Service extends StatelessWidget {
  const Service({
    required this.service,
    super.key,
  });

  final String service;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        children: [
          const SizedBox(
            width: 1,
          ),
          VerticalDivider(
            color: colorScheme.onSecondary,
            thickness: 1,
          ),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child: Text(
              service,
              style: textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w500,
                height: 20 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
