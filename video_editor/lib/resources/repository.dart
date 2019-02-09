import 'provider.dart';

final provider = CustomProvider();

class Repository {
  
  getSavedVideo() async {
    return await provider.getMyVideo();
  }

  saveVideo(file) async => await provider.uploadMyVideo(file);
  deleteVideo(file) async => await provider.deleteMyVideo(file);
}

