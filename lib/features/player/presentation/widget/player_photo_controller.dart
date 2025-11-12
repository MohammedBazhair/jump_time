import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widget/iconed_button.dart';
import '../controller/player_controller.dart';
import '../helpers/helpers.dart';
import 'build_player_photo.dart';

class PlayerPhotoController extends ConsumerWidget {
  const PlayerPhotoController({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerPhoto = ref.watch(
      playerProvider.select((state) => state.readyPlayer.avatarPhoto),
    );

    return Column(
      spacing: 30,
      children: [
        BuildPlayerPhoto(playerPhoto),

        SizedBox(
          height: 40,
          child: IconedButton(
            label: 'التقط صورة',
            icon: const Icon(Icons.camera_enhance_sharp),
            backgroundColor: const Color(0xFFE7EEF4).withOpacity(.5),
            foregroundColor: const Color(0xFF000000),
            onPressed: () async {
              final pickedPhoto = await pickCameraImage();
              final controller = ref.read(playerProvider.notifier);
              controller.changeReadyPhoto(pickedPhoto);
            },
          ),
        ),
      ],
    );
  }
}
