import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widget/iconed_button.dart';
import '../../domain/entities/playing_method.dart';
import '../controller/player_controller.dart';
import 'inherited_widget/player_form_provider.dart';

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
    final playModeAdapter = PlayerFormProvider.of(context).createAdapter();
    final selectedPlayMode = ref.watch(
      playerProvider.select((state) => state.readyPlayer.playMode.method),
    );

    final tabIndex = playingMethod.index;

    return IconedButton(
      label: playingMethod.label,
      icon: playingMethod.icon,
      borderRadius: 30,
      onPressed: () {
        tabController.animateTo(tabIndex);

        ref
            .read(playerProvider.notifier)
            .changePlayingMethod(playingMethod, playModeAdapter);
      },
      backgroundColor: selectedPlayMode == playingMethod
          ? null
          : const Color(0xFFE7EEF4).withOpacity(.5),
      foregroundColor: selectedPlayMode == playingMethod
          ? null
          : const Color(0xFF41677F).withOpacity(0.5),
    );
  }
}
