import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "/constants/export.dart";
import "/widgets/export.dart";
import "/data/export.dart";
import "/utils/utils.dart";

class SearchPage<T extends SearchVideoGeneric> extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  static MaterialPage videoSearch() {
    return MaterialPage(
        name: OyBoyPages.videoSearchPath,
        key: const ValueKey(OyBoyPages.videoSearchPath),
        child: ChangeNotifierProvider<VideoSearchManager>(
            create: (context) => VideoSearchManager(),
            child: const SearchPage<VideoSearchManager>()),
        arguments: const {"filterManagerType": VideoSearchManager});
  }

  static MaterialPage streamSearch() {
    return MaterialPage(
        name: OyBoyPages.streamSearchPath,
        key: const ValueKey(OyBoyPages.streamSearchPath),
        child: ChangeNotifierProvider<StreamSearchManager>(
            create: (context) => StreamSearchManager(),
            child: const SearchPage<StreamSearchManager>()),
        arguments: const {"filterManagerType": StreamSearchManager});
  }

  @override
  Widget build(BuildContext context) {
    return Search<T>();
  }
}

class Search<T extends SearchVideoGeneric> extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool focused = context.select((T v) => v.isFocused);
    PreferredSizeWidget appBar = SearchAppBar<T>();
    return focused
        ? SuggestionWidget<T>(
            appBar: appBar,
          )
        : SearchResult<T>(
            appBar: appBar,
          );
  }
}

class SearchAppBar<T extends SearchVideoGeneric> extends StatefulWidget
    implements PreferredSizeWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState<T>();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _SearchAppBarState<T extends SearchVideoGeneric>
    extends State<SearchAppBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late bool _showClear;
  late T searchManager;

  void searchUpdate() {
    if (_controller.text.isEmpty && _showClear)
      setState(() => _showClear = false);
    if (_controller.text.isNotEmpty && !_showClear)
      setState(() => _showClear = true);
    searchManager.updateSuggesions(_controller.text);
  }

  void onFocus() {
    if (_controller.text.isEmpty && searchManager.isFocused) return;
    searchManager.isFocused = _focusNode.hasFocus;
    searchManager.refresh();
  }

  void onSubmit(String text) {
    if (text.isEmpty) return _focusNode.requestFocus();
    searchManager.search(text: text);
  }

  @override
  void initState() {
    _focusNode = FocusNode();
    _controller = TextEditingController();

    searchManager = context.read<T>();
    _showClear = (searchManager.searchText ?? "").isNotEmpty;
    _controller.text = searchManager.searchText ?? "";
    _focusNode.addListener(onFocus);
    _controller.addListener(searchUpdate);
    searchManager.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(searchUpdate);
    _focusNode.removeListener(onFocus);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool focused = context.select((T v) => v.isFocused);
    return AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
            color: theme.primaryColor),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          height: 55,
          child: TextFormField(
            autofocus: focused,
            focusNode: _focusNode,
            onFieldSubmitted: onSubmit,
            controller: _controller,
            style: theme.textTheme.bodyText1,
            textInputAction: TextInputAction.search,
            cursorColor: theme.primaryColor,
            decoration: InputDecoration(
                hintText: "search".tr(),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                suffixIcon: _showClear
                    ? GestureDetector(
                        onTap: () {
                          _controller.clear();
                          context.read<T>().searchText = '';
                          _focusNode.requestFocus();
                        },
                        child: Icon(
                          Icons.close,
                          color: theme.primaryColor,
                        ))
                    : null),
          ),
        ),
        actions: <Widget>[
          if (!focused)
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: Icon(Icons.filter_alt, color: theme.primaryColor)),
            ),
          const SizedBox(width: 10)
        ]);
  }
}

class SuggestionWidget<T extends SearchVideoGeneric> extends StatelessWidget {
  const SuggestionWidget({Key? key, this.appBar}) : super(key: key);
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    List suggestions = context.select((T v) => v.suggestions);

    return Scaffold(
        appBar: appBar,
        body: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: ((context, index) => SuggestionLine(
                  suggestion: suggestions[index],
                  onTap: (Suggestion s) {
                    context.read<T>().search(text: s.text);
                    FocusScope.of(context).unfocus();
                  },
                ))));
  }
}

class SuggestionLine extends StatelessWidget {
  const SuggestionLine(
      {Key? key, required this.suggestion, required this.onTap})
      : super(key: key);

  final Suggestion suggestion;
  final ValueChanged<Suggestion> onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData data = Theme.of(context);
    return InkWell(
      onTap: () => onTap(suggestion),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(children: [
          Icon(
            suggestion.searched ? Icons.history : Icons.search,
            size: 26,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(suggestion.text, style: data.textTheme.bodyText1)
        ]),
      ),
    );
  }
}

class SearchResult<T extends SearchVideoGeneric> extends StatelessWidget {
  const SearchResult({Key? key, this.appBar}) : super(key: key);

  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    T manager = context.watch<T>();

    return DefaultPage(
      appBar: appBar,
      extendBody: true,
      endDrawer: FilterDrawer<T>(
        hasTags: true,
      ),
      body: manager.isLoading
          ? loader
          : Column(
              children: [
                FiltersRow<T>(),
                if (manager.cards.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("searchResult".tr(),
                            style: theme.textTheme.bodyText2),
                        Text(
                          manager.searchText ?? "",
                          style: theme.textTheme.button,
                        ),
                      ],
                    ),
                  ),
                manager.cardsLoading
                    ? loader
                    : Expanded(
                        child: GenericCardList<T>(
                        cardConfig: CardConfig(
                            emptyListText:
                                "${'requestNothingFound'.tr()}${manager.searchText}"),
                      )),
              ],
            ),
    );
  }

  Widget get loader => const Expanded(
        child: Center(
          child: Loader(
            strokeWidth: 4,
            height: 35,
            width: 35,
          ),
        ),
      );
}
