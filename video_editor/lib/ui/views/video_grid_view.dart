import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoGrid extends StatefulWidget {
  final File file;
  VideoGrid(this.file);
  @override
  createState() => VideoGridState();
}

class VideoGridState extends State<VideoGrid> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {
          _controller
            ..setLooping(true)
            ..setVolume(0)
            ..play();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            // this is a Video
            width: 160,
            height: 90,
            child: Center(
              child: _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
          ),
          Text(widget.file.toString()) // Video name
        ],
      ),
    );
  }
}
