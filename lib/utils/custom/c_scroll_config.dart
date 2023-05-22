import 'package:flutter/material.dart';

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class ScrollConfig extends StatelessWidget {
  final Widget child;
  const ScrollConfig({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: child,
    );
  }
}
