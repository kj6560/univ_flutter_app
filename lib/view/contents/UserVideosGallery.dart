import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:univ_app/controllers/uservideoscontroller.dart';
import 'package:univ_app/services/remote_services.dart';
import 'package:univ_app/utility/values.dart';
import 'package:video_player/video_player.dart';

class UserVideosGallery extends StatefulWidget {
  @override
  State<UserVideosGallery> createState() => _UserVideosGalleryState();
}

class _UserVideosGalleryState extends State<UserVideosGallery> {
  UserVideosController userVideosController = Get.put(UserVideosController());

  @override
  void initState() {
    super.initState();
    RemoteServices.showSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetX<UserVideosController>(
      builder: (logic) {
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust the number of columns as needed
          ),
          delegate: SliverChildBuilderDelegate(
            addRepaintBoundaries: true,
            (BuildContext context, int index) {
              final videoUrl =
                  Values.userGallery + logic.userFiles[index].filePath;
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  color: Colors.grey,
                  child: VideoPlayerScreen(videoUrl: videoUrl),
                ),
              );
            },
            childCount: logic.userFiles.length,
          ),
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
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
