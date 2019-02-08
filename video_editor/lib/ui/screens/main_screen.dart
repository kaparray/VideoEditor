import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/ui/views/video_grid_view.dart';

class VideoAppScreen extends StatefulWidget {
  @override
  createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoAppScreen> {
  List _listVideoPath;

  Future getAllFile() async {
    final Directory extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.path}/VideoEditor/Videos';
    Stream<FileSystemEntity> a = Directory(dirPath).list();
    _listVideoPath = await a.toList();
  }

  @override
  void initState() {
    getAllFile().then((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () =>
              print('Test FAB'), //_onImageButtonPressed(ImageSource.gallery),
          icon: Icon(Icons.add),
          label: Text("Upload Video"),
        ),
        appBar: AppBar(title: Text('Video Editor')),
        body: SafeArea(
          child: _listVideoPath == null
              ? Center(
                  child: CircularProgressIndicator(),
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
