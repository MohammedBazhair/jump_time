import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/extensions/extensions.dart';
import '../../controller/player_controller.dart';
import '../inherited_widget/player_id_provider.dart';

class PlayerCurrentMoney extends ConsumerWidget {
  const PlayerCurrentMoney({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerId = PlayerIdProvider.of(context).playerId;

    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      minTileHeight: 30,
      leading: Text(
        'المبلغ',
        style: context.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Consumer(
        builder: (_, ref, child) {
          final money = ref.watch(
            playerProvider.select(
              (state) => state.players[playerId]?.playingMoney,
            ),
          );
          return Text.rich(
            TextSpan(
              text: money?.toString() ?? '-',
              style: context.textTheme.labelMedium?.copyWith(fontSize: 19),
              children: [
                const TextSpan(text: ' '),
                WidgetSpan(child: child!),
              ],
            ),
          );
        },
        child: Text('ريال', style: context.textTheme.labelSmall),
      ),
    );
  }
}
