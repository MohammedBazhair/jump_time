import 'dart:io';

import '../../../../../../core/constants/images.dart';

sealed class AvatarPhoto {}

class AssetAvatar extends AvatarPhoto {
  AssetAvatar({ this.path= Images.defaultAvatar});

  final String path;
}

class PickedAvatar extends AvatarPhoto {
  PickedAvatar({required this.file});

  final File file;
}
