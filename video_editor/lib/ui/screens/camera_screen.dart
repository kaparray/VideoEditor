import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class CameraHomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraHomeScreen(this.cameras);

  @override
  createState() => _CameraHomeScreenState();
}

class _CameraHomeScreenState extends State<CameraHomeScreen> {
  String imagePath;
  bool _toggleCamera = false;
  bool _startRecording = false;
  CameraController controller;

  final String _assetVideoRecorder = 'assets/images/ic_video_shutter.png';
  final String _assetStopVideoRecorder = 'assets/images/ic_stop_video.png';

  String videoPath;
  VoidCallback videoPlayerListener;

  @override
  void initState() {
    try {
      onCameraSelected(widget.cameras[0]);
    } catch (e) {
      print('Error Log: ' + e.toString());
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty) {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Ooops!\nNo Camera Found!',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (!controller.value.isInitialized) {
      return Container();
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Center(
              child: _cameraPreviewWidget(),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: controller != null && controller.value.isRecordingVideo
                    ? Colors.redAccent
                    : Colors.grey,
                width: 3.0,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 120.0,
            padding: EdgeInsets.all(20.0),
            color: Color.fromRGBO(00, 00, 00, 0.7),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      onTap: () {
                        !_startRecording
                            ? onVideoRecordButtonPressed()
                            : onStopButtonPressed();
                        setState(() {
                          _startRecording = !_startRecording;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        child: Image.asset(
                          !_startRecording
                              ? _assetVideoRecorder
                              : _assetStopVideoRecorder,
                          width: 72.0,
                          height: 72.0,
                        ),
                      ),
                    ),
                  ),
                ),
                !_startRecording ? _getToggleCamera() : new Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _cameraPreviewWidget() {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  Widget _getToggleCamera() {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          onTap: () {
            !_toggleCamera
                ? onCameraSelected(widget.cameras[1])
                : onCameraSelected(widget.cameras[0]);
            setState(() {
              _toggleCamera = !_toggleCamera;
            });
          },
          child: Container(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.switch_camera,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }

  void onCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) await controller.dispose();
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        log('${controller.value.errorDescription}', 'camera');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      log(e, 'camera');
    }

    if (mounted) setState(() {});
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void setCameraResult() {
    print("Recording Done!");
    Navigator.pop(context, videoPath);
  }

  void onVideoRecordButtonPressed() {
    print('onVideoRecordButtonPressed()');
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) log('Saving video to $filePath', 'video');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      log('Video recorded to: $videoPath', 'video');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      log('Error: select a camera first.', 'camera');
      return null;
    }

    final Directory extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.path}/VideoEditor/Videos';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';
    log(filePath, 'camera');
    if (controller.value.isRecordingVideo) {
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      log(e, 'Exception');
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }
    // Stop video recording bu controller in camera plugin
    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      log(e, 'Exception');
      return null;
    }
    setCameraResult();
  }

  void log(e, String type) {
    if (type == 'Exception')
      print('Exception log: => Code: ${e.code}\nMessage: ${e.message}');
    else if (type == 'camera')
      print('Camera log: => Code: $e');
    else if (type == 'video')
      print('Video log: => Code: $e');
    else
      print(e);
  }
}
