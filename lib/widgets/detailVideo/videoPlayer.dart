import 'package:flutter/material.dart';
import 'package:oyboy/data/managers/comment.dart';
import 'package:oyboy/data/managers/detailVideo.dart';
import 'package:oyboy/widgets/default/default_page.dart';
import 'package:provider/provider.dart';

import '../comments/commentCount.dart';
import '../comments/commentPage.dart';
import '../comments/commentSkeleton.dart';
import '../short/detailAppbar.dart';
import 'iconsBar.dart';

class DetailVideoPlayer extends StatelessWidget {
  const DetailVideoPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/video_placeholder.png"),
            fit: BoxFit.fill),
      ),
    );
  }
}
