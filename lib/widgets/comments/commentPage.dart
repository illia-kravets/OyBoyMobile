// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:easy_localization/easy_localization.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/data/models/profile.dart';
import 'package:oyboy/data/repositories/auth.dart';
import 'package:oyboy/utils/utils.dart';
import 'package:oyboy/widgets/short/shortProfile.dart';
import 'package:oyboy/widgets/video/card.dart';
import 'package:oyboy/widgets/video/list.dart';
import 'package:provider/provider.dart';

import '../../data/export.dart';
import '/data/managers/comment.dart';
import 'commentCard.dart';
import 'commentCount.dart';
import 'commentInput.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({ Key? key, required this.videoId }) : super(key: key);
  final int videoId;

  @override
  Widget build(BuildContext context) {
    CommentManager manager = CommentManager(videoId: videoId);
    return ChangeNotifierProvider<CommentManager>(
      create: (context) => manager,
      child: const CommentPageSkeleton()
    );
  }
}

class CommentPageSkeleton extends StatefulWidget {
  const CommentPageSkeleton({ Key? key }) : super(key: key);

  @override
  State<CommentPageSkeleton> createState() => _CommentPageSkeletonState();
}

class _CommentPageSkeletonState extends State<CommentPageSkeleton> {

  @override
  void initState() {
    context.read<CommentManager>().initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool loading = context.select((CommentManager m) => m.isLoading);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      constraints: const BoxConstraints(maxHeight: 600),
      child: loading 
        ? const Loader(width: 30, height: 30,)
        : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CommentCount(),
            SizedBox(height: 12,),
            CommentInput(),
            SizedBox(height: 12,),
            CommentList()
            // Container(
            //   height: 7, 
            //   width: 36, 
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10), 
            //     color: Colors.grey,
            //   ),
            // )
          ],
        ),
      // color: Colors.white,
    );
  }
}

class CommentList extends StatelessWidget {
  const CommentList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List cards = context.select((CommentManager m) => m.cards);
    if (cards.isEmpty)
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: NotFound(text: 'nothingFound'.tr()));
    return CommentCard(
            comment: cards[0],
          );
    return ListView.separated(

      itemCount: cards.length + 1,
      itemBuilder: (context, index) {
        if (index < cards.length) {
          return CommentCard(
            comment: cards[index],
          );
        } else {
          return Column(
            children: const [
              Loader(
                width: 40,
                height: 40,
                strokeWidth: 4,
              ),
              SizedBox(
                height: 25,
              )
            ],
          );
        }
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
    );
  }
}

