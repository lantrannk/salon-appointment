import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'widgets.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.hint,
    this.style,
    this.height = 44,
    this.width = double.infinity,
    super.key,
  });

  final List<String> items;
  final String hint;
  final String? selectedValue;
  final TextStyle? style;
  final double? height;
  final double? width;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withOpacity(0.235),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.onSurface,
        ),
      ),
      child: DropdownButton<String>(
        hint: Text(
          hint,
          style: style,
        ),
        value: selectedValue,
        onChanged: onChanged,
        items: items
            .map<DropdownMenuItem<String>>(
              (value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: style,
                ),
              ),
            )
            .toList(),
        icon: SAIcons(
          icon: Assets.dropdownIcon,
          color: colorScheme.onSurface,
        ),
        dropdownColor: colorScheme.surface,
        underline: const SizedBox(),
        isExpanded: true,
      ),
    );
  }
}
