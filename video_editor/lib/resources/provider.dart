import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';


class CustomProvider {

  getMyVideo() async {
    if (Platform.isAndroid) {
      final Directory extDir =
          await getExternalStorageDirectory(); // Only for Aandroid
      final String dirPath = '${extDir.path}/VideoEditor/Videos';
      print(dirPath);
      Stream<FileSystemEntity> a = Directory(dirPath).list();
      listVideoPath.toSet().add(await a.toSet()..toList());
      print(listVideoPath);
      return listVideoPath;
    } else if (Platform.isIOS) {
      // ToDo list video in local path for IOS platform
    }
  }

  uploadMyVideo(File file) async {
    listVideoPath.add(file);
    return listVideoPath;
  }

  deleteMyVideo(File file) async {
    listVideoPath.remove(file);
    await new Directory(file.path.toString()).delete(recursive: true);
    return listVideoPath;
  }
}


List listVideoPath = [];