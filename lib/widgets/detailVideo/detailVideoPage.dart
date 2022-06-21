import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:oyboy/data/export.dart';
import 'package:provider/provider.dart';

import '/data/managers/comment.dart';
import 'skeleton.dart';

class DetailVideo extends StatelessWidget {
  const DetailVideo({ Key? key, required this.videoId }) : super(key: key);
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider<DetailVideoManager>(
          create: (context) => DetailVideoManager(videoId: videoId),
        ),
        ChangeNotifierProvider<CommentManager>(
          create: (context) => CommentManager(videoId: videoId),
        ),
      ], 
      child: const DetailVideoSkeleton());
  }
}