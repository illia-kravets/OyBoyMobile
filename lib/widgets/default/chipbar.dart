import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import '/data/export.dart';
import "/constants/export.dart";

class ChipBar<T extends HomeVideoGeneric> extends StatelessWidget {
  const ChipBar({Key? key, required this.tags}) : super(key: key);

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    Tag? selectedTag = context.select((T v) => v.selectedTag);

    List<Widget> children = List.generate(
        tags.length,
        (index) => CustomChoiceChip(
              tag: tags[index],
              selected: tags[index].name == selectedTag?.name,
              onSelected: (selected) =>
                  context.read<T>().filterCardList(tags[index]),
            ));

    return Material(
      elevation: 4,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 16, right: 16),
        height: CHIPBAR_HEIGHT,
        child: ListView.separated(
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 5)),
      ),
    );
  }
}

class CustomChoiceChip extends StatelessWidget {
  const CustomChoiceChip(
      {Key? key,
      required this.tag,
      required this.selected,
      required this.onSelected})
      : super(key: key);

  final Tag tag;
  final bool selected;
  final Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(tag.name, style: Theme.of(context).textTheme.bodyText2),
      elevation: 5,
      onSelected: onSelected,
      selected: selected,
    );
  }
}
