import 'package:flutter/material.dart';

class PlayerFormProvider extends InheritedWidget {
  const PlayerFormProvider({
    super.key,
    required super.child,
    required this.tabController,
    required this.playingMoneyController,
    required this.playingTimeController,
  });

  final TabController tabController;
  final TextEditingController playingTimeController;
  final TextEditingController playingMoneyController;

  static PlayerFormProvider of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<PlayerFormProvider>();

    assert(result != null, 'No PlayerFormProvider found in context');

    return result!;
  }

  @override
  bool updateShouldNotify(PlayerFormProvider oldWidget) {
    return tabController.index != oldWidget.tabController.index;
  }
}
