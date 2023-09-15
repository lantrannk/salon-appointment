import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../theme/theme.dart';

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
    final ThemeData themeData = Theme.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: bgImage ?? Assets.bgImage,
          colorFilter: ColorFilter.mode(
            bgColor ??
                themeData.colorScheme.primary.withOpacity(
                  themeData.bgImageFilterOpacity,
                ),
            BlendMode.multiply,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
