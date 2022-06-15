import 'package:flutter/material.dart';
import 'package:oyboy/data/managers/comment.dart';
import 'package:oyboy/data/managers/detailVideo.dart';
import 'package:oyboy/widgets/default/default_page.dart';
import 'package:provider/provider.dart';

import '../comments/commentCount.dart';
import '../comments/commentPage.dart';
import '../comments/commentSkeleton.dart';
import '../short/detailAppbar.dart';

class DetailVideoSkeleton extends StatefulWidget {
  const DetailVideoSkeleton({ Key? key }) : super(key: key);

  @override
  State<DetailVideoSkeleton> createState() => _DetailVideoSkeletonState();
}

class _DetailVideoSkeletonState extends State<DetailVideoSkeleton> {
  late CommentManager commentManager;
  late DetailVideoManager videoManager;

  @override
  void initState() {
    commentManager = context.read<CommentManager>()..initialize();
    videoManager = context.read<DetailVideoManager>()..initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0), 
          child: DetailVideoAppBar(video: videoManager.video),
      ),
      // extendBody: true,
      body: Stack(
            children: [
              Container(
                color: Colors.grey[200],
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const SingleChildScrollView(
                  child: Text("test"),
                )
              ),
              Positioned(
                bottom: 0,
                child: CommentCount(
                  opened: false,
                  onTap: () => showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    context: context,
                    builder: (context) =>
                        ChangeNotifierProvider.value(value: commentManager, child: CommentPageSkeleton(initialize: false),) ),
                ),
              )
            ]
          ),
    );
  }
}