import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:oyboy/constants/appstate.dart';
import "package:provider/provider.dart";

import "/data/managers/video.dart";
import "/widgets/default/default_page.dart";
import 'list.dart';

class DefaultVideoPage<T extends HomeVideoGeneric> extends StatelessWidget {
  const DefaultVideoPage(
      {Key? key,
      this.appBar,
      this.body,
      this.extendBody = true,
      this.extendBodyBehindAppBar = false})
      : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      appBar: appBar ??
          AppBar(
            elevation: 0,
            title: Row(
              children: [
                Image.asset(
                  "assets/images/logo.jpeg",
                  height: 40,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text("DAILY VIBE",
                        style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 224, 0, 112),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5)))
              ],
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () =>
                      context.read<T>().goToPage(page: PageType.search),
                  icon: const Icon(Icons.search))
            ],
          ),
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: body ?? HomeVideoList<T>(),
    );
  }
}
