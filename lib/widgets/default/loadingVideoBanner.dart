import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LoadingVideoBanner extends StatelessWidget {
  const LoadingVideoBanner({Key? key, this.url, this.width, this.height})
      : super(key: key);
  final String? url;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    var placeholder = Image.asset(
      "assets/images/video_placeholder.png",
      width: width,
      height: height,
    );
    return url != null && url!.isNotEmpty
        ? CachedNetworkImage(
            height: height,
            width: width,
            imageUrl: url!,
            placeholder: (context, url) => placeholder,
            errorWidget: (context, url, error) => placeholder,
          )
        : placeholder;
  }
}