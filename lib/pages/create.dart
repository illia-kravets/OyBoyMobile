import "package:flutter/material.dart";
import 'package:oyboy/data/export.dart';
import "/constants/export.dart";
import "/widgets/export.dart";
import "package:provider/provider.dart";

class CreatePage {

  static MaterialPage videoCreate() {
    return const MaterialPage(
        name: OyBoyPages.videoCreatePath,
        key: ValueKey(OyBoyPages.videoCreatePath),
        child: VideoCreatePage()
    );
  }

  static MaterialPage streamCreate() {
    return const MaterialPage(
        name: OyBoyPages.streamCreatePath,
        key: ValueKey(OyBoyPages.streamCreatePath),
        child: StreamCreatePage()
    );
  }
  
  static MaterialPage shortCreate() {
    return const MaterialPage(
        name: OyBoyPages.shortCreatePath,
        key: ValueKey(OyBoyPages.shortCreatePath),
        child: ShortCreatePage()
    );
  }
}



class VideoCreatePage extends StatelessWidget {
  const VideoCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return DefaultPage(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.read<VideoManager>().goToPage(), 
          child: const Icon(Icons.arrow_back),
        ), title: const Text("Create video"),),
    );
  }
}

class StreamCreatePage extends StatelessWidget {
  const StreamCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return DefaultPage(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.read<StreamManager>().goToPage(), 
          child: const Icon(Icons.arrow_back),
        ), title: const Text("Start live"),),
    );
  }
}

class ShortCreatePage extends StatelessWidget {
  const ShortCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return DefaultPage(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.read<ShortManager>().goToPage(), 
          child: const Icon(Icons.arrow_back),
        ), title: const Text("Create short"),),
    );
  }
}