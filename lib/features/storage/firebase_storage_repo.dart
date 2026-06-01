import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_app/features/storage/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo{
  final FirebaseStorage storage = FirebaseStorage.instance;

  //UPLOAD POST IMAGE
  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }
 

  //UPLOAD PROFILE IMAGE

  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }


  // Uploading methods

  Future<String?> _uploadFile(String path, String fileName, String folder) async {
    try {
      final file = File(path);

      final storageRef = storage.ref().child('$folder/$fileName');
      
      final uploadTask = await storageRef.putFile(file); 

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  } 

  Future<String?> _uploadFileBytes( Uint8List fileBytes, String fileName, String folder,) async {
    try {

    final storageRef = storage.ref().child('$folder/$fileName.jpg');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
    );

    final uploadTask = await storageRef.putData(
      fileBytes,
      metadata,
    );

    final downloadUrl =
        await uploadTask.ref.getDownloadURL();

    return downloadUrl;
    } catch (e) {

    print(e);

    return null;

}
}


 
}