import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'widgets.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.hint,
    this.height = 44,
    this.width = double.infinity,
    super.key,
  });

  final List<String> items;
  final Widget? hint;
  final String? selectedValue;
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
        hint: hint,
        value: selectedValue,
        onChanged: onChanged,
        items: items
            .map<DropdownMenuItem<String>>(
              (value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ),
            )
            .toList(),
        icon: const SAIcons(
          icon: Assets.dropdownIcon,
        ),
        underline: const SizedBox(),
        isExpanded: true,
      ),
    );
  }
}
