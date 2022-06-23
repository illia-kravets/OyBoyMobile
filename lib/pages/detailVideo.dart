import 'package:flutter/material.dart';
import 'package:oyboy/constants/export.dart';
import 'package:oyboy/data/export.dart';
import 'package:oyboy/widgets/detailVideo/detailVideoPage.dart';

class DetailVideoPage {
  static MaterialPage page(Video video) {
    return MaterialPage(
        name: OyBoyPages.detailVideoPath,
        key: const ValueKey(OyBoyPages.detailVideoPath),
        child: DetailVideo(video: video,)
      );
  }
}