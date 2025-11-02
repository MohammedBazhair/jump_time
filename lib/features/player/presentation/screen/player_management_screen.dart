import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/presentation/widget/iconed_button.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../game_timer/presentation/controller/player_timer_controller.dart';
import '../controller/player_controller.dart';
import '../widget/player_manage/player_avatar.dart';

class PlayerManagementScreen extends StatelessWidget {
  const PlayerManagementScreen(this.playerId, {super.key});
  final int playerId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة اللاعب')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            PlayerProfileAvatar(playerId),

            Consumer(
              builder: (context, ref, child) {
                final playerName = ref.watch(
                  playerProvider.select(
                    (state) => state.players[playerId]!.name,
                  ),
                );

                return Text(
                  playerName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),

            Column(
              children: [
                const Text('الوقت المتبقي'),
                Consumer(
                  builder: (context, ref, child) {
                    final remainingTime = ref.watch(
                      playerProvider.select(
                        (state) =>
                            state.players[playerId]?.remainigTime ??
                            Duration.zero,
                      ),
                    );
                    final totalDuration = ref.watch(
                      playerProvider.select(
                        (state) =>
                            state.players[playerId]?.totalDuration ??
                            Duration.zero,
                      ),
                    );

                    final progress = totalDuration.inMilliseconds <= 0
                        ? 0.0
                        : remainingTime.inMilliseconds /
                              totalDuration.inMilliseconds;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                        ),

                        Text(
                          remainingTime.format,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final isResumed = ref.watch(
                      playerTimerProvider.select(
                        (state) => state[playerId]?.isActive,
                      ),
                    );

                    if (isResumed == null) return const SizedBox.shrink();

                    return IconedButton(
                      label: isResumed ? 'استئناف' : 'ايقاف مؤقت',
                      icon: Icon(isResumed ? Icons.play_arrow : Icons.pause),
                      onPressed: () {
                        final controller = ref.read(
                          playerTimerProvider.notifier,
                        );

                        controller.pauseResumePlayer(playerId);
                      },
                    );
                  },
                ),

                Consumer(
                  builder: (context, ref, child) {
                    return IconedButton(
                      label: 'إنهاء',
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        final controller = ref.read(
                          playerTimerProvider.notifier,
                        );

                        controller.stopPlayerTimer(playerId);
                      },
                    );
                  },
                ),
              ],
            ),

            IconedButton(
              label: 'تمديد فترة اللعب',
              icon: const Icon(Icons.restore),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ViewRoute.extendTime.routeName,
                  arguments: playerId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
