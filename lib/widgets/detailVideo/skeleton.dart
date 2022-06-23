import 'package:flutter/material.dart';
import 'package:oyboy/data/managers/comment.dart';
import 'package:oyboy/data/managers/detailVideo.dart';
import 'package:oyboy/utils/utils.dart';
import 'package:oyboy/widgets/default/default_page.dart';
import 'package:oyboy/widgets/detailVideo/player.dart';
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
    bool loading = context.select((DetailVideoManager m) => m.isLoading);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: DetailVideoAppBar(video: videoManager.video),
      ),
      body: loading
          ? const Loader(
              width: 30,
              height: 30,
            )
          : Stack(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                color: Colors.grey[200],
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppVideoPlayer(
                        video: videoManager.video,
                        height: 180,
                      ),
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
                        height: 24,
                      ),
                      const MoreChannelVideos(),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
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
