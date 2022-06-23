import 'package:flutter/material.dart';
import 'package:oyboy/constants/export.dart';
import 'package:oyboy/data/export.dart';
import 'package:oyboy/widgets/default/default_page.dart';
import 'package:oyboy/widgets/detailVideo/detailVideoPage.dart';
import 'package:oyboy/widgets/short/detailAppbar.dart';
import 'package:oyboy/widgets/short/shortDisplayPage.dart';

class DetailShortRoute {
  static MaterialPage page(Video short) {
    return MaterialPage(
      name: OyBoyPages.detailShortPath,
      key: const ValueKey(OyBoyPages.detailShortPath),
      child: DetailShortPage(short: short,)
    );
  }
}

class DetailShortPage extends StatelessWidget {
  const DetailShortPage({ Key? key, required this.short }) : super(key: key);

  final Video short;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultPage(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: DetailVideoAppBar(video: short),
        ),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: ShortDisplayPage(short: short,),
      ),
    );
  }
}
