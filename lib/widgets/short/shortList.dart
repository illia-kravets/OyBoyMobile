import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/data/managers/short.dart';
import 'package:oyboy/data/repositories/profile.dart';
import 'package:oyboy/my_icons.dart';
import 'package:oyboy/widgets/default/default_page.dart';
import 'package:provider/provider.dart';

import '../../data/models/video.dart';
import '../video/card.dart';
import 'commentList.dart';
import 'loadingShortPage.dart';
import 'shortProfile.dart';

class ShortList extends StatefulWidget {
  const ShortList({Key? key}) : super(key: key);

  @override
  State<ShortList> createState() => _ShortListState();
}

class _ShortListState extends State<ShortList> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: DefaultPage(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
                color: theme.primaryColor),
            backgroundColor: Colors.transparent.withOpacity(0.1),
            title: const ShortProfile(),
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
          ),
        ),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: const ShortPageList(),
      ),
    );
  }
}

class ShortPageList extends StatefulWidget {
  const ShortPageList({Key? key}) : super(key: key);

  @override
  State<ShortPageList> createState() => _ShortPageListState();
}

class _ShortPageListState extends State<ShortPageList> {
  late ShortManager manager;

  @override
  void initState() {
    context.read<ShortManager>().initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ShortManager manager = context.watch<ShortManager>();
    if (manager.isLoading) return const LoadingShortPage();
    if (manager.cards.isEmpty) {
      return Center(child: Image.asset("assets/images/404.jpg"));
    }
    return PageView.builder(
      itemCount: manager.cards.length,
      itemBuilder: (context, i) => ShortDisplayPage(short: manager.cards[i]),
      scrollDirection: Axis.vertical,
    );
  }
}

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
    return Scaffold(
      backgroundColor: Colors.grey,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/short.jpeg"),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 58),
              curve: Curves.linear,
              duration: const Duration(
                milliseconds: 200,
              ),
              height: expandedBar ? 275 : 170,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Tooltip(
                              waitDuration: const Duration(seconds: 3),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(15),
                              triggerMode: TooltipTriggerMode.tap,
                              message: widget.short.name,
                              child: Text(
                                widget.short.name, 
                                style: GoogleFonts.poppins(
                                  color: Colors.white, 
                                  fontSize: 18, 
                                  fontWeight: FontWeight.w500
                                ),
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20,),
                          GestureDetector(
                            onTap: () => setState(() => expandedBar = !expandedBar),
                            child: Container(
                              width: 25,
                              height: 25,
                              child: Icon(
                                expandedBar ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
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
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(15),
                              triggerMode: TooltipTriggerMode.tap,
                              message: widget.short.description,
                              child: Container(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  widget.short.description ?? "",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white, 
                                    fontSize: 15, 
                                    fontWeight: FontWeight.w400
                                  ),
                                  maxLines: 4,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                          ) 
                          : Container()
                      )
                    ]),
                  ),
                  Positioned(
                    bottom: 10,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(CustomIcon.video_view, color: Colors.white,),
                            const SizedBox(width: 10,),
                            Text(
                              "${widget.short.viewCount.toString()} views", 
                              style: GoogleFonts.poppins(color: Colors.white),
                            )
                          ],),
                          Row(children: [
                            const Icon(CustomIcon.video_heart, color: Colors.white,),
                            const SizedBox(width: 10,),
                            Text(
                              "${widget.short.likeCount.toString()} likes", 
                              style: GoogleFonts.poppins(color: Colors.white),
                            )
                          ],),
                          const SizedBox(width: 35,),
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
                  sideBarButton(CustomIcon.short_heart, () {}),
                  const SizedBox(height: 20,),
                  sideBarButton(CustomIcon.comments, 
                    () => showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      context: context,
                      builder: (context) => CommentList(videoId: widget.short.id)),
                  ),
                  const SizedBox(height: 20,),
                  sideBarButton(CustomIcon.reply, () async {
                    await FlutterShare.share(
                      title: widget.short.name,
                      text: widget.short.name,
                      linkUrl: widget.short.video,
                      chooserTitle: widget.short.name
                    );}
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  Widget sideBarButton(IconData icon, Function() onTap, {Color? color}) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor.withOpacity(0.4), Colors.yellow.withOpacity(0.4)]
        ),
        shape: BoxShape.circle
      ),
      child: GestureDetector(onTap: onTap, child: Icon(icon, size: 33, color: color ?? Colors.grey[300],))
    );
  }
}
