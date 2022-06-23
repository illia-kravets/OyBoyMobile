import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oyboy/data/export.dart';
import 'reportDialog.dart';
import 'shortProfile.dart';

class DetailVideoAppBar extends StatelessWidget {
  const DetailVideoAppBar({ Key? key, this.video }) : super(key: key);
  final Video? video;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
          color: theme.primaryColor),
      backgroundColor: Colors.transparent.withOpacity(0.1),
      title: ShortProfile(channelId: video?.channelId),
      titleSpacing: 0,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
      actions: [
        if(video != null)
        IconButton(
          onPressed: () {
            showDialog(
              context: context, 
              builder: (context) => ReportDialog(video: video!)
            );
          }, 
          icon: Icon(Icons.error, color: theme.primaryColor, size: 28,)
        )
      ],
    );
  }
}
