import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/presentation/widget/iconed_button.dart';
import '../../../../game_timer/presentation/controller/player_timer_controller.dart';
import '../../controller/player_controller.dart';
import '../inherited_widget/player_id_provider.dart';

class FinishButton extends ConsumerWidget {
  const FinishButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerId = PlayerIdProvider.of(context).playerId;

    final controller = ref.read(playerTimerProvider.notifier);
    final isFinished = ref.watch(
      playerProvider.select(
        (state) => state.players[playerId]?.playerStatus.isFinishid ?? true,
      ),
    );

    if (isFinished) {
      return const SizedBox.shrink();
    }

    return IconedButton(
      label: 'إنهاء',
      icon: const Icon(Icons.close_rounded),
      onPressed: () => controller.stopPlayerTimer(playerId),
    );
  }
}
