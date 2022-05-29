import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/data/managers/short.dart';
import 'package:oyboy/data/repositories/profile.dart';
import 'package:oyboy/widgets/default/default_page.dart';
import 'package:provider/provider.dart';

import '../../data/models/video.dart';
import '../video/card.dart';
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
              duration: const Duration(microseconds: 200),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.short.name),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 20,
                        height: 20,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: theme.primaryColor,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
