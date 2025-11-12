import '../../../../../core/extensions/extensions.dart';
import '../calculator.dart';
import '../player_status.dart';
import 'sub_entity/avatar_photo.dart';
import 'sub_entity/play_mode.dart';

class Player {
  Player({
    required this.id,
    required this.name,
    required this.avatarPhoto,
    required this.playMode,
    required this.playerStatus,
     this.calculator
  });

  factory Player.empty() {
    return Player(
      id: 0,
      name: '',
      avatarPhoto: AssetAvatar(),
      playMode: UnlimitedPlay(elapsedTime: Duration.zero),
      playerStatus: PlayerStatus.ready,
    );
  }

  final int id;
  final String name;
  final AvatarPhoto avatarPhoto;
  final PlayMode playMode;
  final PlayerStatus playerStatus;
  final PlayerCalculator? calculator;

  Player copyWith({
    int? id,
    String? name,
    AvatarPhoto? avatarPhoto,
    PlayMode? playMode,
    PlayerStatus? playerStatus,
    PlayerCalculator? calculator,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPhoto: avatarPhoto ?? this.avatarPhoto,
      playMode: playMode ?? this.playMode,
      playerStatus: playerStatus ?? this.playerStatus,
    calculator: calculator??this.calculator
    );
  }

  bool get canStop {
    switch (playMode) {
      case final TimedPlay timed:
        return timed.remainingDuration.inMinutes <= 0;

      case final PaidPlay paid:
        return paid.remainingDuration.inMinutes <= 0;

      case final UnlimitedPlay _:
        return false;
    }
  }

  Duration? get remainingTime {
    switch (playMode) {
      case final TimedPlay timed:
        return timed.remainingDuration;

      case final PaidPlay paid:
        return paid.remainingDuration;

      case final UnlimitedPlay _:
        return null;
    }
  }

  int get playingMoney => calculator?.calculateMoney()??0;
  Duration get totalTime => calculator?.calculateTotalTime()??Duration.zero;
    
  

  Player continuePlaying() {
    switch (playMode) {
      case final TimedPlay timed:
        final updatedPlayMode = timed.copyWith(
          remainingDuration: timed.remainingDuration.decreeseMinute(),
        );
        return copyWith(playMode: updatedPlayMode);

      case final PaidPlay paid:
        final updatedPlayMode = paid.copyWith(
          remainingDuration: paid.remainingDuration.decreeseMinute(),
        );
        return copyWith(playMode: updatedPlayMode);

      case final UnlimitedPlay unlimited:
        final updatedPlayMode = unlimited.copyWith(
          elapsedTime: unlimited.elapsedTime.increeseMinute(),
        );
        return copyWith(playMode: updatedPlayMode);
    }
  }

  Player zeroRemainingTime() {
    switch (playMode) {
      case final TimedPlay timed:
        final updatedPlayMode = timed.copyWith(
          remainingDuration: Duration.zero,
        );
        return copyWith(playMode: updatedPlayMode);

      case final PaidPlay paid:
        final updatedPlayMode = paid.copyWith(remainingDuration: Duration.zero);
        return copyWith(playMode: updatedPlayMode);

      case final UnlimitedPlay _:
        return this;
    }
  }
}
