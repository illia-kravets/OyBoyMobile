import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:oyboy/data/export.dart';
import 'package:provider/provider.dart';

import '/data/managers/comment.dart';
import 'skeleton.dart';

class DetailVideo extends StatelessWidget {
  const DetailVideo({ Key? key, required this.video }) : super(key: key);
  final Video video;

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider<DetailVideoManager>(
          create: (context) => DetailVideoManager(video: video),
        ),
        ChangeNotifierProvider<CommentManager>(
          create: (context) => CommentManager(videoId: video.id),
        ),
      ], 
      child: const DetailVideoSkeleton());
  }
}