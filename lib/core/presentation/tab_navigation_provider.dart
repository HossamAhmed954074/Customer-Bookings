import 'package:flutter/material.dart';

/// Provides a callback to navigate between tabs in the main navigation
class TabNavigationProvider extends InheritedWidget {
  final Function(int) onTabChange;

  const TabNavigationProvider({
    super.key,
    required this.onTabChange,
    required super.child,
  });

  static TabNavigationProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TabNavigationProvider>();
  }

  @override
  bool updateShouldNotify(TabNavigationProvider oldWidget) {
    return onTabChange != oldWidget.onTabChange;
  }
}
