import 'provider.dart';

final provider = CustomProvider();

class Repository {
  Future getSavedVideo() async {
    return await provider.getMyVideo();
  }

  Future deleteVideo(file) async => await provider.deleteMyVideo(file);
  Future saveImagePreview(path) async => await provider.saveImagePreview(path);
}
