import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../controller/player_controller.dart';
import '../inherited_widget/player_id_provider.dart';
import 'player_raw_info.dart';

class BuildElapsedTime extends StatelessWidget {
  const BuildElapsedTime({super.key});

  @override
  Widget build(BuildContext context) {
    final playerId = PlayerIdProvider.of(context).playerId;

    return Consumer(
      builder: (_, ref, __) {
        final elapsedTime = ref.watch(
          playerProvider.select(
            (state) =>
                state.players[playerId]?.playMode.elapsedTime ?? Duration.zero,
          ),
        );
        return PlayerRawInfo(label: 'الوقت المنقضي', value: elapsedTime.format);
      },
    );
  }
}
