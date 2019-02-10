import 'provider.dart';

final provider = CustomProvider();

class Repository {
  getSavedVideo() async {
    return await provider.getMyVideo();
  }

  deleteVideo(file) async => await provider.deleteMyVideo(file);
  saveImagePreview(path) async => await provider.saveImagePreview(path);
}
