import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widget/iconed_button.dart';
import '../../domain/entities/playing_method.dart';
import '../controller/player_controller.dart';

class CustomTab extends ConsumerWidget {
  const CustomTab({
    super.key,
    required this.playingMethod,
    required this.tabController,
  });

  final PlayingMethod playingMethod;
  final TabController tabController;
  @override
  Widget build(BuildContext context, ref) {
    final selectedPlayMode = ref.watch(
      playerProvider.select((state) => state.readyPlayer.playMode),
    );

    final tabIndex = playingMethod.index;

    return IconedButton(
      label: playingMethod.label,
      icon: playingMethod.icon,
      borderRadius: 30,
      onPressed: () {
        tabController.animateTo(tabIndex);

        ref.read(playerProvider.notifier).changePlayingMethod(selectedPlayMode);
      },
      backgroundColor: selectedPlayMode.method == playingMethod
          ? null
          : const Color(0xFFE7EEF4).withOpacity(.5),
      foregroundColor: selectedPlayMode.method == playingMethod
          ? null
          : const Color(0xFF41677F).withOpacity(0.5),
    );
  }
}
