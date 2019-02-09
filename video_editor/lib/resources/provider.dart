import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class CustomProvider {
  getMyVideo() async {
    if (Platform.isAndroid) {
      final Directory extDir =
          await getExternalStorageDirectory(); // Only for Aandroid
      final String dirPath = '${extDir.path}/VideoEditor/Videos';
      Stream<FileSystemEntity> a = Directory(dirPath).list();
      return await a.toList();
    } else if (Platform.isIOS) {
      // ToDo list video in local path for IOS platform
    }
  }

  uploadMyVideo(File file) async {
    final Directory extDir =
        await getExternalStorageDirectory(); 
    final String dirPath = '${extDir.path}/VideoEditor/Videos';
    file.copySync(dirPath);
    return getMyVideo();
  }

  deleteMyVideo(File file) async {
    await new Directory(file.path.toString()).delete(recursive: true);
    return await getMyVideo();
  }
}
