import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/constants/defaults.dart';
import 'package:oyboy/data/export.dart';
import 'package:oyboy/data/managers/detailVideo.dart';
import 'package:oyboy/my_icons.dart';
import 'package:provider/provider.dart';

class TitleDropdown extends StatefulWidget {
  const TitleDropdown({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  State<TitleDropdown> createState() => _TitleDropdownState();
}

class _TitleDropdownState extends State<TitleDropdown> {
  bool expandedBar = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 80,
            child: Text(widget.video.name ?? "",
                style: theme.textTheme.headline4, softWrap: true),
          ),
          const SizedBox(
            width: 15,
          ),
          if (widget.video != null && widget.video.description!.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => expandedBar = !expandedBar),
              child: Container(
                width: 25,
                height: 25,
                child: Icon(
                  expandedBar
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  shape: BoxShape.circle,
                ),
              ),
            )
        ],
      ),
      AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: expandedBar
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(widget.video.description ?? "",
                      textAlign: TextAlign.start,
                      style: theme.textTheme.bodyText1,
                      softWrap: true),
                )
              : Container())
    ]);
  }
}
