import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/data/export.dart';
import 'package:oyboy/my_icons.dart';
import 'package:oyboy/widgets/comments/commentPage.dart';
import 'package:oyboy/widgets/default/default_page.dart';
import 'package:oyboy/widgets/short/player.dart';
import 'package:provider/provider.dart';

class ShortDisplayPage extends StatefulWidget {
  const ShortDisplayPage({Key? key, required this.short}) : super(key: key);
  final Video short;
  @override
  State<ShortDisplayPage> createState() => _ShortDisplayPageState();
}

class _ShortDisplayPageState extends State<ShortDisplayPage> {
  late bool expandedBar;

  @override
  void initState() {
    expandedBar = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ShortManager manager = context.read<ShortManager>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[50],
      body: Stack(
          children: [
            ShortPlayer(
                height: MediaQuery.of(context).size.height - 105,
                video: widget.short),
            Positioned(
              bottom: 0,
              child: AnimatedContainer(
                padding: const EdgeInsets.all(16),
                curve: Curves.linear,
                duration: const Duration(
                  milliseconds: 200,
                ),
                height: expandedBar ? 225 : 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Stack(
                  children: [
                    Container(
                      // margin: const EdgeInsets.only(bottom: 40),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Tooltip(
                                waitDuration: const Duration(seconds: 3),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding: const EdgeInsets.all(15),
                                triggerMode: TooltipTriggerMode.tap,
                                message: widget.short.name,
                                child: Text(
                                  widget.short.name ?? "",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            if (widget.short.description != null &&
                                widget.short.description!.isNotEmpty)
                              GestureDetector(
                                onTap: () =>
                                    setState(() => expandedBar = !expandedBar),
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  child: Icon(
                                    expandedBar
                                        ? Icons.keyboard_arrow_down_rounded
                                        : Icons.keyboard_arrow_up_rounded,
                                    color: Colors.white,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                          ],
                        ),
                        AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: expandedBar
                                ? Tooltip(
                                    waitDuration: const Duration(seconds: 3),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: const EdgeInsets.all(15),
                                    triggerMode: TooltipTriggerMode.tap,
                                    message: widget.short.description,
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        widget.short.description ?? "",
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 4,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                : Container())
                      ]),
                    ),
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  CustomIcon.video_view,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${widget.short.viewCount.toString()} ${'views'.tr()}",
                                  style: GoogleFonts.poppins(color: Colors.white),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  CustomIcon.video_heart,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${manager.activeShort!.likeCount.toString()} ${'likes'.tr()}",
                                  style: GoogleFonts.poppins(color: Colors.white),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 35,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                right: 0,
                bottom: expandedBar ? 290 : 230,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Column(
                    children: [
                      sideBarButton(CustomIcon.short_heart,
                          () => manager.like(),
                          color: manager.activeShort!.liked ? theme.primaryColor : null),
                      const SizedBox(
                        height: 20,
                      ),
                      sideBarButton(
                        CustomIcon.comments,
                        () => showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            context: context,
                            builder: (context) =>
                                CommentPage(video: widget.short)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      sideBarButton(CustomIcon.reply, () async {
                        await FlutterShare.share(
                            title: widget.short.name ?? "",
                            text: widget.short.name,
                            linkUrl: widget.short.video,
                            chooserTitle: widget.short.name);
                      }),
                    ],
                  ),
                ))
          ],
        ),
    );
  }

  Widget sideBarButton(IconData icon, Function() onTap, {Color? color}) {
    return Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor.withOpacity(0.4),
              Colors.yellow.withOpacity(0.4)
            ]),
            shape: BoxShape.circle),
        child: GestureDetector(
            onTap: onTap,
            child: Icon(
              icon,
              size: 33,
              color: color ?? Colors.grey[300],
            )));
  }
}
