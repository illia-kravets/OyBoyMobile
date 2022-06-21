import 'package:flutter/material.dart';
import 'package:oyboy/constants/export.dart';
import 'package:oyboy/widgets/detailVideo/detailVideoPage.dart';

class DetailVideoPage {
  static MaterialPage page(String videoId) {
    return MaterialPage(
        name: OyBoyPages.detailVideoPath,
        key: const ValueKey(OyBoyPages.detailVideoPath),
        child: DetailVideo(videoId: videoId,)
      );
  }
}