import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../domain/entities/player_entity/sub_entity/avatar_photo.dart';

Future<AvatarPhoto> pickCameraImage() async {
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
  if (pickedFile == null) return AssetAvatar();
  return PickedAvatar(file: File(pickedFile.path));
}
