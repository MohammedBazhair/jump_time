import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../controller/player_controller.dart';
import '../inherited_widget/player_id_provider.dart';

class PlayerTimeSection extends ConsumerWidget {
  const PlayerTimeSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    print('rebuild');
    final playerId = PlayerIdProvider.of(context).playerId;

    final remainingTime = ref.watch(
      playerProvider.select(
        (state) => state.players[playerId]?.remainingTime ?? Duration.zero,
      ),
    );
    final totalDuration = ref.watch(
      playerProvider.select(
        (state) => state.players[playerId]?.totalDuration ?? Duration.zero,
      ),
    );
    final progress = totalDuration.inMinutes <= 0
        ? 0.0
        : remainingTime.inMinutes / totalDuration.inMinutes;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          minTileHeight: 30,
          leading: Text(
            'الوقت المتبقي',
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Text(
            'الوقت الكلي',
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          minTileHeight: 30,
          leading: Text(
            remainingTime.format,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            totalDuration.format,
            style: TextStyle(color: Colors.grey[400], fontSize: 15),
          ),
        ),
      ],
    );
  }
}
