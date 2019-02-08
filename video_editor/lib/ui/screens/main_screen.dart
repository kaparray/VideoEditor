import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/ui/screens/video_upload.dart';
import 'package:video_editor/ui/views/video_grid_view.dart';

class VideoAppScreen extends StatefulWidget {
  @override
  createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoAppScreen> {
  List _listVideoPath;
  Widget _centerLocalWidget = CircularProgressIndicator();

  Future getAllFile() async {
    if (Platform.isAndroid) {
      final Directory extDir =
          await getExternalStorageDirectory(); // Only for Aandroid
      final String dirPath = '${extDir.path}/VideoEditor/Videos';
      Stream<FileSystemEntity> a = Directory(dirPath).list();
      _listVideoPath = await a.toList();
    } else if (Platform.isIOS) {
      // ToDo list video in local path for IOS platform
    }
  }

  @override
  void initState() {
    try {
      getAllFile().then((_) {
        setState(() {});
      });
    } catch (UnhandledException) {
      _centerLocalWidget = Text(
        'Ooops!\nNo video in app.\nMay be upload video?',
        style: TextStyle(fontSize: 18),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async => await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => UploadVideo(),
                    fullscreenDialog: true,
                  )).then((val) {
                setState(() {
                  _listVideoPath.add(File(val));
                });
              }),
          icon: Icon(Icons.add),
          label: Text("Upload Video"),
        ),
        appBar: AppBar(title: Text('Video Editor')),
        body: SafeArea(
          child: _listVideoPath == null
              ? Center(
                  child: _centerLocalWidget,
                )
              : _gridBuilder(_listVideoPath.length),
        ));
  }

  _gridBuilder(int length) {
    return GridView.builder(
      itemCount: length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return VideoGrid(_listVideoPath[index]);
      },
    );
  }
}
