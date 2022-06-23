import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/constants/defaults.dart';
import 'package:oyboy/data/export.dart';
import 'package:oyboy/data/managers/detailVideo.dart';
import 'package:oyboy/my_icons.dart';
import 'package:oyboy/widgets/default/loadingVideoBanner.dart';
import 'package:provider/provider.dart';

class MoreChannelVideos extends StatefulWidget {
  const MoreChannelVideos({Key? key}) : super(key: key);

  @override
  State<MoreChannelVideos> createState() => _MoreChannelVideosState();
}

class _MoreChannelVideosState extends State<MoreChannelVideos> {
  late ScrollController _controller = ScrollController();
  late double cardWidth;
  late List cards;
  int index = 0;
  
  @override
  void initState() {
    _controller.addListener(() => setState(() {}));
    super.initState();
  }

  double get position => _controller.positions.isNotEmpty ? _controller.position.pixels : 0;


  bool get hasNext => cards.length > 1 && position < (cards.length -1) * cardWidth;

  bool get hasPrevious => 
    cards.length > 1 && cardWidth * (position / cardWidth).ceil() - 1 > 0;

  void next() {
    _controller.animateTo(cardWidth * ((position / cardWidth).floor() + 1),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn);
  }

  void previous() {
    _controller.animateTo(cardWidth * ((position / cardWidth).ceil() - 1) ,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    cardWidth = MediaQuery.of(context).size.width - 40;
    cards = context.select((DetailVideoManager m) => m.authorCards);

    return cards.isNotEmpty ? Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "channelVideos".tr(),
            style: theme.textTheme.bodyText1,
          ),
          const SizedBox(
            height: 10,
          ),
          Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.height,
                  height: 200,
                  child: ListView.builder(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    itemCount: cards.length,
                    itemBuilder: (ctx, i) => MoreVideoCard(video: cards[i], width: cardWidth,),
                  ),
                ),
                if(hasNext)
                Positioned(
                  right: 6,
                  top: 75,
                  child: GestureDetector(
                    onTap: next,
                    child: Container(
                      width: 35,
                      height: 35,
                      child: const Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                if(hasPrevious)
                Positioned(
                  left: 6,
                  top: 75,
                  child: GestureDetector(
                    onTap: previous,
                    child: Container(
                      width: 35,
                      height: 35,
                      child: const Icon(
                        Icons.keyboard_arrow_left_rounded,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
    )
    : Container();
  }
}

class MoreVideoCard extends StatelessWidget {
  const MoreVideoCard({Key? key, required this.video, this.width}) : super(key: key);

  final Video video;
  final double? width;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.read<VideoManager>().selectCard(video),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: Colors.grey[400],
            ),
            child: Column(
              children: [
                LoadingVideoBanner(
                  color: Colors.grey,
                  url: video.banner,
                  height: 175,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      video.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyText2,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
