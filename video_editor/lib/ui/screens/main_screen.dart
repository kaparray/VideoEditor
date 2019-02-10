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

    PermissionStatus _status;

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
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }

  void _askPermission() {
    PermissionHandler().requestPermissions(
        [PermissionGroup.locationWhenInUse]).then(_onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.storage];
    if (status != PermissionStatus.granted) {
      PermissionHandler().openAppSettings();
    } else {
      _updateStatus(status);
    }
  }

   @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                if (_status == PermissionStatus.denied)
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('No permission on your Storage!\nPlease fix it 😄', textAlign: TextAlign.center),
                        OutlineButton(onPressed: () => _askPermission(), child: Text('Click me'),)
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

  

  _gridBuilder(List data) {
    return GridView.builder(
      itemCount: data.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return VideoGrid(data[index]);
      },
    );
  }

  _fullScreenDialogUpload() async {
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
