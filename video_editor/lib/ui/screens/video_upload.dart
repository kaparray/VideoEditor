import 'package:flutter/material.dart';
import 'package:video_editor/constants/constatnts.dart';
import 'package:video_editor/ui/utils/fited_box.dart';

class UploadVideo extends StatefulWidget {
  @override
  createState() => UploadVideoState();
}

class UploadVideoState extends State<UploadVideo> {
  String _videoPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Upload'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context, _videoPath),
            child: Text(
              'SAVE',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(padding: EdgeInsets.all(16), child: _columnWidgets()),
      ),
    );
  }

  _columnWidgets() {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter name here',
            labelText: 'Video name',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
        fitedBox(10),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter dicription here',
            labelText: 'Dicription',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
        fitedBox(10),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16.0)),
            child: Text('Upload video'),
            onPressed: () {},
          ),
        ),
        fitedBox(6),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16.0)),
            child: Text('Record video'),
            onPressed: _recordVideo,
          ),
        ),
      ],
    );
  }

  _recordVideo() async {
    final videoPath = await Navigator.of(context).pushNamed(CAMERA_SCREEN);
    setState(() {
      _videoPath = videoPath;
    });
  }
}
