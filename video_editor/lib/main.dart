import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_editor/Constants/Constatnts.dart';
import 'package:video_editor/ui/screens/camera_screen.dart';
import 'package:video_editor/ui/screens/main_screen.dart';

List<CameraDescription> cameras;

void main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e.code + ' ' + e.description);
  }

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: <String, WidgetBuilder>{
        HOME_SCREEN: (BuildContext context) => VideoAppScreen(),
        CAMERA_SCREEN: (BuildContext context) => CameraHomeScreen(cameras),
      },
      home: VideoAppScreen(),
    );
  }
}
