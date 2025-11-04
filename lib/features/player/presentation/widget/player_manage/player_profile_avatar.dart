import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/player_photo/photo_source.dart';
import '../../controller/player_controller.dart';
import '../../helpers/helpers.dart';
import '../inherited_widget/player_id_provider.dart';

class PlayerProfileAvatar extends ConsumerWidget {
  const PlayerProfileAvatar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final playerId = PlayerIdProvider.of(context).playerId;
    return Column(
      spacing: 10,
      children: [
        GestureDetector(
          onTap: () async {
            final playerImage = await pickCameraImage();
            final controller = ref.read(playerProvider.notifier);
            controller.changePlayerPhoto(playerId, playerImage);
          },
          child: const Stack(
            children: [
              PlayerAvatarImage(),
              Positioned(bottom: 5, right: 5, child: PhotoPickerIcon()),
            ],
          ),
        ),
        const BuildPlayerName(),
      ],
    );
  }
}

class PlayerAvatarImage extends ConsumerWidget {
  const PlayerAvatarImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerId = PlayerIdProvider.of(context).playerId;

    final playerPhoto = ref.watch(
      playerProvider.select((state) => state.players[playerId]!.playerPhoto),
    );

    final imageProvider = switch (playerPhoto.photoSource) {
      PhotoSource.asset => Image.asset('assets/images/boy_jumping.jpg').image,
      PhotoSource.picked => Image.file(File(playerPhoto.path!)).image,
    };

    return CircleAvatar(radius: 65, backgroundImage: imageProvider);
  }
}

class PhotoPickerIcon extends StatelessWidget {
  const PhotoPickerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: Color(0xF806AC5C),
      radius: 18,
      child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
    );
  }
}

class BuildPlayerName extends ConsumerWidget {
  const BuildPlayerName({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final playerId = PlayerIdProvider.of(context).playerId;

    final playerName = ref.watch(
      playerProvider.select((state) => state.players[playerId]!.name),
    );

    return Text(
      playerName,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
