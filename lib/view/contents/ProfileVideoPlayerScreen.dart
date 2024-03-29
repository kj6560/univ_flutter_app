import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class ProfileVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const ProfileVideoPlayerScreen({required this.videoUrl});

  @override
  State<ProfileVideoPlayerScreen> createState() =>
      _ProfileVideoPlayerScreenState();
}

class _ProfileVideoPlayerScreenState extends State<ProfileVideoPlayerScreen> {
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
    File? videoFile = await manager.getSingleFile(widget.videoUrl);

    if (videoFile != null && videoFile.existsSync()) {
      _controller = VideoPlayerController.file(videoFile);
    } else {
      await _downloadAndCacheVideo();
      videoFile = await manager.getSingleFile(widget.videoUrl);
      _controller = VideoPlayerController.file(videoFile!);
    }

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        is_loading = false;
      });
      _controller.setLooping(false);
    });
  }

  Future<void> _downloadAndCacheVideo() async {
    DefaultCacheManager manager = DefaultCacheManager();
    await manager.downloadFile(widget.videoUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return is_loading
        ? const Padding(
            padding: EdgeInsets.all(138.0),
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
                    child: Container(
                      height: 160,
                      width: 160,
                      child: VideoPlayer(_controller),
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
