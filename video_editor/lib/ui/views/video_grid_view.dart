import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_editor/blocs/bloc.dart';
import 'package:video_editor/ui/screens/video_full_screeen.dart';
import 'package:thumbnails/thumbnails.dart';

class VideoGrid extends StatefulWidget {
  final File file;
  VideoGrid(this.file);
  @override
  createState() => VideoGridState();
}

class VideoGridState extends State<VideoGrid> {

  String _image;

  Future<String> _noFolder() async {
    String thumb = await Thumbnails.getThumbnail(
        thumbnailFolder: '/storage/emulated/0/VideoEditor/ImagePreview',
        videoFile: widget.file.path.toString(),
        imageType: ThumbFormat.JPEG,
        quality: 30);
    return thumb.toString();
  }


@override
  void initState() {
    _noFolder().then((val){
      _image = val;
      setState(() {
        
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _noFolder();
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
                  child: Image.file(File(_image))
                ))));
  }

  _openVideoFullScreen(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => VideoFullScreen(widget.file)));
  }
}
