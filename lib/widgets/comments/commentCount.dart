import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/data/managers/comment.dart';
import 'package:provider/provider.dart';

class CommentCount extends StatelessWidget {
  const CommentCount({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    int? count = context.select((CommentManager m) => m.count);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$count ${'comments'.tr()}", 
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10,),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 25,
            height: 25,
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
        )
      ],
    );
  }
}