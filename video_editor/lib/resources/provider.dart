import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:thumbnails/thumbnails.dart';

class CustomProvider {
  Future getMyVideo() async {
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

  Future saveImagePreview(path) async {
    await Thumbnails.getThumbnail(
        thumbnailFolder: '/storage/emulated/0/VideoEditor/ImagePreview',
        videoFile: path,
        imageType: ThumbFormat.JPEG,
        quality: 30);
  }

  Future deleteMyVideo(File file) async {
    await new Directory(file.path.toString()).delete(recursive: true);
    return await getMyVideo();
  }
}
