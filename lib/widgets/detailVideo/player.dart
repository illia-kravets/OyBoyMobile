// ignore_for_file: void_checks, curly_braces_in_flow_control_structures

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oyboy/constants/export.dart';
import 'package:oyboy/data/managers/short.dart';
import 'package:oyboy/data/models/video.dart';
import 'package:oyboy/my_icons.dart';
import 'package:oyboy/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../default/loadingVideoBanner.dart';

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
    ThemeData theme = Theme.of(context);
    return _controller.value.isInitialized ||
            widget.video.video == null ||
            widget.video.video!.isEmpty
        ? Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.white),
                child: Column(
                  children: [
                    SizedBox(
                      height: widget.height,
                      width: widget.width,
                      child: Center(
                        child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller)),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                      child: VideoProgressIndicator(
                        _controller,
                        padding: const EdgeInsets.all(0),
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                            backgroundColor: Colors.grey,
                            bufferedColor:
                                const Color.fromARGB(255, 204, 204, 204),
                            playedColor: theme.primaryColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ValueListenableBuilder<VideoPlayerValue>(
                        valueListenable: _controller,
                        builder: (_, value, __) => Text(
                          "${printDuration(value.position)}/${printDuration(value.duration)}",
                          textAlign: TextAlign.start,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: widget.height,
                child: VideoPlaybackController(
                  controller: _controller,
                ),
              )
            ],
          )
        : SizedBox(
            height: widget.height,
            width: widget.width,
            child: Stack(
              children: [
                LoadingVideoBanner(
                    height: widget.height, url: widget.video.banner),
                const Loader(
                  width: 30,
                  height: 30,
                  strokeWidth: 4,
                )
              ],
            ),
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
  bool inTransition = false;

  bool aheadScrollVisible = false;
  bool backScrollVisible = false;

  Future _makeTransition(Duration duration) async {
    inTransition = true;
    await Future.delayed(duration);
    inTransition = false;
  }

  void _setScrollVisibility(bool visibility, VideoScrollType scrollType) {
    if (scrollType == VideoScrollType.ahead)
      aheadScrollVisible = visibility;
    else
      backScrollVisible = visibility;
  }

  void _toggleVisibility() async {
    setState(() => visible = !visible);
  }

  void _tapAction() async {
    if (!widget.controller.value.isPlaying || visible)
      return _toggleVisibility();
    _toggleVisibility();
    if (inTransition) return;
    await _makeTransition(const Duration(seconds: 2));
    if (visible) _toggleVisibility();
  }

  void _pauseAction() async {
    setState(() {});
    if (!visible) return _toggleVisibility();
    if (widget.controller.value.isPlaying) return widget.controller.pause();
    widget.controller.play();
    await _makeTransition(const Duration(seconds: 2));
    _toggleVisibility();
  }

  void _scrollAction(VideoScrollType scrollType) async {
    setState(() {
      visible = true;
      _setScrollVisibility(true, scrollType);
    });
    Duration videoPosition =
        await widget.controller.position ?? const Duration();
    switch (scrollType) {
      case VideoScrollType.back:
        widget.controller.seekTo(videoPosition - const Duration(seconds: 10));
        break;
      case VideoScrollType.ahead:
        widget.controller.seekTo(videoPosition + const Duration(seconds: 10));
        break;
    }
    await _makeTransition(const Duration(seconds: 1));
    setState(() {
      if (widget.controller.value.isPlaying) visible = false;
      _setScrollVisibility(false, scrollType);
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.controller;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: visible ? 1.0 : 0,
      child: GestureDetector(
        onTap: () => _tapAction(),
        child: Container(
          color: Colors.black.withOpacity(0.2),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _scrollWidget(VideoScrollType.back),
            IconButton(
              icon: _playerIcon(widget.controller.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow),
              onPressed: () => _pauseAction(),
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
          size: 38,
          color: Colors.white,
        ),
      );

  Widget _scrollWidget(VideoScrollType scrollType) {
    bool visible = scrollType == VideoScrollType.back
        ? backScrollVisible
        : aheadScrollVisible;

    return GestureDetector(
      onDoubleTap: () => _scrollAction(scrollType),
      child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _playerIcon(scrollType == VideoScrollType.back
                ? Icons.keyboard_double_arrow_left
                : Icons.keyboard_double_arrow_right),
          )),
    );
  }
}
