import 'package:flutter/material.dart';

import 'finish_button.dart';
import 'pause_resume_button.dart';

class PlayerControlButtons extends StatelessWidget {
  const PlayerControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [PauseResumeButton(), FinishButton()],
    );
  }
}
