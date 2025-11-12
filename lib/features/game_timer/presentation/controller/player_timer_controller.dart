import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/features/notifications/domain/entities/notification_params.dart';
import '../../../../core/features/notifications/domain/usecases/show_notification_usecase.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../player/domain/entities/player_entity/player.dart';
import '../../../player/domain/entities/player_status.dart';
import '../../../player/presentation/controller/player_controller.dart';

class PlayerTimerNotifier extends StateNotifier<Map<int, Timer>> {
  PlayerTimerNotifier(this.ref) : super({});

  final Ref ref;

  void startTimer(Player player) {
    final timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final players = ref.read(playerProvider).players;

      final currentPlayer = players[player.id] ?? player;

      if (currentPlayer.canStop) {
        stopPlayerTimer(player.id);

        return;
      }

      final updatedPlayer = currentPlayer.continuePlaying();

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

  void stopPlayerTimer(int playerId) async {
    final copiedTimers = {...state};
    copiedTimers[playerId]?.cancel();

    copiedTimers.remove(playerId);

    final players = ref.read(playerProvider).players;

    final currentPlayer = players[playerId];

    if (currentPlayer == null) return;

    final stoppedPlayer = currentPlayer.zeroRemainingTime();
    ref
        .read(playerProvider.notifier)
        .addPlayer(stoppedPlayer.copyWith(playerStatus: PlayerStatus.finished));

    state = copiedTimers;

    final playerName = currentPlayer.name;
    final localNotificationParams = NotificationParams(
      id: currentPlayer.id,
      title: 'انتهى وقت اللاعب $playerName',
      body: 'اضغط هنا لفتح تفاصيل اللاعب',
      viewRoute: ViewRoute.playerManagement,
    );
    await GetIt.I<ShowNotificationUseCase>()(localNotificationParams);
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
