import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import "package:cached_network_image/cached_network_image.dart";
import 'package:oyboy/data/export.dart';
import 'package:oyboy/data/managers/video.dart';
import 'package:provider/provider.dart';

import '../default/loadingVideoBanner.dart';
import '../detailVideo/detailVideoPage.dart';
import "/data/models/video.dart";

class VideoCard extends StatelessWidget {
  const VideoCard({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.read<VideoManager>().selectCard(video),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              theme.primaryColor,
              Colors.white,
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(10))),
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: Column(children: [
            LoadingVideoBanner(url: video.banner, height: 220),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () => context.read<ProfileManager>().selectId(video.channelId.toString()),
                        child: NetworkCircularAvatar(
                          url: video.channel!.avatar ?? "",
                          radius: 25,
                        )),
                    const SizedBox(width: 4),
                    Container(
                      height: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 275,
                              child: Text(
                                video.name ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: theme.textTheme.headline5,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "${video.viewCount.toString()} ${'views'.tr()}",
                                  style: theme.textTheme.bodyText2,
                                ),
                                const SizedBox(
                                  width: 100,
                                ),
                                Text(
                                  video.createdAt ?? "",
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
      ),
    );
  }
}

class NetworkCircularAvatar extends StatelessWidget {
  const NetworkCircularAvatar(
      {Key? key, required this.url, this.radius, this.backgroundColor, this.local=false})
      : super(key: key);

  final String url;
  final double? radius;
  final Color? backgroundColor;
  final bool local;

  @override
  Widget build(BuildContext context) {
    return url.isNotEmpty
        ? local ? localImage : networkImage
        : placeholder;
  }

  Widget get localImage => CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: FileImage(File(url)),
    );

  Widget get networkImage => CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => placeholder,
    );

  Widget get placeholder => CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        backgroundImage:
            const AssetImage("assets/images/avatar_placeholder.png"),
      );
}

class LoadingVideoCard extends StatelessWidget {
  const LoadingVideoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 107, 107, 107),
            Colors.white,
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(10))),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Column(children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 15,
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.grey)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.grey))
                              ],
                            )
                          ]),
                    ),
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

class ShortVideoCard extends StatelessWidget {
  const ShortVideoCard({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        ShortManager manager = context.read<ShortManager>();
        manager.setActiveShort(video);
        manager.selectCard(video);
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        color: Colors.grey[50],
        child: Stack(
          children: [
            LoadingVideoBanner(
              url: video.banner,
              height: 400,
              width: 400,
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.name ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyText2!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: theme.primaryColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(video.likeCount.toString(),
                                style: theme.textTheme.bodyText2!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis)
                          ],
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye_outlined,
                              color: theme.primaryColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(video.viewCount.toString(),
                                style: theme.textTheme.bodyText2!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis)
                          ],
                        )
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class LoadingShortVideoCard extends StatelessWidget {
  const LoadingShortVideoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.grey[50],
      child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[350],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(height: 20, color: Colors.grey)),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 1, child: Container(height: 20, color: Colors.grey))
                ],
              )
            ],
          )),
    );
  }
}
