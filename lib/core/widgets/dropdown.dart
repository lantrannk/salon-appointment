import 'package:flutter/material.dart';
import 'package:salon_appointment/core/widgets/icons.dart';

import '../constants/assets.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.height = 44,
    this.width = double.infinity,
    super.key,
  });

  final List<String> items;
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
        color: colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.secondaryContainer,
        ),
      ),
      child: DropdownButton<String>(
        hint: const Text('Select Services'),
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
