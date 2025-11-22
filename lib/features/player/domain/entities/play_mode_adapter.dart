class PlayModeAdapter {
  PlayModeAdapter({
    required this.playingMoney,
    required this.totalDuration,
    required this.remainingDuration,
    required this.elapsedTime,
  });

  final int playingMoney;
  final Duration totalDuration;
  final Duration remainingDuration;
  final Duration elapsedTime;

  @override
  String toString() {
    return 'PlayModeAdapter('
        'playingMoney: $playingMoney, '
        'totalDuration: $totalDuration, '
        'remainingDuration: $remainingDuration, '
        'elapsedTime: $elapsedTime'
        ')';
  }
}
