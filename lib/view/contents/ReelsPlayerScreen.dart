import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class ReelsPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const ReelsPlayerScreen({required this.videoUrl, Key? key}) : super(key: key);

  @override
  State<ReelsPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<ReelsPlayerScreen> {
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;
  var is_loading = true;
  bool _shouldPlayAutomatically = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    DefaultCacheManager manager = DefaultCacheManager();
    File? videoFile = await manager.getSingleFile(widget.videoUrl);

    if (videoFile == null || !videoFile.existsSync()) {
      await _downloadAndCacheVideo();
      videoFile = await manager.getSingleFile(widget.videoUrl);
    }

    _controller = VideoPlayerController.file(videoFile!);

    _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
      setState(() {
        is_loading = false;
        _shouldPlayAutomatically = true;
      });

      _controller!.setLooping(false);

      // Use addPostFrameCallback to play the video after the first frame is rendered
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (_shouldPlayAutomatically) {
          _controller!.play();
        }
      });
    });
  }

  Future<void> _downloadAndCacheVideo() async {
    DefaultCacheManager manager = DefaultCacheManager();
    await manager.downloadFile(widget.videoUrl);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return is_loading
        ? const Padding(
      padding: EdgeInsets.all(100.0),
      child: CircularProgressIndicator(
        strokeWidth: 2.0, // Adjust the strokeWidth here
      ),
    )
        : FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (_controller != null) {
          return SizedBox(
            height: 160,
            width: 160,
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (_controller!.value.isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                  });
                },
                child: Container(
                  height: 160,
                  width: 160,
                  child: VideoPlayer(_controller!),
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


