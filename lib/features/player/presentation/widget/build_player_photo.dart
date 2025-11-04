import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/entities/player_photo/photo_source.dart';
import '../../domain/entities/player_photo/player_photo.dart';

class BuildPlayerPhoto extends StatelessWidget {
  const BuildPlayerPhoto(this.playerPhoto, {super.key});
  final PlayerPhoto playerPhoto;

  @override
  Widget build(BuildContext context) {
    return switch (playerPhoto.photoSource) {
      PhotoSource.asset => const _FallBackImage(),
      PhotoSource.picked => _PickedPhoto(playerPhoto.path!),
    };
  }
}

class _FallBackImage extends StatelessWidget {
  const _FallBackImage();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),

      child: Image.asset('assets/images/boy_jumping.jpg', fit: BoxFit.fill),
    );
  }
}

class _PickedPhoto extends StatelessWidget {
  const _PickedPhoto(this.pickedImagePath);
  final String pickedImagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),

      child: Image.file(
        File(pickedImagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const _FallBackImage(),
      ),
    );
  }
}
