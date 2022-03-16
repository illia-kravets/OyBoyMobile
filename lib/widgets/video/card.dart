import 'package:flutter/material.dart';

import "/data/models/video.dart";

class VideoCard extends StatelessWidget {
  const VideoCard({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            theme.primaryColor,
            Colors.white,
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
          borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Column(children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                    image: AssetImage(video.banner), fit: BoxFit.fill)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 25.0,
                      // backgroundColor: Colors.grey,
                      backgroundImage: AssetImage(video.channel!.avatar ?? ""),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    height: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            video.name,
                            style: theme.textTheme.headline5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${video.viewCount.toString()} views",
                                style: theme.textTheme.bodyText2,
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              Text(
                                video.createdAt,
                                style: theme.textTheme.bodyText2,
                              )
                            ],
                          )
                        ]),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
