import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "/constants/export.dart";
import "/widgets/export.dart";
import "/data/export.dart";

class SearchPage<T extends SearchVideoGeneric> extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  static MaterialPage videoSearch() {
    return MaterialPage(
        name: OyBoyPages.videoSearchPath,
        key: const ValueKey(OyBoyPages.videoSearchPath),
        child: ChangeNotifierProvider<VideoSearchManager>(
          create:(context) => VideoSearchManager(), 
          child: const SearchPage<VideoSearchManager>()
        )
    );
  }

  static MaterialPage streamSearch() {
    return MaterialPage(
        name: OyBoyPages.streamSearchPath,
        key: const ValueKey(OyBoyPages.streamSearchPath),
        child: ChangeNotifierProvider<StreamSearchManager>(
          create:(context) => StreamSearchManager(), 
          child: const SearchPage<StreamSearchManager>()
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Search<T>();
  }
}

class Search<T extends SearchVideoGeneric> extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  State<Search<T>> createState() => _SearchState<T>();
}

class _SearchState<T extends SearchVideoGeneric> extends State<Search<T>> {
  final TextEditingController _searchController = TextEditingController();
  late T searchManager;
  
  void searchUpdate() {}

  @override
  void initState() {
    _searchController.addListener(searchUpdate);
    searchManager = context.read<T>();
    searchManager.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool focused = true;
  
  @override
  Widget build(BuildContext context) {
    
    return focused ? SuggestionWidget<T>(appBar: appBar,) : DefaultPage(appBar: appBar,);
  }

  PreferredSizeWidget get appBar {
    
    return AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => searchManager.goToPage(),
        ),
        title: SearchInput(
          controller: _searchController,
          onSubmit: (_) => searchManager.search(text: _searchController.text),
        ),
        actions: const <Widget>[Icon(Icons.abc_outlined)],
      );
  }
}


class SearchInput extends StatelessWidget {
  SearchInput({Key? key, required this.controller, required this.onSubmit}) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> onSubmit;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          onFieldSubmitted: onSubmit,
          controller: controller,
          textInputAction: TextInputAction.search,
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


class SuggestionWidget<T extends SearchVideoGeneric> extends StatelessWidget {
  const SuggestionWidget({ Key? key, this.appBar }) : super(key: key);  
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    List<Suggestion> suggestions = context.select((T v) => v.suggestions);
    
    return Scaffold(
      appBar: appBar,
      body: ListView.builder(
          itemCount: suggestions.length, 
          itemBuilder: ((context, index) => 
            SuggestionLine(
              suggestion: suggestions[index], 
              onTap: (Suggestion s) => context.read<T>().search(text: s.text),
            )
          )
        )
    );
  }
}

class SuggestionLine extends StatelessWidget {
  const SuggestionLine({ Key? key, required this.suggestion, required this.onTap}) : super(key: key);

  final Suggestion suggestion;
  final ValueChanged<Suggestion> onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData data = Theme.of(context);
    return InkWell(
      onTap: () => onTap(suggestion),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10), 
        child: Row(children: [
          Icon(suggestion.searched ? Icons.search : Icons.history),
          Text(suggestion.text, style: data.textTheme.bodyText1)
        ]),
      ),
    );
  }
}