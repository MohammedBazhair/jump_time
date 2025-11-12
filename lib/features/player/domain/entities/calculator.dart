import 'player_entity/player.dart';
import 'player_entity/sub_entity/play_mode.dart';
import 'time_extend_entity.dart';

class PlayerCalculator {
  PlayerCalculator({required this.player, required this.minutePrice});

  final Player player;
  final int minutePrice;

  int calculateMoney() {
    switch (player.playMode) {
      case final TimedPlay timed:
        return timed.elapsedTime.inMinutes * minutePrice;

      case final PaidPlay paid:
        return paid.playingMoney;

      case final UnlimitedPlay unlimited:
        return unlimited.elapsedTime.inMinutes * minutePrice;
    }
  }

  Duration calculateTotalTime() {
    switch (player.playMode) {
      case final TimedPlay timed:
        return timed.totalDuration;

      case final PaidPlay paid:
        return paid.totalDuration;

      case final UnlimitedPlay _:
        return Duration.zero;
    }
  }

  Player extendPlaying(ExtendTimeParams params) {
    Duration additionalDuration = Duration(minutes: params.minutes ?? 0);

    if (params.money != null) {
      final minutesFromMoney = params.money! ~/ minutePrice;
      additionalDuration += Duration(minutes: minutesFromMoney);
    }

    final calculatedMoney = minutePrice * (params.minutes ?? 0);

    switch (player.playMode) {
      case final TimedPlay timed:
        final updatedPlayMode = timed.copyWith(
          totalDuration: timed.totalDuration + additionalDuration,
          remainingDuration: timed.remainingDuration + additionalDuration,
          elapsedTime: timed.elapsedTime + additionalDuration,
        );
        return player.copyWith(playMode: updatedPlayMode);

      case final PaidPlay paid:
        final updatedPlayMode = paid.copyWith(
          playingMoney: calculatedMoney,
          totalDuration: paid.totalDuration + additionalDuration,
          remainingDuration: paid.remainingDuration + additionalDuration,
        );
        return player.copyWith(playMode: updatedPlayMode);

      case final UnlimitedPlay _:
        return player;
    }
  }

  PlayerCalculator copyWith({Player? player, int? minutePrice}) {
    return PlayerCalculator(
      player: player ?? this.player,
      minutePrice: minutePrice ?? this.minutePrice,
    );
  }
}
