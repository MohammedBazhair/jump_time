import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../controller/player_controller.dart';
import '../inherited_widget/player_id_provider.dart';
import 'player_raw_info.dart';

class BuildRemainingTime extends ConsumerWidget {
  const BuildRemainingTime({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final playerId = PlayerIdProvider.of(context).playerId;
    final remainingTime = ref.watch(
      playerProvider.select(
        (state) => state.players[playerId]?.remainigTime ?? Duration.zero,
      ),
    );
    return PlayerRawInfo(label: 'الوقت المتبقي', value: remainingTime.format);
  }
}
