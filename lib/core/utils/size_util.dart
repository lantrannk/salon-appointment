import 'dart:ui';

const int designScreenHeight = 812;

const int designScreenWidth = 375;

FlutterView view = PlatformDispatcher.instance.views.first;

double physicalWidth = view.physicalSize.width;
double physicalHeight = view.physicalSize.height;

double devicePixelRatio = view.devicePixelRatio;

double screenWidth = physicalWidth / devicePixelRatio;
double screenHeight = physicalHeight / devicePixelRatio;

double setHeight(double height) => height * screenHeight / designScreenHeight;

double setWidth(double width) => width * screenWidth / designScreenWidth;
