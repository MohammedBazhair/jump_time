import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/presentation/widget/conditional_builder.dart';
import '../../../../../core/routes/app_routes.dart';
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
  Widget build(BuildContext context, WidgetRef ref) {
    final playingMethod = ref.read(
      playerProvider.select((state) => state.players[playerId]!.playingMethod),
    );

    return PlayerIdProvider(
      playerId: playerId,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24), // 👈 القص الخارجي هنا
        child: Dismissible(
          key: ValueKey('player_card_$playerId'),
          background: Container(
            color: const Color(0xADFF4107),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: const Color(0xA52195F3),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const Icon(Icons.manage_accounts, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              // إلى اليمين → إدارة
              await Navigator.of(context).pushNamed(
                ViewRoute.playerManagement.routeName,
                arguments: playerId,
              );
              return false; // لا نحذف
            }

            // إلى اليسار → حذف
            final result = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('تأكيد الحذف'),
                  content: const Text('هل أنت متأكد أنك تريد حذف اللاعب؟'),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        fixedSize: const Size.fromWidth(100),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('حذف'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF52C8FF),
                        fixedSize: const Size.fromWidth(150),
                      ),

                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('إلغاء'),
                    ),
                  ],
                );
              },
            );
            if (result == true) {
              ref.read(playerProvider.notifier).deletePlayer(playerId);
            }
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                const PlayerCardHeader(),
                Consumer(
                  builder: (context, ref, _) {
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
          ),
        ),
      ),
    );
  }
}
