import 'package:permission_handler/permission_handler.dart';

class DataPermission {
  static Future<bool> requestStoragePermissions() async {
    if (!(await checkCameraPermissions())) {
      final storagePermission = await Permission.storage.request();
      if (storagePermission.isGranted) {
        return true;
      }
      else {
        return false;
      }
    }
    else{
      return true;
    }
  }

  static Future<bool> requestCameraePermissions() async {
    if (!(await checkCameraPermissions())) {
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission.isGranted) {
        return true;
      }
      else{
        return false;
      }
    }
    else{
      return true;
    }
     
  }

  static Future<bool> checkCameraPermissions() async {
    final cameraPermission = await Permission.camera.status;
    if (cameraPermission.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkStoragePermissions() async {
    final storagePermission = await Permission.storage.status;
    if (storagePermission.isGranted) {
      return true;
    } else {
      return false;
    }
  }


}
