import 'package:flutter/material.dart';
import 'package:video_editor/Constants/Constatnts.dart';

class VideoAppScreen extends StatefulWidget {
  @override
  createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoAppScreen> {
  String _videoPath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Editor'),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          _getActionButton(),
        ],
      )),
    );
  }

  _getActionButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Card(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: Text('Gallary'),
              onPressed: () {},
            ),
            FlatButton(
              child: Text('Record video'),
              onPressed: _recordVideo,
            ),
          ],
        ),
      ),
    );
  }

  Future _recordVideo() async {
    final videoPath = await Navigator.of(context).pushNamed(CAMERA_SCREEN);
    setState(() {
      _videoPath = videoPath;
    });
  }
}
