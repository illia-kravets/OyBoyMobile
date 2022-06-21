import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '/data/managers/comment.dart';
import 'commentSkeleton.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({ Key? key, required this.videoId }) : super(key: key);
  final String videoId;

  @override
  Widget build(BuildContext context) {
    CommentManager manager = CommentManager(videoId: videoId);
    return ChangeNotifierProvider<CommentManager>(
      create: (context) => manager,
      child: const CommentPageSkeleton()
    );
  }
}