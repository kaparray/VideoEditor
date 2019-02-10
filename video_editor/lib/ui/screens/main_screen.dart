import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_editor/blocs/bloc.dart';
import 'package:video_editor/ui/screens/video_upload.dart';
import 'package:video_editor/ui/utils/log.dart';
import 'package:video_editor/ui/views/video_grid_view.dart';

class VideoAppScreen extends StatefulWidget {
  @override
  createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoAppScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
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
                if (List.castFrom(snapshot.data).length > 0)
                  return _gridBuilder(snapshot.data);
                else if (List.castFrom(snapshot.data).length == 0)
                  return Center(
                    child: Text('No data!'),
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
