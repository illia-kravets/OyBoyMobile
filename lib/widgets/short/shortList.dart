import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/data/managers/short.dart';
import 'package:oyboy/data/repositories/profile.dart';
import 'package:oyboy/my_icons.dart';
import 'package:oyboy/widgets/default/default_page.dart';
import 'package:oyboy/widgets/short/player.dart';
import 'package:oyboy/widgets/short/shortDisplayPage.dart';
import 'package:oyboy/widgets/video/list.dart';
import 'package:provider/provider.dart';

import '../../data/models/video.dart';
import '../video/card.dart';
import '../comments/commentPage.dart';
import 'detailAppbar.dart';
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
            child: Selector<ShortManager, Video?>(
                selector: (_, manager) => manager.activeShort,
                builder: (_, short, __) => DetailVideoAppBar(video: short))),
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
  late PageController _controller;

  void onPageChange() {
    // manager.setActiveShort(manager.cards[page]);
  }

  @override
  void initState() {
    context.read<ShortManager>().initialize();
    _controller = PageController();
    _controller.addListener(onPageChange);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.removeListener(onPageChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ShortManager manager = context.watch<ShortManager>();
    if (manager.isLoading) return const LoadingShortPage();
    if (manager.cards.isEmpty) {
      return NotFound(
        text: 'nothingFound'.tr(),
      );
    }
    return PageView.builder(
        itemCount: manager.cards.length,
        itemBuilder: (context, i) => Scaffold(body: ShortDisplayPage(short: manager.cards[i])),
        scrollDirection: Axis.vertical,
        onPageChanged: (page) => manager.setActiveShort(manager.cards[page]));
  }
}


