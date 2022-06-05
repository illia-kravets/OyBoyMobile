import "package:flutter/material.dart";

class CommentList extends StatelessWidget {
  const CommentList({ Key? key, required this.videoId }) : super(key: key);
  final int videoId;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          Container(
            height: 7, 
            width: 36, 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), 
              color: Colors.grey,
            ),
          )
        ],
      ),
      // color: Colors.white,
    );
    return Column();
  }
}