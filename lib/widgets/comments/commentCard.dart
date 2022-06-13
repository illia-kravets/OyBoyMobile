import 'package:flutter/material.dart';
import 'package:oyboy/data/models/comment.dart';
import 'package:oyboy/widgets/video/card.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({ Key? key, required this.comment }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NetworkCircularAvatar(url: comment.profile?.avatar ?? "", radius: 26,),
        const SizedBox(width: 10,),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30), 
                bottomRight: Radius.circular(30), 
                bottomLeft: Radius.circular(30)
              ),
              color: Colors.grey[300]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(comment.profile?.username ?? "", style: theme.textTheme.bodyText1,),
                Text(comment.name ?? "", style: theme.textTheme.bodyText2,)
              ],
            ),
          ),
        )
      ],
    );
  }
}