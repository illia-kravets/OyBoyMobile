import "package:flutter/material.dart";
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
                  height: 48,
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "BOY",
                      style: TextStyle(
                        color: Color.fromARGB(255, 224, 0, 112),
                        fontSize: 18,
                        letterSpacing: 3,
                      ),
                    ))
              ],
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () => context.read<T>().goToPage(page: PageType.search),
                  icon: const Icon(Icons.search))
            ],
          ),
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: body ?? VideoList<T>(showChipBar: true),
    );
  }
}
