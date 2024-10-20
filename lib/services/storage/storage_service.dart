import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Upload image
  Future<void> uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      try {
        await _storage.ref('${pickedFile.name}').putFile(file);
        print('Upload successful');
      } catch (e) {
        print('Upload failed: $e');
      }
    }
  }

  // Read image
  Future<String?> readURL(String fileName) async {
    try {
      String downloadURL = await _storage.ref('$fileName').getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Lỗi đọc dữ liệu: $e');
      return null;
    }
  }

  // Update image
  Future<void> updateImage(String oldFileName) async {
    await deleteImage(oldFileName); // Delete old image
    await uploadImage(); // Upload new image
  }

  // Delete image
  Future<void> deleteImage(String fileName) async {
    try {
      await _storage.ref('$fileName').delete();
    } catch (e) {
      print('Xóa thất bại: $e');
    }
  }

}
