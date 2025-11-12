import 'package:equatable/equatable.dart';
import '../player_photo/player_photo.dart';
import '../player_status.dart';
import '../playing_method.dart';

class PlayerEntity extends Equatable {
  const PlayerEntity({
    required this.id,
    required this.name,
    required this.playerPhoto,
    required this.playingMethod,
    required this.playerStatus,
    required this.totalDuration,
    this.elapsedTime = Duration.zero,
    this.playingPrice,
    this.remainingTime,
  });

  factory PlayerEntity.empty() {
    return PlayerEntity(
      name: '',
      id: 0,
      playerPhoto: PlayerPhoto.asset(),
      playingMethod: PlayingMethod.money,
      playerStatus: PlayerStatus.waiting,
      totalDuration: Duration.zero,
    );
  }

  final int id;
  final String name;
  final PlayerPhoto playerPhoto;
  final PlayingMethod playingMethod;
  final PlayerStatus playerStatus;
  final int? playingPrice;
  final Duration? remainingTime;
  final Duration elapsedTime;
  final Duration totalDuration;

  PlayerEntity copyWith({
    int? id,
    String? name,
    PlayerPhoto? playerPhoto,
    PlayingMethod? playingMethod,
    PlayerStatus? playerStatus,
    int? playingPrice,
    Duration? remainingTime,
    Duration? elapsedTime,
    Duration? totalDuration,
  }) {
    return PlayerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      playerPhoto: playerPhoto ?? this.playerPhoto,
      playingMethod: playingMethod ?? this.playingMethod,
      playerStatus: playerStatus ?? this.playerStatus,
      playingPrice: playingPrice ?? this.playingPrice,
      remainingTime: remainingTime ?? this.remainingTime,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  PlayerEntity calculatePrice(int minutePrice) {
    if (remainingTime == null && playingMethod != PlayingMethod.money) {
      return this;
    }
    switch (playingMethod) {
      case PlayingMethod.money:
        return copyWith(playingPrice: playingPrice);

      case PlayingMethod.time:
        final totalPrice = remainingTime!.inMinutes * minutePrice;
        return copyWith(playingPrice: totalPrice);

      case PlayingMethod.unlimited:
        return this;
    }
  }

  PlayerEntity calculateRemaining(int minutePrice) {
    switch (playingMethod) {
      case PlayingMethod.money:
        if (playingPrice == null || playingPrice == 0) return this;
        final remainig = Duration(minutes: playingPrice! ~/ minutePrice);
        return copyWith(remainingTime: remainig);
      case PlayingMethod.time:
        return this;
      case PlayingMethod.unlimited:
        return this;
    }
  }

  PlayerEntity calculateTotalDuration(int minutePrice) {
    switch (playingMethod) {
      case PlayingMethod.money:
        final minutes = playingPrice! ~/ minutePrice;
        final totalDuration = Duration(minutes: minutes);
        return copyWith(totalDuration: totalDuration);
      case PlayingMethod.time:
        return this;
      case PlayingMethod.unlimited:
        return this;
    }
  }

  @override
  String toString() {
    return 'PlayerEntity( \n'
        'id: $id, \n'
        'name: $name, \n'
        'playingMethod: $playingMethod, \n'
        'playerStatus: $playerStatus, \n'
        'playingPrice: $playingPrice, \n'
        'remainigTime: $remainingTime, \n'
        'elapsedTime: $elapsedTime, \n'
        'playerPhoto: $playerPhoto \n'
        ')';
  }

  @override
  List<Object?> get props => [id, name, playerPhoto];
}
