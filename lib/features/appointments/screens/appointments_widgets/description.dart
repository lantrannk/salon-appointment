import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

class Description extends StatefulWidget {
  const Description({
    required this.description,
    super.key,
  });

  final String description;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  int? maxLines = 3;
  TextOverflow? overflow = TextOverflow.ellipsis;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SAButton.text(
      onPressed: () => setState(() {
        maxLines = (maxLines == 3) ? null : 3;
        overflow =
            (overflow == TextOverflow.ellipsis) ? null : TextOverflow.ellipsis;
      }),
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.description,
          maxLines: maxLines,
          textAlign: TextAlign.justify,
          overflow: overflow,
          style: textTheme.bodySmall!.copyWith(
            color: colorScheme.onSecondary,
            height: 16 / 12,
          ),
        ),
      ),
    );
  }
}
