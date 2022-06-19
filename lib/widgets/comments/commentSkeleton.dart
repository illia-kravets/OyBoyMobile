import 'package:flutter/material.dart';
import 'package:oyboy/data/managers/comment.dart';
import 'package:oyboy/utils/utils.dart';
import 'package:provider/provider.dart';

import 'commentCount.dart';
import 'commentInput.dart';
import 'commentList.dart';

class CommentPageSkeleton extends StatefulWidget {
  const CommentPageSkeleton({ Key? key, this.initialize=true }) : super(key: key);

  final bool initialize;

  @override
  State<CommentPageSkeleton> createState() => _CommentPageSkeletonState();
}

class _CommentPageSkeletonState extends State<CommentPageSkeleton> {

  @override
  void initState() {
    if (widget.initialize) context.read<CommentManager>().initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool loading = context.select((CommentManager m) => m.isLoading);
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 0, bottom: 10),
      constraints: const BoxConstraints(maxHeight: 600),
      child: loading 
        ? const Loader(width: 30, height: 30,)
        : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommentCount(onTap: () => Navigator.of(context).pop(),),
            const SizedBox(height: 6,),
            const CommentInput(),
            const SizedBox(height: 12,),
            const CommentList()
          ],
        ),
    );
  }
}