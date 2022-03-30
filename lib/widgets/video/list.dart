// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "package:provider/provider.dart";

import '/utils/utils.dart';
import "/data/export.dart";
import "/widgets/export.dart";
import "/constants/export.dart";
import 'card.dart';

class VideoList<T extends HomeVideoGeneric> extends StatelessWidget {
  const VideoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    T repository = context.watch<T>();

    return repository.isLoading
        ? const Center(
            child: Loader(
              strokeWidth: 4,
              height: 35,
              width: 35,
            ),
          )
        : Stack(
            children: [
              if (repository.tags.isNotEmpty) ChipBar<T>(tags: repository.tags),
              GenericCardList<T>(showChipBar: repository.tags.isNotEmpty)
            ],
          );
  }
}


class GenericCardList<T extends VideoGeneric> extends StatefulWidget {
  const GenericCardList({Key? key, this.showChipBar=false}) : super(key: key);

  final bool showChipBar;
  @override
  State<GenericCardList> createState() => _GenericCardListState<T>();
}


class _GenericCardListState<T extends VideoGeneric>
    extends State<GenericCardList> {
  late T repository;
  late ScrollController _controller;
  late bool _showUpButton;


  @override
  void initState() {
    _showUpButton = false;
    _controller = ScrollController();
    _controller.addListener(scrollListener);
    context.read<T>().initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    repository = context.watch<T>();
    return Stack(
      children: [
        Column(
          children: [
            if (widget.showChipBar)
            const SizedBox(
              height: CHIPBAR_HEIGHT,
            ),
            Expanded(
              child: ListView.separated(
                controller: _controller,
                itemCount: repository.cards.length + 1,
                itemBuilder: (context, index) {
                  if (index < repository.cards.length) {
                    return VideoCard(
                      video: repository.cards[index],
                    );
                  } else {
                    return Column(
                      children: [
                        repository.hasNext
                            ? const Loader(
                                width: 40,
                                height: 40,
                                strokeWidth: 4,
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "That's all the folks",
                                  style: theme.textTheme.bodyText1,
                                ),
                              ),
                        const SizedBox(
                          height: 25,
                        )
                      ],
                    );
                  }
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 15,
                ),
              ),
            ),
          ],
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          bottom: _showUpButton ? 80 : 0,
          right: 25,
          child: AnimatedOpacity(
            opacity: _showUpButton ? 1.0 : 0,
            duration: const Duration(milliseconds: 200),
            child: InkWell(
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30)),
                child: const Icon(
                  Icons.keyboard_arrow_up,
                  size: 45,
                  color: Colors.white,
                ),
              ),
              onTap: () => _controller.animateTo(0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceIn),
            ),
          ),
        )
      ],
    );
  }

  void boolSetter(bool show) {
    if (show && !_showUpButton)
      setState(() => _showUpButton = true);
    else if (!show && _showUpButton) setState(() => _showUpButton = false);
  }

  set showUpButton(bool show) => boolSetter(show);

  void scrollListener() {
    ScrollDirection direction = _controller.position.userScrollDirection;

    if (_controller.position.atEdge) {
      if (_controller.position.pixels == 0.0)
        showUpButton = false;
      else
        repository.paginate();
    } else {
      switch (direction) {
        case ScrollDirection.forward:
          if (_controller.position.pixels > 200) showUpButton = true;
          break;
        case ScrollDirection.reverse:
          showUpButton = false;
          break;
        default:
          break;
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(scrollListener);
    super.dispose();
  }
}

class Test extends enum with