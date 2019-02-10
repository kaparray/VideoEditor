import 'dart:io';

import '../resources/repository.dart';
import 'dart:async';

class Bloc {
  final _repository = Repository();
  var _controllerVideo = StreamController.broadcast();
  Stream get video => _controllerVideo.stream;

  Future fetchSavedNews() async =>
      _controllerVideo.add(await _repository.getSavedVideo());

  Future deleteVideo(File file) async =>
      _controllerVideo.add(await _repository.deleteVideo(file));

  Future saveImagePreview(path) async => await _repository.saveImagePreview(path);
}

final bloc = Bloc();
