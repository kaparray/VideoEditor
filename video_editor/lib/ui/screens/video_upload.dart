import 'package:flutter/material.dart';
import 'package:video_editor/blocs/bloc.dart';
import 'package:video_editor/main.dart';
import 'package:video_editor/ui/screens/camera_screen.dart';
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
      body: Builder(
        builder: (BuildContext _context) {
          return SafeArea(
              child: Container(
                  padding: EdgeInsets.all(16),
                  child: _columnWidgets(_context)));
        },
      ),
    );
  }

  _columnWidgets(BuildContext context) {
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
            onPressed: () {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Coming soon...'),
                backgroundColor: Colors.grey[700],
              ));
            },
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
    final videoPath = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => CameraHomeScreen(cameras)));
    await bloc.saveImagePreview(videoPath);
    setState(() {
      _videoPath = videoPath;
    });
  }

  ////////////////////////////////////////////////////////////////////////////////////
  //                For load video from device. Not use right now                   //
  ////////////////////////////////////////////////////////////////////////////////////
  //  _uploadVideo() async {                                                        //
  //    var videoPath = await ImagePicker.pickVideo(source: ImageSource.gallery);   //
  //    setState(() {                                                               //
  //      _videoPath = videoPath.uri.toString();                                    //
  //    });                                                                         //
  //  }                                                                             //
  ////////////////////////////////////////////////////////////////////////////////////
}
