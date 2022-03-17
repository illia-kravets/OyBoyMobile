import "package:flutter/material.dart";

import "/constants/export.dart";
import '/data/export.dart';
import "/widgets/export.dart";

class VideoPage<T extends HomeVideoGeneric> extends StatelessWidget {
  const VideoPage({
    Key? key,
  }) : super(key: key);

  static MaterialPage videoPage() {
    return const MaterialPage(
        name: OyBoyPages.videoPath,
        key: ValueKey(OyBoyPages.videoPath),
        child: VideoPage<VideoManager>());
  }

  static MaterialPage streamPage() {
    return const MaterialPage(
        name: OyBoyPages.streamPath,
        key: ValueKey(OyBoyPages.streamPath),
        child: VideoPage<StreamManager>());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultVideoPage<T>();
  }
}
