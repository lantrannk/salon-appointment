import 'package:flutter/material.dart';

import '../constants/assets.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  final List<String> items;
  final String? selectedValue;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 44,
      width: 345,
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
            .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        icon: const Icon(Assets.dropdownIcon),
        iconSize: 24,
        underline: const SizedBox(),
        isExpanded: true,
      ),
    );
  }
}
