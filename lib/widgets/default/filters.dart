import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "/constants/export.dart";
import "/data/export.dart";

class FiltersRow<T extends FilterCRUDManager> extends StatelessWidget {
  const FiltersRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    T manager = context.read<T>();
    List<FilterAction> filters = context.select((T m) => m.appliedFilters);

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
                  label: Text(
                    filters[i].title,
                    style: theme.textTheme.bodyText2,
                  ),
                  deleteIcon: Icon(
                    Icons.close,
                    color: theme.primaryColor,
                  ),
                  onDeleted: () => manager.popFilter(filters[i])),
              separatorBuilder: (_, i) => const SizedBox(width: 4),
            ),
          );
  }
}

class FilterDrawer<T extends FilterCRUDManager> extends StatelessWidget {
  const FilterDrawer({Key? key, this.hasTags = false}) : super(key: key);

  final bool hasTags;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle? fieldStyle = theme.textTheme.bodyText1;
    T manager = context.watch<T>();

    return SafeArea(
        child: Drawer(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("filters".tr(), style: theme.textTheme.headline3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "ordering".tr(),
              style: fieldStyle,
            ),
            FilterDropdown(
                filterType: FilterType.ordering,
                onChanged: (FilterAction? v) => manager.addFilter(v),
                items: manager.filters)
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "filter".tr(),
              style: fieldStyle,
            ),
            FilterDropdown(
                filterType: FilterType.relevation,
                onChanged: (FilterAction? v) => manager.addFilter(v),
                items: manager.filters)
          ]),
          if (hasTags)
            Column(children: [
              Flex(direction: Axis.horizontal, children: [
                Text(
                  "tags".tr(),
                  style: fieldStyle,
                )
              ]),
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
              width: 120,
              child: ElevatedButton(
                  onPressed: () {
                    manager.applyFilter();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "apply".tr(),
                    style: theme.textTheme.button,
                  )),
            ),
          )
        ],
      ),
    )));
  }
}

class FilterDropdown extends StatelessWidget {
  FilterDropdown(
      {Key? key,
      required this.onChanged,
      required List<FilterAction> items,
      this.filterType})
      : super(key: key) {
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
              )),
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
      if (e.selected) selected = e;
      if (e.head) head = e;
    }

    assert(head != null, "Default filter must be specified");
    if (selected != null) return selected;
    return head;
  }
}

class FilterCharacteristics extends StatelessWidget {
  FilterCharacteristics(
      {Key? key,
      required this.onSelect,
      required List<FilterAction> items,
      this.filterType})
      : super(key: key) {
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
                  label: Text(items[i].title, style: theme.textTheme.bodyText2),
                  selected: items[i].selected,
                  onSelected: (selected) => onSelect(selected, items[i]),
                ))
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
