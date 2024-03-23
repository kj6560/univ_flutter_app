import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../utility/cache_config.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String reelUrl;

  const VideoPlayerWidget({
    Key? key,
    required this.reelUrl,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {


  late VideoPlayerController _controller;
  bool _videoInitialized = false;
  bool _controllerDisposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeController();
  }

  @override
  void dispose() {
    _controller.pause(); // Pause the video when disposing the widget
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this); // Remove observer here
    super.dispose();
    print("reached here oh boys");
  }

  initializeController() async {
    var fileInfo = await kCacheManager.getFileFromCache(widget.reelUrl);
    if (fileInfo == null) {
      await kCacheManager.downloadFile(widget.reelUrl);
      fileInfo = await kCacheManager.getFileFromCache(widget.reelUrl);
    }
    if (mounted && !_controllerDisposed) {
      _controller = VideoPlayerController.file(fileInfo!.file)
        ..initialize().then((_) {
          if (mounted && !_controllerDisposed) {
            setState(() {
              _controller.setLooping(true); // Set video to loop
              _controller.play(); // Start playing the video
              _videoInitialized = true;
            });
          }
        });
      _controller.addListener(() {
        if (_controller.value.isPlaying && _controllerDisposed) {
          // Video has started playing and controller is not disposed
          _controller.pause();
          setState(() {});
        }
      });

    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_controllerDisposed) {
      print("1 hai");
      _controller.pause();
      return; // Return early if controller is disposed
    }
    if (state == AppLifecycleState.resumed) {
      // App is in the foreground
      print("2 hai");
      _controller.play(); // Resume playing when app is resumed
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      print("3 hai");
      // App is partially obscured or in the background
      _controller.pause(); // Pause the video when app is partially obscured or in the background
    } else if (state == AppLifecycleState.detached) {
      // App is terminated
      print("4 hai");
      _controller.pause();
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoInitialized || _controllerDisposed) {
      // Return a placeholder widget or empty container if controller is not initialized or disposed
      return Container();
    }
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_videoInitialized) {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause(); // Pause the video if it's playing
                  } else {
                    _controller.play(); // Play the video if it's paused
                  }
                });
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                VideoPlayer(_controller),
                if (!_controller.value.isPlaying)
                  Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.white,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
