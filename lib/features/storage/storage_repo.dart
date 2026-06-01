import 'dart:typed_data';

abstract class StorageRepo{
  //PROFILE IMAGE UPLOAD
  Future<String?> uploadProfileImageMobile(String path, String fileName);
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);

  //POST IMAGE UPLOAD
  Future<String?> uploadPostImageMobile(String path, String fileName);
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName);
} 