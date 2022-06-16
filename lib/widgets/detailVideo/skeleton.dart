import 'package:flutter/material.dart';
import 'package:oyboy/data/managers/comment.dart';
import 'package:oyboy/data/managers/detailVideo.dart';
import 'package:oyboy/widgets/default/default_page.dart';
import 'package:oyboy/widgets/detailVideo/videoPlayer.dart';
import 'package:provider/provider.dart';

import '../comments/commentCount.dart';
import '../comments/commentPage.dart';
import '../comments/commentSkeleton.dart';
import '../short/detailAppbar.dart';
import 'iconsBar.dart';
import 'moreVideos.dart';
import 'titleDropdown.dart';

class DetailVideoSkeleton extends StatefulWidget {
  const DetailVideoSkeleton({Key? key}) : super(key: key);

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
      body: Stack(children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            color: Colors.grey[200],
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const DetailVideoPlayer(),
                  const SizedBox(
                    height: 14,
                  ),
                  TitleDropdown(
                      video: context.read<DetailVideoManager>().video),
                  const SizedBox(
                    height: 14,
                  ),
                  const IconsBar(),
                  const SizedBox(
                    height: 14,
                  ),
                  // const MoreChannelVideos()
                ],
              ),
            )),
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
                builder: (context) => ChangeNotifierProvider.value(
                      value: commentManager,
                      child: CommentPageSkeleton(initialize: false),
                    )),
          ),
        )
      ]),
    );
  }
}
