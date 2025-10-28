import 'package:flutter/widgets.dart';
import 'responsive.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget smallScreen;
  final Widget mediumScreen;
  final Widget largeScreen;

  const ResponsiveBuilder({
    required this.smallScreen,
    required this.mediumScreen,
    required this.largeScreen,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Responsive.getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.large:
        return largeScreen;
      case ScreenSize.medium:
        return mediumScreen;
      case ScreenSize.small:
      default:
        return smallScreen;
    }
  }
}
