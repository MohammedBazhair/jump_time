import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../player/domain/entities/player_entity.dart';
import '../../../player/domain/entities/player_status.dart';
import '../../../player/domain/entities/playing_method.dart';
import '../../../player/presentation/controller/player_controller.dart';

class PlayerTimerNotifier extends StateNotifier<Map<int, Timer>> {
  PlayerTimerNotifier(this.ref) : super({});

  final Ref ref;

  void startTimer(PlayerEntity player) {
    final timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final players = ref.read(playerProvider).players;

      final currentPlayer = players[player.id] ?? player;

      final remainig = currentPlayer.remainingTime;
      if (currentPlayer.playingMethod != PlayingMethod.unlimited &&
          remainig != null &&
          remainig.inMinutes <= 0) {
        stopPlayerTimer(player.id);

        return;
      }

      final updatedPlayer = currentPlayer.copyWith(
        remainingTime: currentPlayer.playingMethod == PlayingMethod.unlimited
            ? null
            : currentPlayer.remainingTime!.decreeseMinute(),
        elapsedTime: currentPlayer.elapsedTime.increeseMinute(),
      );

      ref.read(playerProvider.notifier).addPlayer(updatedPlayer);
    });

    final updatedPlayer = player.copyWith(playerStatus: PlayerStatus.playing);
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
    final controller = ref.read(playerProvider.notifier);

    if (playerTimer?.isActive ?? false) {
      playerTimer?.cancel();
      controller.changePlayerStatus(playerId, PlayerStatus.resumed);
      state = copiedTimers;
      return;
    }

    final players = ref.read(playerProvider).players;

    final currentPlayer = players[playerId];
    if (currentPlayer == null) return;

    controller.changePlayerStatus(playerId, PlayerStatus.playing);
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
            playerStatus: PlayerStatus.finished,
            remainingTime: Duration.zero,
          ),
        );

    state = copiedTimers;
  }

  void deletePlayerTimer(int playerId) {
    stopPlayerTimer(playerId);
    final copiedTimers = {...state};
    copiedTimers[playerId]?.cancel();

    copiedTimers.remove(playerId);

    state = copiedTimers;
  }

  @override
  void dispose() {
    for (final timer in state.values) {
      timer.cancel();
    }
    super.dispose();
  }
}

final playerTimerProvider =
    StateNotifierProvider<PlayerTimerNotifier, Map<int, Timer?>>(
      PlayerTimerNotifier.new,
    );
