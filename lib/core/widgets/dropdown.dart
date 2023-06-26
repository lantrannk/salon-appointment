import 'package:flutter/material.dart';

import '../constants/assets.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.height = 44,
    super.key,
  });

  final List<String> items;
  final String? selectedValue;
  final double? height;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 44,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondaryContainer,
            )),
        child: DropdownButton<String>(
          hint: const Text('Select Services'),
          value: selectedValue,
          onChanged: onChanged,
          items: items
              .map<DropdownMenuItem<String>>(
                  (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
              .toList(),
          icon: const Icon(Assets.dropdownIcon),
          iconSize: 24,
          underline: const SizedBox(),
          isExpanded: true,
        ),
      ),
    );
  }
}
