import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final String storageBucketUrl =
      'https://firebasestorage.googleapis.com/v0/b/cntt304-bansanphamgiadun-10457.appspot.com/o/';
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Upload image with a custom image name
  Future<String> uploadImage(File image, String evidenceCode) async {
    try {
      // Tạo tên file từ mã vật chứng (evidence code)
      String fileName = 'VCDT/$evidenceCode.jpg';

      // Upload file
      UploadTask uploadTask = _firebaseStorage.ref().child(fileName).putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      // Lấy URL tải về
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // Get the URL of the image based on its name
  String getImageUrl(String imageName) {
    print('$storageBucketUrl$imageName.jpg?alt=media');
    return '$storageBucketUrl$imageName.jpg?alt=media';
  }
  Future<String?> getVCDTImage(String imageName) async {
    try {
      String fileName = 'VCDT/$imageName.jpg';
      String downloadURL = await _firebaseStorage.ref(fileName).getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        print('No image found for $imageName');
        return null;
      } else {
        print('Unexpected Firebase error: $e');
        return null;
      }
    } catch (e) {
      print('Error getting image URL: $e');
      return null;
    }
  }
}
