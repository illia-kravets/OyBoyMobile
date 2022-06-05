import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/export.dart';
import '../video/card.dart';

class ShortProfile extends StatelessWidget {
  const ShortProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Video? short = context.select((ShortManager v) => v.activeShort);
    if (short == null) return _loadingCard();
    return FutureBuilder<Channel>(
        future: GetIt.I.get<ChannelRepository>().retrieve(short.channel_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              snapshot.data == null) return _loadingCard();
          return _card(context, snapshot.data);
        });
  }

  Widget _card(BuildContext context, Channel? channel) {
    return Row(
      children: [
        NetworkCircularAvatar(
          url: channel!.avatar ?? "",
          radius: 23,
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(channel.name,
                style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
            Text("${channel.subscriberCount.toString()} subscribers",
                style: GoogleFonts.poppins(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white)),
          ],
        )
      ],
    );
  }

  Widget _loadingCard() {
    return Row(
      children: [
        CircleAvatar(
          radius: 23,
          backgroundColor: Colors.grey[400],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(children: [
          Container(
            height: 15,
            width: 150,
            color: Colors.grey[400],
          ),
          const SizedBox(
            height: 6,
          ),
          Container(
            height: 15,
            width: 150,
            color: Colors.grey[400],
          )
        ])
      ],
    );
  }
}