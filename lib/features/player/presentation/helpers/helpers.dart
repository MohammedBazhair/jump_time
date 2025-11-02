import 'package:image_picker/image_picker.dart';

import '../../domain/entities/player_photo/photo_source.dart';
import '../../domain/entities/player_photo/player_photo.dart';

Future<PlayerPhoto> pickCameraImage() async {
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

  return PlayerPhoto(photoSource: PhotoSource.picked, path: pickedFile?.path);
}
