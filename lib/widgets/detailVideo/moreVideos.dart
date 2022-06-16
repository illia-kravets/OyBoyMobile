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
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Video> cards = context.read<DetailVideoManager>().authorCards;
    return Container(
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
              Positioned(
                child: GestureDetector(
                  onTap: () => {},
                  child: Container(
                    width: 25,
                    height: 25,
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
              ),
              ListView.builder(
                controller: _controller,
                scrollDirection: Axis.vertical,
                itemCount: cards.length,
                itemBuilder: (ctx, i) => MoreVideoCard(video: cards[i]),
              ),
              Positioned(
                child: GestureDetector(
                  onTap: () => {},
                  child: Container(
                    width: 25,
                    height: 25,
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
          )
        ],
      ),
    );
  }
}

class MoreVideoCard extends StatelessWidget {
  const MoreVideoCard({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          LoadingVideoBanner(
            url: video.video,
            height: 170,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: Colors.grey[400]),
            child: Text(
              video.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyText2,
            ),
          )
        ],
      ),
    );
  }
}
