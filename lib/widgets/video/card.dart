import 'package:flutter/material.dart';
import "package:cached_network_image/cached_network_image.dart";

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
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(10))),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Column(children: [
          getVideoBanner(video.banner),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {},
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
    );
  }

  Widget getVideoBanner(String? url) {
    var placeholder = Image.asset("assets/images/video_placeholder.png");
    return url != null && url.isNotEmpty 
      ? CachedNetworkImage(
        height: 220,
        imageUrl: url,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
      )
      : placeholder;
  }
}

class NetworkCircularAvatar extends StatelessWidget {
  const NetworkCircularAvatar(
      {Key? key, required this.url, this.radius, this.backgroundColor})
      : super(key: key);

  final String url;
  final double? radius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return url.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: radius,
              backgroundColor: backgroundColor,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => placeholder,
            errorWidget: (context, url, error) => placeholder,
          )
        : placeholder;
  }

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
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.grey[50],
      child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage(video.banner ?? ""),
              fit: BoxFit.fitHeight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video.name,
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
