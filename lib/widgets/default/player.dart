// ignore_for_file: void_checks, curly_braces_in_flow_control_structures

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oyboy/constants/export.dart';
import 'package:oyboy/data/models/video.dart';
import 'package:video_player/video_player.dart';

import 'loadingVideoBanner.dart';

class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer({Key? key, required this.video, this.width, this.height})
      : super(key: key);

  final Video video;
  final double? width;
  final double? height;

  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _controller;
  bool paused = true;
  bool showFilter = false;

  @override
  void initState() {
    super.initState();
    widget.video;
    _controller = VideoPlayerController.network(widget.video.video ?? "")
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: _controller.value.isInitialized
          ? Stack(
              children: [
                Center(
                  child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller)),
                ),
                VideoPlaybackController(
                  controller: _controller,
                )
              ],
            )
          : LoadingVideoBanner(height: widget.height, url: widget.video.banner),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class VideoPlaybackController extends StatefulWidget {
  const VideoPlaybackController({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  State<VideoPlaybackController> createState() =>
      _VideoPlaybackControllerState();
}

class _VideoPlaybackControllerState extends State<VideoPlaybackController> {
  bool visible = true;

  bool aheadScrollVisible = false;
  bool backScrollVisible = true;

  void toggleVisibility() async {
    setState(() => visible = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() => visible = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: visible ? 1.0 : 0,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          color: Colors.black.withOpacity(0.2),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _scrollWidget(VideoScrollType.back),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: IconButton(
                icon: _playerIcon(Icons.pause),
                onPressed: () {},
              ),
            ),
            _scrollWidget(VideoScrollType.ahead)
          ]),
        ),
      ),
    );
  }

  Widget _playerIcon(IconData icon) => Center(
        child: Icon(
          icon,
          size: 32,
        ),
      );

  Widget _scrollWidget(VideoScrollType scrollType) {
    bool visible = scrollType == VideoScrollType.back
        ? backScrollVisible
        : aheadScrollVisible;

    return GestureDetector(
      onDoubleTap: () => _scrollVideo(scrollType),
      child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                _playerIcon(Icons.keyboard_double_arrow_right),
                const Text("s.")
              ],
            ),
          )),
    );
  }

  void _setScrollVisibility(bool visibility, VideoScrollType scrollType) {
    if (scrollType == VideoScrollType.ahead)
      aheadScrollVisible = visibility;
    else
      backScrollVisible = visibility;
  }

  void _scrollVideo(VideoScrollType scrollType) async {
    setState(() {
      visible = true;
      _setScrollVisibility(true, scrollType);
    });
    Duration videoPosition =
        await widget.controller.position ?? const Duration();
    switch (scrollType) {
      case VideoScrollType.back:
        widget.controller.seekTo(videoPosition + const Duration(seconds: 10));
        break;
      case VideoScrollType.ahead:
        widget.controller.seekTo(videoPosition - const Duration(seconds: 10));
        break;
    }
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      visible = false;
      _setScrollVisibility(false, scrollType);
    });
  }
}
