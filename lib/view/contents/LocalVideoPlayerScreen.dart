import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const LocalVideoPlayerScreen({required this.videoUrl});

  @override
  State<LocalVideoPlayerScreen> createState() => _LocalVideoPlayerScreenState();
}

class _LocalVideoPlayerScreenState extends State<LocalVideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  var is_loading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    DefaultCacheManager manager = DefaultCacheManager();
    File? videoFile = File(widget.videoUrl);

    if (videoFile != null) {
      _controller = VideoPlayerController.file(videoFile);
    }

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        is_loading = false;
      });
      _controller.play();
      _controller.setLooping(false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return is_loading
        ? Padding(
            padding: const EdgeInsets.all(68.0),
            child: CircularProgressIndicator(
              strokeWidth: 2.0, // Adjust the strokeWidth here
            ),
          )
        : FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  height: 160,
                  width: 160,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                      },
                      child: Container(
                        height: 160,
                        width: 160,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0, // Adjust the strokeWidth here
                  ),
                );
              }
            },
          );
  }
}
