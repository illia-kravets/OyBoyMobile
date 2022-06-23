import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:oyboy/data/export.dart';
import 'package:provider/provider.dart';

import '/data/managers/comment.dart';
import 'commentSkeleton.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({ Key? key, required this.video }) : super(key: key);
  final Video video;

  @override
  Widget build(BuildContext context) {
    CommentManager manager = CommentManager(video: video);
    return ChangeNotifierProvider<CommentManager>(
      create: (context) => manager,
      child: const CommentPageSkeleton()
    );
  }
}