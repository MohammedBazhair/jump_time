import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/presentation/widget/conditional_builder.dart';
import '../../../domain/entities/player_status.dart';
import '../../../domain/entities/playing_method.dart';
import '../../controller/player_controller.dart';
import '../inherited_widget/player_id_provider.dart';
import 'build_elapsed_time.dart';
import 'build_remaing_time.dart';
import 'card_header.dart';
import 'player_raw_info.dart';

class PlayerCard extends ConsumerWidget {
  const PlayerCard(this.playerId, {super.key});
  final int playerId;

  @override
  Widget build(BuildContext context, ref) {
    final playingMethod = ref.read(
      playerProvider.select((state) => state.players[playerId]!.playingMethod),
    );

    return PlayerIdProvider(
      playerId: playerId,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20,
        children: [
          const PlayerCardHeader(),

          Consumer(
            builder: (context, ref, child) {
              final name = ref.watch(
                playerProvider.select(
                  (state) => state.players[playerId]?.name ?? 'بلا اسم',
                ),
              );
              return PlayerRawInfo(label: 'الاسم', value: name);
            },
          ),

          Consumer(
            builder: (_, ref, __) {
              final playerStatus = ref.watch(
                playerProvider.select(
                  (state) =>
                      state.players[playerId]?.playerStatus ??
                      PlayerStatus.waiting,
                ),
              );
              return PlayerRawInfo(
                label: 'حالة اللاعب',
                value: playerStatus.status,
              );
            },
          ),

          ConditionalBuilder(
            condition: playingMethod == PlayingMethod.unlimited,
            builder: (_) => const BuildElapsedTime(),
            fallback: (_) => const BuildRemainingTime(),
          ),
        ],
      ),
    );
  }
}
