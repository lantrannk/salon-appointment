import 'package:flutter/material.dart';

import '../widgets/background_image.dart';

class CommonLayout extends StatelessWidget {
  const CommonLayout({
    required this.child,
    this.bgColor,
    this.bgImage,
    super.key,
  });

  final Widget child;
  final Color? bgColor;
  final ImageProvider<Object>? bgImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          child,
        ],
      ),
    );
  }
}
