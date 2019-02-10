# VideoEditor
Video editor dy flutter


# NewsApp
News app in Flutter with BLOC pattern

This example uses a Video player, Camera, Directory, Thumbnails, GridData, ClipRRect, Card, Progress Indicator, Card, Column, Row, Container, InkWell, BoxDecoration.



### Library 
* [*__camera__*](https://pub.dartlang.org/packages/camera)
* [*__path_provider__*](https://pub.dartlang.org/packages/path_provider)
* [*__video_player__*](https://pub.dartlang.org/packages/video_player)
* [*__thumbnails__*](https://pub.dartlang.org/packages/thumbnails)
* [*__simple_share__*](https://pub.dartlang.org/packages/simple_share)
* [*__cloud_firestore__*](https://pub.dartlang.org/packages/cloud_firestore)
* [*__file_picker__*](https://pub.dartlang.org/packages/file_picker)


### Bloc pattern

*I used this pattern to design this application.*

<img src="https://cdn-images-1.medium.com/max/1600/1*MqYPYKdNBiID0mZ-zyE-mA.png"  width="400">

```dart
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

```

## Built With
* [Flutter](https://flutter.io) - Crossplatform App Development Framework

## Author
Adeshchenko Kirill (Cyrill) ([@kaparray](https://www.linkedin.com/in/kirill-adeshchenko-b86362161/))
