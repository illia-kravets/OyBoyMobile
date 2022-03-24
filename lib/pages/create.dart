import "package:flutter/material.dart";
import 'package:oyboy/data/export.dart';
import 'package:oyboy/data/managers/create.dart';
import "/constants/export.dart";
import "/widgets/export.dart";
import "package:provider/provider.dart";

class CreatePage {
  static MaterialPage videoCreate() {
    return MaterialPage(
        name: OyBoyPages.videoCreatePath,
        key: const ValueKey(OyBoyPages.videoCreatePath),
        child: ChangeNotifierProvider<CreateManager>(
            create: (context) => CreateManager(),
            child: const VideoCreatePage()));
  }

  static MaterialPage streamCreate() {
    return MaterialPage(
        name: OyBoyPages.streamCreatePath,
        key: const ValueKey(OyBoyPages.streamCreatePath),
        child: ChangeNotifierProvider<CreateManager>(
            create: (context) => CreateManager(),
            child: const StreamCreatePage()));
  }

  static MaterialPage shortCreate() {
    return MaterialPage(
        name: OyBoyPages.shortCreatePath,
        key: const ValueKey(OyBoyPages.shortCreatePath),
        child: ChangeNotifierProvider<CreateManager>(
            create: (context) => CreateManager(),
            child: const ShortCreatePage()));
  }
}

class VideoCreatePage extends StatelessWidget {
  const VideoCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultPage(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.read<VideoManager>().goToPage(),
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          "Create video",
          style: theme.textTheme.headline4,
        ),
      ),
      body: BaseCreatePage(isShort: true),
    );
  }
}

class StreamCreatePage extends StatelessWidget {
  const StreamCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultPage(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.read<StreamManager>().goToPage(),
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          "Start live",
          style: theme.textTheme.headline4,
        ),
      ),
    );
  }
}

class ShortCreatePage extends StatelessWidget {
  const ShortCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultPage(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.read<ShortManager>().goToPage(),
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          "Create short",
          style: theme.textTheme.headline4,
        ),
      ),
      body: BaseCreatePage(isShort: true),
    );
  }
}

class BaseCreatePage extends StatelessWidget {
  BaseCreatePage({Key? key, this.isShort = false}) : super(key: key);

  final bool isShort;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    CreateManager manager = context.watch<CreateManager>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: theme.textTheme.bodyText1,
                ),
                TextFormField(
                  maxLength: 126,
                  cursorColor: theme.primaryColor,
                  // decoration: InputDecoration(counter: ),
                  // onChanged: (value) => manager.name = value,
                ),
                // Container(
                //   child: Text("${manager.name.length}/126"),
                //   alignment: Alignment.centerRight,
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
