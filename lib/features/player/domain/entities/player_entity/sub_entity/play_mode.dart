import '../../playing_method.dart';

sealed class PlayMode {
  PlayMode({required this.elapsedTime});

  final Duration elapsedTime;

  PlayingMethod get method;

   @override
  String toString() {
    return 'PlayMode(method: $method, elapsedTime: $elapsedTime)';
  }
}

class TimedPlay extends PlayMode {
  TimedPlay({
    required super.elapsedTime,
    required this.totalDuration,
    required this.remainingDuration,
  });

  final Duration totalDuration;
  final Duration remainingDuration;

  TimedPlay copyWith({
    Duration? elapsedTime,
    Duration? totalDuration,
    Duration? remainingDuration,
  }) {
    return TimedPlay(
      elapsedTime: elapsedTime ?? this.elapsedTime,
      totalDuration: totalDuration ?? this.totalDuration,
      remainingDuration: remainingDuration ?? this.remainingDuration,
    );
  }

  @override
  PlayingMethod get method => PlayingMethod.time;

   @override
  String toString() {
    return 'TimedPlay(elapsedTime: $elapsedTime, totalDuration: $totalDuration, remainingDuration: $remainingDuration)';
  }
}

class PaidPlay extends PlayMode {
  PaidPlay({
    required super.elapsedTime,
    required this.playingMoney,
    required this.totalDuration,
    required this.remainingDuration,
  });

  final Duration totalDuration;
  final Duration remainingDuration;
  final int playingMoney;

  PaidPlay copyWith({
    int? playingMoney,
    Duration? elapsedTime,
    Duration? totalDuration,
    Duration? remainingDuration,
  }) {
    return PaidPlay(
      elapsedTime: elapsedTime ?? this.elapsedTime,
      playingMoney: playingMoney ?? this.playingMoney,

      totalDuration: totalDuration ?? this.totalDuration,
      remainingDuration: remainingDuration ?? this.remainingDuration,
    );
  }

  @override
  PlayingMethod get method => PlayingMethod.money;

  @override
  String toString() {
    return 'PaidPlay(elapsedTime: $elapsedTime, playingMoney: $playingMoney, totalDuration: $totalDuration, remainingDuration: $remainingDuration)';
  }
}

class UnlimitedPlay extends PlayMode {
  UnlimitedPlay({required super.elapsedTime});

  UnlimitedPlay copyWith({Duration? elapsedTime}) {
    return UnlimitedPlay(elapsedTime: elapsedTime ?? this.elapsedTime);
  }

  @override
  PlayingMethod get method => PlayingMethod.unlimited;

  @override
  String toString() {
    return 'UnlimitedPlay(elapsedTime: $elapsedTime)';
  }
}
