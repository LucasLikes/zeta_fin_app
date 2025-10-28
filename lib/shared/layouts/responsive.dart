import 'package:flutter/widgets.dart';

enum ScreenSize {
  small,
  medium,
  large,
}

class Responsive {
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return ScreenSize.large;
    } else if (width >= 800) {
      return ScreenSize.medium;
    } else {
      return ScreenSize.small;
    }
  }

  static bool isSmall(BuildContext context) =>
      getScreenSize(context) == ScreenSize.small;

  static bool isMedium(BuildContext context) =>
      getScreenSize(context) == ScreenSize.medium;

  static bool isLarge(BuildContext context) =>
      getScreenSize(context) == ScreenSize.large;
}
