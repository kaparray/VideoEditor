import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:simple_share/simple_share.dart';

class VideoFullScreen extends StatefulWidget {
  final File file;
  final int index;

  VideoFullScreen(this.file, this.index);

  @override
  State<VideoFullScreen> createState() => VideoFullScreenState();
}

class VideoFullScreenState extends State<VideoFullScreen> {
  VideoPlayerController _controller;
  FadeAnimation imageFadeAnim =
      FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {
          _controller..setVolume(1);
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.setVolume(0);
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  Future<String> getFilePath() async {
    String filePath = widget.file.path.toString();
    try {
      if (filePath == '') {
        return "";
      }
      return filePath;
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.file.uri.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text('Editing video'),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                final path = await getFilePath();
                if (path != null && path.isNotEmpty) {
                  final uri = Uri.file(path);
                  SimpleShare.share(
                      uri: uri.toString(),
                      title: "Share my file",
                      msg: "My message");
                }
              },
              icon: Icon(Icons.share),
            )
          ],
        ),
        body: SafeArea(
          child: Hero(
            tag: 'video_${widget.index}',
            child: Stack(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    child: _controller.value.initialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : Container(),
                    onTap: () {
                      if (!_controller.value.initialized) {
                        return;
                      }
                      if (_controller.value.isPlaying) {
                        imageFadeAnim = FadeAnimation(
                            child: const Icon(Icons.pause, size: 100.0));
                        _controller.pause();
                      } else {
                        imageFadeAnim = FadeAnimation(
                            child: const Icon(Icons.play_arrow, size: 100.0));
                        _controller.play();
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                  ),
                ),
                Center(child: imageFadeAnim),
                Center(
                    child: _controller.value.isBuffering
                        ? const CircularProgressIndicator()
                        : null),
              ],
            ),
          ),
        ));
  }
}

class FadeAnimation extends StatefulWidget {
  FadeAnimation(
      {this.child, this.duration = const Duration(milliseconds: 500)});

  final Widget child;
  final Duration duration;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animationController.isAnimating
        ? Opacity(
            opacity: 1.0 - animationController.value,
            child: widget.child,
          )
        : Container();
  }
}
