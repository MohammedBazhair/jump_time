import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/presentation/widget/iconed_button.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../game_timer/presentation/controller/player_timer_controller.dart';
import '../../domain/entities/player_status.dart';
import '../controller/player_controller.dart';
import '../widget/player_manage/player_profile_avatar.dart';

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

            const SizedBox(height: 30),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الوقت المتبقي',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                          ),
                        ),

                        Text(
                          remainingTime.format,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final isPlaying = ref.watch(
                      playerProvider.select(
                        (state) =>
                            state.players[playerId]?.playerStatus ==
                            PlayerStatus.playing,
                      ),
                    );



                    return IconedButton(
                      label: isPlaying ? 'ايقاف مؤقت' : 'استئناف',
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
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
                    final isPlaying = ref.watch(
                      playerProvider.select(
                        (state) =>
                            state.players[playerId]?.playerStatus ==
                            PlayerStatus.playing,
                      ),
                    );

                    final endButton = IconedButton(
                      label: 'إنهاء',
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        final controller = ref.read(
                          playerTimerProvider.notifier,
                        );

                        controller.stopPlayerTimer(playerId);
                      },
                    );
                    return isPlaying ? endButton : const SizedBox.shrink();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
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
