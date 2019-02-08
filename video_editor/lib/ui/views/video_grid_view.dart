import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_editor/ui/screens/main_screen.dart';
import 'package:video_editor/ui/screens/video_full_screeen.dart';
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
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {
          _controller
            ..setLooping(true)
            ..setVolume(0);
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
    return InkWell(
      onLongPress: () =>
          streamController.add(_deleteVideo()), // ToDo delite video
      onTap: () => _openVideoFullScreen(context), // ToDo make redactor video
      child: Card(
        child: _videoBuild(),
      ),
    );
  }

  _videoBuild() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            alignment: Alignment.center,
            child: FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                child: Container(
                  width: 197.7,
                  height: 197.7,
                  child: _controller.value.initialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(),
                ))));
  }

  _openVideoFullScreen(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => VideoFullScreen(widget.file)));
  }

  _deleteVideo() async {
    listVideoPath.remove(widget.file);
    await new Directory(widget.file.path.toString()).delete(recursive: true);
  }
}
