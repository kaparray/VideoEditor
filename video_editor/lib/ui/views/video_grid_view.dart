import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_editor/blocs/bloc.dart';
import 'package:video_editor/ui/screens/video_full_screeen.dart';

class VideoGrid extends StatefulWidget {
  final File file;
  final int index;
  VideoGrid(this.file, this.index);

  @override
  State<VideoGrid> createState() => VideoGridState();
}

class VideoGridState extends State<VideoGrid> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        bloc.deleteVideo(widget.file);
      },
      onTap: () => _openVideoFullScreen(context), // ToDo make redactor video
      child: Card(
        child: _videoBuild(),
      ),
    );
  }

  Hero _videoBuild() {
    return Hero(
      tag: 'video_${widget.index}',
      child: ClipRRect(
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
                    child: Image.file(File(widget.file.path
                        .replaceFirst('Videos', 'ImagePreview')
                        .replaceFirst('mp4', 'jpg'))),
                  )))),
    );
  }

  Future<Image> buildImage() async {
    return Image.file(File(widget.file.path
        .toString()
        .replaceFirst('Videos', 'ImagePreview')
        .replaceFirst('mp4', 'jpg')));
  }

  void _openVideoFullScreen(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => VideoFullScreen(widget.file, widget.index)));
  }
}
