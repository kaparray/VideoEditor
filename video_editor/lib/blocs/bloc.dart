import 'dart:io';

import '../resources/repository.dart';
import 'dart:async';

/// This class is responsible for the application logic.
/// Check this => https://medium.com/flutterpub/architecting-your-flutter-project-bd04e144a8f1
class Bloc {
  final _repository = Repository();
  var _controllerVideo = StreamController.broadcast();
  Stream get video => _controllerVideo.stream;

  /// The method finds all videos in the application folder on the user's device
  Future fetchSavedVideo() async =>
      _controllerVideo.add(await _repository.getSavedVideo());

  /// The method delete image preview and video in the application folder on the user's device
  Future deleteVideo(File file) async =>
      _controllerVideo.add(await _repository.deleteVideo(file));

  /// The method save image preview in the application folder on the user's device
  Future saveImagePreview(path) async => await _repository.saveImagePreview(path);
}

final bloc = Bloc();
