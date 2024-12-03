import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {

  Future<XFile?> pickImage(ImageSource imageSource) async {
    try {
      final ImagePicker picker = ImagePicker();
      return await picker.pickImage(
        source: imageSource,
      );
    } catch (e) {
      return null;
    }
  }
}