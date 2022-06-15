import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:oyboy/data/export.dart';
import 'package:oyboy/data/managers/comment.dart';
import 'package:oyboy/widgets/video/card.dart';
import 'package:provider/provider.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({ Key? key }) : super(key: key);

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _commentController = TextEditingController();
  late Profile profile;
  late CommentManager manager;

  @override
  void initState() {
    profile = GetIt.I.get<AuthRepository>().profile;
    manager = context.read<CommentManager>();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey[300]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NetworkCircularAvatar(url: profile.avatar ?? "",),
          // const SizedBox(width: 1,),
          SizedBox(
            width: 260, 
            child: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "commentPlaceholder".tr()
              ),
              minLines: 1,
              maxLines: 2,
              style: theme.textTheme.bodyText2,
            ),
          ),
          // const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              manager.addComment(_commentController.text);
              _commentController.text = "";
            },
            child: Container(
              height: 40, 
              width: 40, 
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                      colors: [theme.primaryColor, Colors.yellow])
              ),
              child: const Icon(CupertinoIcons.paperplane_fill, size: 20, color: Colors.white,),
            ),
          )
        ],
      ),
    );
  }
}