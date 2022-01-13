import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider{
  static Future<PickedFile> getImageFromCamera(BuildContext context)  async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera ,
    );
    print("pickedFile" + pickedFile.toString());
    return pickedFile;
  }

  static Future<PickedFile> getImageFromGallery(BuildContext context) async{
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery ,
    );
    print("pickedFile" + pickedFile.toString());
    return pickedFile;
  }
}