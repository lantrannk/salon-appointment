import 'package:flutter/material.dart';

import '../constants/constants.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    this.bgColor,
    this.bgImage,
    super.key,
  });

  final Color? bgColor;
  final ImageProvider<Object>? bgImage;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: bgImage ?? Assets.bgImage,
          colorFilter: ColorFilter.mode(
            bgColor ?? colorScheme.primary.withOpacity(0.5),
            BlendMode.multiply,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
