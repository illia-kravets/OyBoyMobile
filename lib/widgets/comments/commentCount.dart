import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/data/managers/comment.dart';
import 'package:oyboy/data/models/video.dart';
import 'package:provider/provider.dart';

class CommentCount extends StatelessWidget {
  const CommentCount({ Key? key, required this.onTap, this.opened=true }) : super(key: key);

  final bool opened;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Video video = context.select((CommentManager m) => m.video);
    
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${video.commentCount} ${'comments'.tr()}", 
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 10,),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 25,
              height: 25,
              child: Icon(
                opened 
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_up_rounded,
                color: Colors.black,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          )
        ],
      ),
    );
  }
}