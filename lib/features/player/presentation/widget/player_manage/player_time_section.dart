import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../controller/player_controller.dart';
import '../inherited_widget/player_id_provider.dart';

class PlayerTimeSection extends ConsumerWidget {
  const PlayerTimeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerId = PlayerIdProvider.of(context).playerId;

    final remainingTime = ref.watch(
      playerProvider.select(
        (state) => state.players[playerId]?.remainigTime ?? Duration.zero,
      ),
    );
    final totalDuration = ref.watch(
      playerProvider.select(
        (state) => state.players[playerId]?.totalDuration ?? Duration.zero,
      ),
    );

    final progress = totalDuration.inMilliseconds <= 0
        ? 0.0
        : remainingTime.inMilliseconds / totalDuration.inMilliseconds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الوقت المتبقي',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
        ),
        Text(
          remainingTime.format,
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
      ],
    );
  }
}
