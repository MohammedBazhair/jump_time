import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../game_timer/presentation/controller/player_timer_controller.dart';
import '../../../game_timer/presentation/controller/remainig_time_price.dart';
import '../../../notification/domain/entities/message_type.dart';
import '../../../notification/domain/entities/snackbar_params.dart';
import '../../../notification/presentation/service/notification_service.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/entities/player_photo/player_photo.dart';
import '../../domain/entities/player_status.dart';
import '../../domain/entities/playing_method.dart';
import '../../domain/entities/time_extend_entity.dart';
import 'player_state.dart';

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier(this.ref, this.notificationService)
    : super(PlayerState.empty());

  final Ref ref;
  final NotificationService notificationService;

  void addPlayer(PlayerEntity player) {
    final copiedPlayers = {...state.players};
    copiedPlayers.update(player.id, (p) => player, ifAbsent: () => player);
    state = state.copyWith(players: copiedPlayers);
  }

  void startPlaying(PlayerEntity player) {
    addPlayer(player);

    final updatedPlayer = player.copyWith(
      playingPrice: _calculatePlayingPrice(player),
      remainigTime: _calculateRemainigTime(player),
    );

    ref.read(playerTimerProvider.notifier).startTimer(updatedPlayer);
  }

  void changePlayingMethod(PlayingMethod playingMethod) {
    if (playingMethod == state.readyPlayer.playingMethod) return;

    final readyPlayer = state.readyPlayer.copyWith(
      playingMethod: playingMethod,
    );

    state = state.copyWith(readyPlayer: readyPlayer);
  }

  void changeReadyPhoto(PlayerPhoto playerPhoto) {
    if (playerPhoto.path == null) return;

    final readyPlayer = state.readyPlayer.copyWith(playerPhoto: playerPhoto);

    state = state.copyWith(readyPlayer: readyPlayer);
  }

  void changePlayerPhoto(int playerId, PlayerPhoto newPhoto) {
    if (newPhoto.path == null) return;

    final copiedPlayers = {...state.players};
    copiedPlayers.update(playerId, (p) => p.copyWith(playerPhoto: newPhoto));

    state = state.copyWith(players: copiedPlayers);
  }

  void changePlayerStatus(int playerId, PlayerStatus newStatus) {
    final copiedPlayers = {...state.players};
    copiedPlayers.update(playerId, (p) => p.copyWith(playerState: newStatus));

    state = state.copyWith(players: copiedPlayers);
  }

  void changePhotoToAsset() {
    final currentPhoto = state.readyPlayer.playerPhoto;
    if (currentPhoto.isDefaultPhoto) return;

    final newPlayer = state.readyPlayer.copyWith(
      playerPhoto: PlayerPhoto.asset(),
    );

    state = state.copyWith(readyPlayer: newPlayer);
  }

  PlayerEntity? deletePlayer(int playerId) {
    final copiedPlayers = {...state.players};
    final player = copiedPlayers.remove(playerId);

    state = state.copyWith(players: copiedPlayers);

    return player;
  }

  void extendPlayerTime(ExtendTimeParams extendParams) {
    final player = state.players[extendParams.playerId];
    if (player == null) return;
    try {
      final currentRemaining = player.remainigTime ?? Duration.zero;
      final additionalDuration = Duration(minutes: extendParams.minutes ?? 0);
      final newPlayingPrice =
          (player.playingPrice ?? 0) + (extendParams.money ?? 0);
      final totalDuration = player.totalDuration + additionalDuration;
      final newRemaining = currentRemaining + additionalDuration;

      final updatedPlayer = player.copyWith(
        playingPrice: newPlayingPrice,
        totalDuration: totalDuration,
        remainigTime: newRemaining,
      );

      addPlayer(
        updatedPlayer.copyWith(
          playingPrice: _calculatePlayingPrice(updatedPlayer),
          remainigTime: _calculateRemainigTime(updatedPlayer),
        ),
      );

      notificationService.show(
        SnackBarParams(
          msg: 'تم تمديد فترة اللاعب ${player.name}',
          type: MessageType.success,
        ),
      );
    } catch (_) {
      notificationService.show(
        SnackBarParams(
          msg: 'حدث خطأ أثناء محاولة تمديد فترة اللاعب ${player.name}',
          type: MessageType.error,
        ),
      );
    }
  }

  int? _calculatePlayingPrice(PlayerEntity player) {
    final minutePrice = ref.read(minutePriceProvider);
    if (player.remainigTime == null &&
        player.playingMethod != PlayingMethod.money) {
      return null;
    }
    switch (player.playingMethod) {
      case PlayingMethod.money:
        return player.playingPrice;
      case PlayingMethod.time:
        return player.remainigTime!.inMinutes * minutePrice;
      case PlayingMethod.unlimited:
        return null;
    }
  }

  Duration? _calculateRemainigTime(PlayerEntity player) {
    final minutePrice = ref.read(minutePriceProvider);

    switch (player.playingMethod) {
      case PlayingMethod.money:
        return Duration(minutes: player.playingPrice! ~/ minutePrice);
      case PlayingMethod.time:
        return player.remainigTime;
      case PlayingMethod.unlimited:
        return Duration.zero;
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerState>(
  (ref) => PlayerNotifier(ref, ref.watch(notificationServiceProvider)),
);
