import 'package:flutter/material.dart';

import 'play_mode_adapter.dart';
import 'player_entity/sub_entity/play_mode.dart';

enum PlayingMethod {
  money('المبلغ', Icon(Icons.attach_money_rounded)),
  time('الوقت', Icon(Icons.av_timer)),
  unlimited('مفتوح', Icon(Icons.local_fire_department_outlined));

  const PlayingMethod(this.label, this.icon);
  final String label;
  final Widget icon;

  PlayMode createMode(PlayModeAdapter adapter) {
    switch (this) {
      case PlayingMethod.time:
        return TimedPlay(
          elapsedTime: adapter.elapsedTime,
          remainingDuration: adapter.remainingDuration,
          totalDuration: adapter.totalDuration,
        );

      case PlayingMethod.money:
        return PaidPlay(
          elapsedTime: adapter.elapsedTime,
          remainingDuration: adapter.remainingDuration,
          totalDuration: adapter.totalDuration,
          playingMoney: adapter.playingMoney,
        );

      case PlayingMethod.unlimited:
        return UnlimitedPlay(elapsedTime: adapter.elapsedTime);
    }
  }
}
