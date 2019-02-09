import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_editor/blocs/bloc.dart';
import 'package:video_editor/ui/screens/video_upload.dart';
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
    bloc.fetchSavedNews();
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async => await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => UploadVideo(),
                    fullscreenDialog: true,
                  )).then((val) {
                setState(() {
                  bloc.saveVideo(File(val));  
                });
              }),
          icon: Icon(Icons.add),
          label: Text("Upload Video"),
        ),
        appBar: AppBar(title: Text('Video Editor')),
        body: SafeArea(
          child: StreamBuilder(
            stream: bloc.video,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              try{
                if (List.castFrom(snapshot.data).length > 0)
                  return _gridBuilder(snapshot.data);
                else if (List.castFrom(snapshot.data).length == 0)
                  return Center(child: Text('No data!'),);
              } on NoSuchMethodError {
                return Center(child: CircularProgressIndicator(),);
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
}
