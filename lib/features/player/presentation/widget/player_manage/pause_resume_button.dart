import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/presentation/widget/iconed_button.dart';
import '../../../../game_timer/presentation/controller/player_timer_controller.dart';
import '../../controller/player_controller.dart';
import '../inherited_widget/player_id_provider.dart';

class PauseResumeButton extends ConsumerWidget {
  const PauseResumeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerId = PlayerIdProvider.of(context).playerId;

    final controller = ref.read(playerTimerProvider.notifier);
    final playerStatus = ref.watch(
      playerProvider.select((state) => state.players[playerId]?.playerStatus),
    );

    if (playerStatus == null || playerStatus.isFinishid) {
      return const SizedBox.shrink();
    }

    return IconedButton(
      label: playerStatus.isResumed ? 'استئناف' : 'ايقاف مؤقت',
      icon: Icon(playerStatus.isResumed ? Icons.play_arrow : Icons.pause),
      onPressed: () => controller.pauseResumePlayer(playerId),
    );
  }
}
