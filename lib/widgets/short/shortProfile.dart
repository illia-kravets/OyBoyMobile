import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/widgets/profile/profile_page.dart';
import 'package:provider/provider.dart';

import '../../data/export.dart';
import '../video/card.dart';

class ShortProfile extends StatelessWidget {
  const ShortProfile({Key? key, this.channelId}) : super(key: key);

  final String? channelId;

  @override
  Widget build(BuildContext context) {
    if (channelId == null) return _loadingCard();
    return FutureBuilder<Profile>(
        future: GetIt.I.get<ProfileRepository>().retrieve(channelId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              snapshot.data == null) return _loadingCard();
          return _card(context, snapshot.data);
        });
  }

  Widget _card(BuildContext context, Profile? channel) {
    return GestureDetector(
      onTap: () => context.read<ProfileManager>().selectId(channelId),
      child: Row(
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
              Text(channel.username ?? "",
                  style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
              Text("${channel.subscribers.toString()} ${'subscribers'.tr()}",
                  style: GoogleFonts.poppins(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.white)),
            ],
          )
        ],
      ),
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
