import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({Key? key, this.url, this.height, this.width, this.local=false})
      : super(key: key);

  final String? url;
  final double? height;
  final double? width;
  final bool local;

  @override
  Widget build(BuildContext context) {
    var placeholder = Image.asset("assets/images/avatar_placeholder.png");
    return ClipRRect(
      borderRadius: BorderRadius.circular(75),
      child: SizedBox(
        width: width,
        child: url != null && url!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: url!,
                placeholder: (context, url) => placeholder,
                errorWidget: (context, url, error) => placeholder,
              )
            : placeholder,
      ),
    );
  }
}
