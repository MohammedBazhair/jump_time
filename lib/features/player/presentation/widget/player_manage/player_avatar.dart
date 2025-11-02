import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/player_photo/photo_source.dart';
import '../../controller/player_controller.dart';
import '../../helpers/helpers.dart';

class PlayerProfileAvatar extends StatelessWidget {
  const PlayerProfileAvatar(this.playerId, {super.key});

  final int playerId;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlayerAvatarImage(playerId),
        PlayerPhotoPickerButton(playerId),
      ],
    );
  }
}

class PlayerAvatarImage extends ConsumerWidget {
  const PlayerAvatarImage(this.playerId, {super.key});

  final int playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerPhoto = ref.watch(
      playerProvider.select((state) => state.players[playerId]!.playerPhoto),
    );

    final imageProvider = switch (playerPhoto.photoSource) {
      PhotoSource.asset => Image.asset('assets/images/boy_jumping.jpg').image,
      PhotoSource.picked => Image.file(File(playerPhoto.path!)).image,
    };

    return CircleAvatar(radius: 35, backgroundImage: imageProvider);
  }
}

class PlayerPhotoPickerButton extends StatelessWidget {
  const PlayerPhotoPickerButton(this.playerId, {super.key});
  final int playerId;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Consumer(
        builder: (_, ref, __) {
          return IconButton(
            onPressed: () async {
              final playerImage = await pickCameraImage();
              final controller = ref.read(playerProvider.notifier);
              controller.changePlayerPhoto(playerId, playerImage);
            },
            icon: const Icon(Icons.add_a_photo, size: 15),
          );
        },
      ),
    );
  }
}
