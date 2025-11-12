import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';
import '../../domain/entities/player_entity/sub_entity/avatar_photo.dart';
import 'inherited_widget/player_id_provider.dart';

class BuildPlayerPhoto extends StatefulWidget {
  const BuildPlayerPhoto(this.playerPhoto, {super.key});
  final AvatarPhoto playerPhoto;

  @override
  State<BuildPlayerPhoto> createState() => _BuildPlayerPhotoState();
}

class _BuildPlayerPhotoState extends State<BuildPlayerPhoto> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    final child = switch (widget.playerPhoto) {
      AssetAvatar() => const _FallBackImage(),
      PickedAvatar(:final file) => _PickedPhoto(file),
    };
    final shadows = [
      const BoxShadow(
        offset: Offset(1.5, 2.5),
        blurRadius: 2,
        spreadRadius: .5,
        color: Color.fromARGB(51, 54, 54, 54),
      ),
    ];

    return GestureDetector(
      onTapDown: (details) {
        setState(() => isHover = true);
      },
      onTapCancel: () {
        setState(() => isHover = false);
      },
      onTap: () {
        setState(() => isHover = false);
      },

      onDoubleTap: () {
        final playerId = PlayerIdProvider.of(context).playerId;

        Navigator.of(
          context,
        ).pushNamed(ViewRoute.playerManagement.routeName, arguments: playerId);
      },
      child: Transform.scale(
        scale: isHover ? 0.98 : 1,
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: isHover ? null : shadows,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _FallBackImage extends StatelessWidget {
  const _FallBackImage();
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/boy_jumping.jpg', fit: BoxFit.fill);
  }
}

class _PickedPhoto extends StatelessWidget {
  const _PickedPhoto(this.imageFile);
  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      imageFile,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const _FallBackImage(),
    );
  }
}
