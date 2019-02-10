import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_editor/blocs/bloc.dart';
import 'package:video_editor/ui/screens/video_upload_screen.dart';
import 'package:video_editor/ui/utils/log.dart';
import 'package:video_editor/ui/views/video_grid_view.dart';

class VideoAppScreen extends StatefulWidget {
  @override
  createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoAppScreen> with WidgetsBindingObserver {
  PermissionStatus _statusStorage;
  PermissionStatus _statusCamera;
  PermissionStatus _statusSpeech;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then(_updateStatus);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage)
          .then(_updateStatus);
    }
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _statusStorage ||
        status != _statusCamera ||
        status != _statusSpeech) {
      setState(() {
        _statusStorage = status;
      });
    }
  }

  Future<void> _askPermission() async {
    await PermissionHandler().requestPermissions([
      PermissionGroup.storage,
      PermissionGroup.camera,
      PermissionGroup.speech
    ]).then(_onStatusRequested);
  }

  Future<void> _onStatusRequested(
      Map<PermissionGroup, PermissionStatus> statuses) async {
    final statusStorage = statuses[PermissionGroup.storage];
    final statusCamera = statuses[PermissionGroup.camera];
    final statusSpeech = statuses[PermissionGroup.speech];
    if (statusStorage != PermissionStatus.granted) {
      await PermissionHandler().openAppSettings();
    } else if (statusStorage == PermissionStatus.granted) {
      _updateStatus(statusStorage);
    } else if (statusCamera == PermissionStatus.granted) {
      _updateStatus(statusCamera);
    } else if (statusSpeech == PermissionStatus.granted) {
      _updateStatus(statusSpeech);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Widget build 123');
    bloc.fetchSavedNews();
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _fullScreenDialogUpload,
          icon: Icon(Icons.add),
          label: Text("Upload Video"),
        ),
        appBar: AppBar(title: Text('Video Editor')),
        body: SafeArea(
          child: StreamBuilder(
            stream: bloc.video,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              try {
                if (_statusStorage == PermissionStatus.denied)
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('No permission on your Storage!\nPlease fix it 😄',
                            textAlign: TextAlign.center),
                        OutlineButton(
                          onPressed: () async => await _askPermission(),
                          child: Text('Click me'),
                        )
                      ],
                    ),
                  );
                else if (List.castFrom(snapshot.data).length > 0)
                  return _gridBuilder(snapshot.data);
                else if (List.castFrom(snapshot.data).length == 0)
                  return Center(
                    child: Text('No data in storage!'),
                  );
              } on NoSuchMethodError {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  GridView _gridBuilder(List data) {
    return GridView.builder(
      itemCount: data.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return VideoGrid(data[index], index);
      },
    );
  }

  Future<void> _fullScreenDialogUpload() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => UploadVideo(),
          fullscreenDialog: true,
        ));

    if (result != null && result is String)
      try {
        await bloc.fetchSavedNews();
      } catch (e) {
        log(e, 'saveVideo');
      }
  }
}
