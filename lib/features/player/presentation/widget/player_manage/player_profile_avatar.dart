import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/player_photo/photo_source.dart';
import '../../controller/player_controller.dart';
import '../../helpers/helpers.dart';

class PlayerProfileAvatar extends ConsumerWidget {
  const PlayerProfileAvatar(this.playerId, {super.key});

  final int playerId;
  @override
  Widget build(BuildContext context, ref) {
    return Column(
      spacing: 10,
      children: [
        GestureDetector(
          onTap: () async {
            final playerImage = await pickCameraImage();
            final controller = ref.read(playerProvider.notifier);
            controller.changePlayerPhoto(playerId, playerImage);
          },
          child: Stack(
            children: [
              PlayerAvatarImage(playerId),
              Positioned(bottom: 5, right: 5, child: PhotoPickerIcon(playerId)),
            ],
          ),
        ),
        BuildPlayerName(playerId),
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

    return CircleAvatar(radius: 65, backgroundImage: imageProvider);
  }
}

class PhotoPickerIcon extends StatelessWidget {
  const PhotoPickerIcon(this.playerId, {super.key});
  final int playerId;

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
  const BuildPlayerName(this.playerId, {super.key});
  final int playerId;

  @override
  Widget build(BuildContext context, ref) {
    final playerName = ref.watch(
      playerProvider.select((state) => state.players[playerId]!.name),
    );

    return Text(
      playerName,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize:18, fontWeight: FontWeight.bold),
    );
  }
}
