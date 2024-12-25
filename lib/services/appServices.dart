import 'dart:io';

import 'package:share_plus/share_plus.dart';

class Messages {
  static bool EdeleteSts = true;
  static String EdeleteMSj = "";
}

class Appservices {
  static fileShare(String filepath) async {
    final result =
        await Share.shareXFiles([XFile(filepath)], text: 'Great picture');

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the picture!');
    }
  }

  static Future<int> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      await file.delete();
      Messages.EdeleteMSj = "Deleted Sucessfully";
      Messages.EdeleteSts = true;
    } catch (e) {
      print(e.toString());
      Messages.EdeleteSts = false;
      Messages.EdeleteMSj = "Error in deleting";
    }
    return 0;
  }
}
