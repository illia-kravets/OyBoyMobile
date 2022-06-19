import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LoadingVideoBanner extends StatelessWidget {
  const LoadingVideoBanner({Key? key, this.url, this.width, this.height, this.color})
      : super(key: key);
  final String? url;
  final double? width;
  final double? height;
  final Color? color;

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
            color: color,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => placeholder,
            errorWidget: (context, url, error) => placeholder,
          )
        : placeholder;
  }
}
