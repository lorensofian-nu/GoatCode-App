import 'package:flutter/material.dart';

enum DeviceScreenType {
  compact, // Mobile < 600px
  medium, // Tablet 600px - 1024px
  expanded, // Desktop/Laptop > 1024px
}

class ResponsiveLayout {
  ResponsiveLayout._();

  static const double compactBreakpoint = 600.0;
  static const double mediumBreakpoint = 1024.0;
  static const double maxContentWidth = 1200.0;

  static DeviceScreenType getDeviceType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < compactBreakpoint) {
      return DeviceScreenType.compact;
    } else if (width <= mediumBreakpoint) {
      return DeviceScreenType.medium;
    } else {
      return DeviceScreenType.expanded;
    }
  }

  static bool isCompact(BuildContext context) =>
      getDeviceType(context) == DeviceScreenType.compact;

  static bool isMedium(BuildContext context) =>
      getDeviceType(context) == DeviceScreenType.medium;

  static bool isExpanded(BuildContext context) =>
      getDeviceType(context) == DeviceScreenType.expanded;

  static double horizontalPadding(BuildContext context) {
    final type = getDeviceType(context);
    switch (type) {
      case DeviceScreenType.compact:
        return 16.0;
      case DeviceScreenType.medium:
        return 24.0;
      case DeviceScreenType.expanded:
        return 32.0;
    }
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = ResponsiveLayout.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
