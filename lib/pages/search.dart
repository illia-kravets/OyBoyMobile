import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:provider/provider.dart";

import "/constants/export.dart";
import "/widgets/export.dart";
import "/data/export.dart";

class SearchPage<T extends BaseVideoManager> extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  static MaterialPage videoSearch() {
    return const MaterialPage(
        name: OyBoyPages.videoSearchPath,
        key: ValueKey(OyBoyPages.videoSearchPath),
        child: SearchPage<VideoManager>());
  }

  static MaterialPage streamSearch() {
    return const MaterialPage(
        name: OyBoyPages.streamSearchPath,
        key: ValueKey(OyBoyPages.streamSearchPath),
        child: SearchPage<StreamManager>());
  }

  @override
  Widget build(BuildContext context) {
    return Search<T>();
  }
}

class Search<T extends BaseVideoManager> extends StatelessWidget {
  Search({Key? key}) : super(key: key);
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.read<T>().goToPage(),
        ),
        title: SearchInput(
          controller: _searchController,
        ),
        actions: [Icon(Icons.abc_outlined)],
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  SearchInput({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          )),
    );
  }
}
