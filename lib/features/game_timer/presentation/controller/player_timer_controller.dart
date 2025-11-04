import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../player/domain/entities/player_entity.dart';
import '../../../player/domain/entities/player_status.dart';
import '../../../player/domain/entities/playing_method.dart';
import '../../../player/presentation/controller/player_controller.dart';

class PlayerTimerNotifier extends StateNotifier<Map<int, Timer?>> {
  PlayerTimerNotifier(this.ref) : super({});

  final Ref ref;

  void startTimer(PlayerEntity player) {
    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final players = ref.read(playerProvider).players;

      final currentPlayer = players[player.id] ?? player;

      final remainig = currentPlayer.remainigTime;
      if (currentPlayer.playingMethod != PlayingMethod.unlimited &&
          remainig != null &&
          remainig.inSeconds <= 0) {
        stopPlayerTimer(player.id);

        return;
      }

      final updatedPlayer = currentPlayer.copyWith(
        remainigTime: currentPlayer.playingMethod == PlayingMethod.unlimited
            ? null
            : _decreaseSecond(currentPlayer.remainigTime!),
        elapsedTime: _increaseSecond(currentPlayer.elapsedTime),
      );

      ref.read(playerProvider.notifier).addPlayer(updatedPlayer);
    });

    final updatedPlayer = player.copyWith(playerState: PlayerStatus.playing);
    ref.read(playerProvider.notifier).addPlayer(updatedPlayer);

    final copiedPlayersTimers = {...state};

    copiedPlayersTimers.update(
      updatedPlayer.id,
      (_) => timer,
      ifAbsent: () => timer,
    );
    state = copiedPlayersTimers;
  }

  void pauseResumePlayer(int playerId) {
    final copiedTimers = {...state};
    final playerTimer = copiedTimers[playerId];

    if (playerTimer?.isActive ?? false) {
      playerTimer?.cancel();
      copiedTimers[playerId] = null;
      state = copiedTimers;
      return;
    }

    final players = ref.read(playerProvider).players;

    final currentPlayer = players[playerId];
    if (currentPlayer == null) return;
    startTimer(currentPlayer);
  }

  void stopPlayerTimer(int playerId) {
    final copiedTimers = {...state};
    copiedTimers[playerId]?.cancel();

    copiedTimers.remove(playerId);

    final players = ref.read(playerProvider).players;

    final currentPlayer = players[playerId];

    if (currentPlayer == null) return;

    ref
        .read(playerProvider.notifier)
        .addPlayer(
          currentPlayer.copyWith(
            playerState: PlayerStatus.finished,
            remainigTime: Duration.zero,
          ),
        );

    state = copiedTimers;
  }

  Duration _decreaseSecond(Duration duration) {
    return Duration(seconds: duration.inSeconds - 1);
  }

  Duration _increaseSecond(Duration duration) {
    return Duration(seconds: duration.inSeconds + 1);
  }

  bool? isPlayingPlayer(int playerId) {
    final isPlaying = state[playerId]?.isActive;

    return isPlaying;
  }

  @override
  void dispose() {
    for (final timer in state.values) {
      timer?.cancel();
    }
    super.dispose();
  }
}

final playerTimerProvider =
    StateNotifierProvider<PlayerTimerNotifier, Map<int, Timer?>>(
      PlayerTimerNotifier.new,
    );
