import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFullScreen extends StatefulWidget {
  final File file;

  VideoFullScreen(this.file);

  @override
  createState() => VideoFullScreenState();
}

class VideoFullScreenState extends State<VideoFullScreen> {
  VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {
          _controller
            ..setLooping(true)
            ..setVolume(1)
            ..play();
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.file.uri.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Editing video'),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _controller.value.initialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
            Text(widget.file.uri.toString().replaceFirst(
                'file:///storage/emulated/0/VideoEditor/Videos/', ''))
          ],
        ),
      ),
    );
  }
}
