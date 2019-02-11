import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_editor/blocs/bloc.dart';
import 'package:video_editor/main.dart';
import 'package:video_editor/ui/screens/camera_screen.dart';
import 'package:video_editor/ui/utils/fited_box.dart';
import 'package:video_editor/ui/utils/log.dart';

class UploadVideo extends StatefulWidget {
  @override
  createState() => UploadVideoState();
}

class UploadVideoState extends State<UploadVideo> with WidgetsBindingObserver {
  String _videoPath;
  PermissionStatus _statusStorage;
  PermissionStatus _statusCamera;
  PermissionStatus _statusSpeech;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then(_updateStatusStorage);
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera)
        .then(_updateStatusCamera);
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone)
        .then(_updateStatusSpeech);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log(state, 'state');
    if (state == AppLifecycleState.resumed) {
      PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage)
          .then(_updateStatusStorage);
      PermissionHandler()
          .checkPermissionStatus(PermissionGroup.camera)
          .then(_updateStatusCamera);
      PermissionHandler()
          .checkPermissionStatus(PermissionGroup.microphone)
          .then(_updateStatusSpeech);
    }
  }

  void _updateStatusSpeech(PermissionStatus status) {
    if (status != _statusSpeech) {
      _statusSpeech = status;
    }
  }

  void _updateStatusCamera(PermissionStatus status) {
    if (status != _statusCamera) {
      _statusCamera = status;
    }
  }

  void _updateStatusStorage(PermissionStatus status) {
    if (status != _statusStorage) {
      _statusStorage = status;
    }
  }

  Future<void> _askPermission() async {
    await PermissionHandler().requestPermissions([
      PermissionGroup.storage,
      PermissionGroup.camera,
      PermissionGroup.speech
    ]).then(_onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final statusStorage = statuses[PermissionGroup.storage];
    final statusCamera = statuses[PermissionGroup.camera];
    final statusSpeech = statuses[PermissionGroup.speech];

    if (statusStorage == PermissionStatus.granted) {
      _updateStatusStorage(statusStorage);
    }
    if (statusCamera == PermissionStatus.granted) {
      _updateStatusCamera(statusCamera);
    }
    if (statusSpeech == PermissionStatus.granted) {
      _updateStatusSpeech(statusSpeech);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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

  Column _columnWidgets(BuildContext context) {
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
            onPressed: () async => await _recordVideo(context),
          ),
        ),
      ],
    );
  }

  Future<void> _recordVideo(_context) async {
    await _askPermission();

    if (_statusStorage == PermissionStatus.granted &&
        _statusCamera == PermissionStatus.granted &&
        _statusSpeech == PermissionStatus.granted) {
      final videoPath = await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => CameraHomeScreen(cameras)));
      if (videoPath == false) {
        Scaffold.of(_context).showSnackBar(SnackBar(
          content: Text(
            'No permission on your Camera or Microphone!\nPlease fix it 😄',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.grey[700],
          duration: Duration(milliseconds: 1500),
        ));
      } else {
        await bloc.saveImagePreview(videoPath);
        setState(() {
          _videoPath = videoPath;
        });
      }
    } else {
      Scaffold.of(_context).showSnackBar(SnackBar(
        content: Text('No permission on your Storage!\nPlease fix it 😄',
            textAlign: TextAlign.center),
        backgroundColor: Colors.grey[700],
        duration: Duration(milliseconds: 1500),
      ));
    }
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
