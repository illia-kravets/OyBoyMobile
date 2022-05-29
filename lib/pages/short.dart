import "package:flutter/material.dart";

import '../widgets/short/shortList.dart';
import "/constants/export.dart";
import '/data/export.dart';
import "/widgets/export.dart";

class ShortPage extends StatelessWidget {
  const ShortPage({
    Key? key,
  }) : super(key: key);

  static MaterialPage page() {
    return const MaterialPage(
        name: OyBoyPages.shortPath,
        key: ValueKey(OyBoyPages.shortPath),
        child: ShortPage());
  }

  @override
  Widget build(BuildContext context) {
    return const ShortList();
  }
}
