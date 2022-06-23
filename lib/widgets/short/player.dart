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

class ShortPlayer extends StatefulWidget {
  const ShortPlayer({Key? key, required this.video, this.width, this.height})
      : super(key: key);

  final Video video;
  final double? width;
  final double? height;

  @override
  _ShortPlayerState createState() => _ShortPlayerState();
}

class _ShortPlayerState extends State<ShortPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    widget.video;
    _controller = VideoPlayerController.network(widget.video.video ?? "")
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: widget.height,
      width: widget.width,
      child: _controller.value.isInitialized ||
              widget.video.video == null ||
              widget.video.video!.isEmpty
          ? Stack(
              children: [
                Center(
                  child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller)),
                ),
                SizedBox(
                  height: widget.height! - 30,
                  child: ShortPlaybackController(
                    controller: _controller,
                  ),
                ),
                SizedBox(
                  height: 6,
                  child: VideoProgressIndicator(
                    _controller,
                    padding: const EdgeInsets.all(0),
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                        backgroundColor: Colors.grey,
                        bufferedColor: const Color.fromARGB(255, 204, 204, 204),
                        playedColor: theme.primaryColor),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                LoadingVideoBanner(
                    isShort: true,
                    height: widget.height,
                    url: widget.video.banner),
                const Center(
                  child: Loader(
                    width: 30,
                    height: 30,
                    strokeWidth: 4,
                  ),
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

class ShortPlaybackController extends StatefulWidget {
  const ShortPlaybackController({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  State<ShortPlaybackController> createState() =>
      _ShortPlaybackControllerState();
}

class _ShortPlaybackControllerState extends State<ShortPlaybackController> {
  bool showLike = false;
  bool showPause = false;

  late ShortManager manager;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    manager = context.read<ShortManager>();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.controller.value.isPlaying
            ? widget.controller.pause()
            : widget.controller.play();
        setState(() => showPause = true);
        _toggle(ShortTapType.pause);
      },
      onDoubleTap: () {
        manager.like();
        setState(() => showLike = true);
        _toggle(ShortTapType.like);
      },
      child: Center(
        child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: showLike || showPause ? 1 : 0,
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _getIcon())),
      ),
    );
  }

  void _toggle(ShortTapType type) async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      if (type == ShortTapType.like)
        showLike = !showLike;
      else
        showPause = !showPause;
    });
  }

  Widget? _getIcon() {
    if (showLike)
      return Icon(
        CustomIcon.short_heart,
        color: manager.activeShort!.liked ? theme.primaryColor : Colors.grey,
        size: 60,
      );
    if (showPause)
      return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.black.withOpacity(0.2)),
        child: Icon(
          widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.grey[100],
          size: 60,
        ),
      );
  }
}
