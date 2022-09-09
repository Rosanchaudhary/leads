import "package:flutter/material.dart";
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.initialize();
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _videoPlayerController.pause();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: _videoPlayerController.value.isInitialized
            ? Stack(
                children: [
                  VideoPlayer(_videoPlayerController),
                  if (!_videoPlayerController.value.isPlaying) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _videoPlayerController.play();
                        });
                      },
                      child: const Center(
                          child: Icon(
                        Icons.play_circle_outline,
                        size: 52,
                        color: Colors.white,
                      )),
                    )
                  ]
                ],
              )
            : Container(),
      ),
    );
  }
}
