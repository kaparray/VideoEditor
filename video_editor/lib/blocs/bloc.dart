import 'dart:io';

import '../resources/repository.dart';
import 'dart:async';

class Bloc {
  final _repository = Repository();
  var _controllerVideo = StreamController.broadcast();
  Stream get video => _controllerVideo.stream;

  fetchSavedNews() async =>
      _controllerVideo.add(await _repository.getSavedVideo());

  deleteVideo(File file) async =>
      _controllerVideo.add(await _repository.deleteVideo(file));

  saveImagePreview(path) async => await _repository.saveImagePreview(path);
}

final bloc = Bloc();
