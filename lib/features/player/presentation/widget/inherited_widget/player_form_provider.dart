import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../domain/entities/play_mode_adapter.dart';

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

  PlayModeAdapter createAdapter() {
    print('playingTimeController: ${playingTimeController.text}');
    final time = Duration(minutes: playingTimeController.text.toInt ?? 0);

    return PlayModeAdapter(
      playingMoney: playingMoneyController.text.toInt ?? 0,
      totalDuration: time,
      remainingDuration: time,
      elapsedTime: Duration.zero,
    );
  }

  static PlayerFormProvider of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<PlayerFormProvider>();

    assert(result != null, 'No PlayerFormProvider found in context');

    return result!;
  }

  @override
  bool updateShouldNotify(PlayerFormProvider oldWidget) {
    return playingTimeController.text != oldWidget.playingTimeController.text ||
        playingMoneyController.text != oldWidget.playingMoneyController.text ||
        tabController.index != oldWidget.tabController.index;
  }
}
