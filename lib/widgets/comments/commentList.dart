import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oyboy/data/managers/comment.dart';
import 'package:oyboy/utils/utils.dart';
import 'package:oyboy/widgets/video/list.dart';
import 'package:provider/provider.dart';

import 'commentCard.dart';

class CommentList extends StatefulWidget {
  const CommentList({ Key? key }) : super(key: key);

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  late CommentManager manager;
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(scrollListener);
    manager = context.read<CommentManager>();
    super.initState();
  }

  void scrollListener() {
    if (_controller.position.atEdge)
      if (_controller.position.pixels != 0.0)
        manager.paginate();
  
  }

  @override
  void dispose() {
    _controller.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List cards = context.select((CommentManager m) => m.cards);
    if (cards.isEmpty)
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: NotFound(text: 'nothingFound'.tr()));
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 315),
      child: ListView.separated(
        controller: _controller,
        itemCount: cards.length + 1,
        itemBuilder: (context, index) {
          if (index < cards.length) {
            return CommentCard(
              comment: cards[index],
            );
          } else {
            return Column(
              children: [
                if (manager.hasNext)
                const Loader(
                  width: 30,
                  height: 30,
                  strokeWidth: 4,
                ),
              ],
            );
          }
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
      ),
    );
  }
}
