import 'package:firebase_storage/firebase_storage.dart';

class HinhAnhUlt{
  static Future<String> getImageUrl(String gsUrl) async {
    if (gsUrl.startsWith('gs://') || gsUrl.startsWith('https://')) {
      try {
        final ref = FirebaseStorage.instance.refFromURL(gsUrl);
        String downloadUrl = await ref.getDownloadURL();
        return downloadUrl;
      } catch (e) {
        print("Error getting image URL: $e");
        return '';
      }
    } else {
      print("Invalid URL format: $gsUrl");
      return ''; // Return an empty string or handle the invalid URL case
    }
  }
}