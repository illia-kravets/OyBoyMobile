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

class Search<T extends SearchVideoGeneric> extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    bool focused = context.select((T v) => v.isFocused);
    PreferredSizeWidget appBar = SearchAppBar<T>();
    return focused
      ? SuggestionWidget<T>(appBar: appBar,) 
      : SearchResult<T>(appBar: appBar,);
  }
}

class SearchAppBar<T extends SearchVideoGeneric> extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppBar({ Key? key }) : super(key: key);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState<T>();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _SearchAppBarState<T extends SearchVideoGeneric> extends State<SearchAppBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late bool _showClear;
  late T searchManager;
  
  void searchUpdate() {

    if (_controller.text.isEmpty && _showClear) setState(() => _showClear = false);
    if (_controller.text.isNotEmpty && !_showClear) setState(() => _showClear = true);
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
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
        color: theme.primaryColor
      ),
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
              hintText: "Search...",
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              enabledBorder:
                  const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder:
                  const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              suffixIcon: _showClear
                ? GestureDetector(onTap: () {
                    _controller.clear();
                    context.read<T>().searchText = '';
                    _focusNode.requestFocus();
                  }, 
                  child: Icon(Icons.close, color: theme.primaryColor,)
                )
                : null
            ),
        ),
    ),
    
    actions: <Widget>[
      if (!focused) Container(
        padding: const EdgeInsets.only(left: 10),
        child: GestureDetector(
          onTap: () => Scaffold.of(context).openEndDrawer(), 
          child: Icon(Icons.filter_alt, 
          color: theme.primaryColor)
        ),
      ),
      const SizedBox(width: 10)]
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
              onTap: (Suggestion s) {
                context.read<T>().search(text: s.text);
                FocusScope.of(context).unfocus();
              },
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), 
        child: Row(children: [
          Icon(suggestion.searched ? Icons.history : Icons.search, size: 26,),
          const SizedBox(width: 12,),
          Text(suggestion.text, style: data.textTheme.bodyText1)
        ]),
      ),
    );
  }
}

class SearchResult<T extends SearchVideoGeneric> extends StatelessWidget {
  const SearchResult({ Key? key, this.appBar }) : super(key: key);

  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String? searchText = context.select((T v) => v.searchText);
    T manager = context.read<T>();

    return DefaultPage(
        appBar: appBar,
        extendBody: true,
        endDrawer: FilterDrawer<T>(),
        body: Column(
          children: [
            Selector<T, List<FilterAction>>(
              selector: (_, manager) => manager.appliedFilters,
              builder: (_, filters, __) => FiltersRow(
                filters: filters, 
                onCancel: (FilterAction e) => manager.popFilter(e)  
              ), 
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Search results for: ", style: theme.textTheme.bodyText2),
                  Text(searchText ?? "", style: theme.textTheme.button,),
                ],
              ),
            ),
            Expanded(child: GenericCardList<T>()),
          ],
        ),
      );
  }
}

class FiltersRow extends StatelessWidget {
  const FiltersRow({ Key? key, required this.filters, required this.onCancel }) : super(key: key);
  final List<FilterAction> filters;
  final ValueChanged<FilterAction> onCancel;
  
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return filters.isEmpty 
    ? const SizedBox() 
    : Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: CHIPBAR_HEIGHT,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length, 
        itemBuilder: (_, i) => Chip(
          shadowColor: theme.primaryColor,
          label: Text(filters[i].title, style: theme.textTheme.bodyText2,),
          deleteIcon: Icon(Icons.close, color: theme.primaryColor,),
          onDeleted: () => onCancel(filters[i])
        ), 
        separatorBuilder: (_, i) => const SizedBox(width: 4),
      ),
    );
  }
}

class FilterDrawer<T extends SearchVideoGeneric>  extends StatelessWidget {
  const FilterDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle? fieldStyle = theme.textTheme.bodyText1;
    T manager = context.watch<T>();

    return SafeArea(
      child: Drawer(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Filters", style: theme.textTheme.headline3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ordering", style: fieldStyle,), 
                FilterDropdown(
                  filterType: FilterType.ordering,
                  onChanged: (FilterAction? v) => manager.addFilter(v), 
                  items: manager.filters
                )
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Filter", style: fieldStyle,), 
                FilterDropdown(
                  filterType: FilterType.relevation,
                  onChanged: (FilterAction? v) => manager.addFilter(v), 
                  items: manager.filters
                )
              ]
            ),
            Column(children: [
              Flex(direction: Axis.horizontal, children: [Text("Characteristics", style: fieldStyle,)]),
              FilterCharacteristics(
                items: manager.filters,
                filterType: FilterType.tag,
                onSelect: (selected, filter) {
                  if (selected) {
                    manager.addFilter(filter);
                  } else {
                    manager.popSelectedFilter(filter);
                  }
                },
              )
            ]),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    manager.applyFilter();
                    Navigator.of(context).pop();
                  },
                  child: Text("Apply", style: theme.textTheme.button,)
                ),
              ),
            )
          ],
        ),
      ))
    );
  }
}

class FilterDropdown extends StatelessWidget {
  FilterDropdown({
    Key? key, 
    required this.onChanged, 
    required List<FilterAction> items,
    this.filterType
  }) : super(key: key) {
    this.items = selectedItems(items);
  }

  final ValueChanged<FilterAction?> onChanged;
  final String? filterType;
  late List<FilterAction> items;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DropdownButton<FilterAction>(
      value: value,
      style: theme.textTheme.bodyText2,
      items: List.generate(
        items.length, 
        (i) => DropdownMenuItem(
          child: Text(items[i].title), 
          value: items[i],
        )
      ), 
      onChanged: onChanged,
    );
  }

  List<FilterAction> selectedItems(List<FilterAction> items) {
    List<FilterAction> filters = [];
    if (filterType == null) return items;
    for (var item in items) {
      if (item.type == filterType) filters.add(item);
    }
    return filters;
  }

  FilterAction? get value {
    FilterAction? selected;
    FilterAction? head;
    
    for (var e in items) {
      if(e.selected) selected = e;
      if(e.head) head = e;
    }

    assert(head != null, "Default filter must be specified");
    if (selected != null) return selected;
    return head;
  }
}

class FilterCharacteristics extends StatelessWidget {
  FilterCharacteristics({
    Key? key, 
    required this.onSelect, 
    required List<FilterAction> items,
    this.filterType
  }) : super(key: key) {
    this.items = selectedItems(items);
  }

  final Function(bool selected, FilterAction filter) onSelect;
  final String? filterType;
  late List<FilterAction> items;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Wrap(
      spacing: 6,
      children: [
        ...List.generate(
          items.length,
          (i) => FilterChip(
            showCheckmark: false,
            avatar: items[i].selected
              ? Icon(Icons.check, color: theme.primaryColor)
              : null,
            label: Text(items[i].title), 
            selected: items[i].selected,
            onSelected: (selected) => onSelect(selected, items[i]),
          )
        )
      ],
    );
  }

  List<FilterAction> selectedItems(List<FilterAction> items) {
    List<FilterAction> filters = [];
    if (filterType == null) return items;
    for (var item in items) {
      if (item.type == filterType) filters.add(item);
    }
    return filters;
  }
}