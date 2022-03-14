import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "package:provider/provider.dart";

import '/utils/utils.dart';
import "/data/export.dart";
import "/widgets/export.dart";
import "/constants/export.dart";
import 'card.dart';

class VideoList<T extends BaseVideoManager> extends StatefulWidget {
  const VideoList({Key? key, this.showChipBar = false}) : super(key: key);

  final bool showChipBar;
  @override
  State<VideoList> createState() => _VideoListState<T>();
}

class _VideoListState<T extends BaseVideoManager> extends State<VideoList> {
  late ScrollController _controller;
  late bool _showUpButton;
  late T videoRepository;

  @override
  void initState() {
    _showUpButton = false;
    _controller = ScrollController();
    _controller.addListener(scrollListener);
    context.read<T>().initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    videoRepository = context.watch<T>();
    return videoRepository.isLoading
        ? const Center(
            child: Loader(
              strokeWidth: 4,
              height: 35,
              width: 35,
            ),
          )
        : Stack(
            children: [
              if (widget.showChipBar) ChipBar<T>(tags: videoRepository.tags),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                child: Column(
                  children: [
                    if (widget.showChipBar)
                      const SizedBox(
                        height: CHIPBAR_HEIGHT,
                      ),
                    Expanded(
                      child: ListView.separated(
                        controller: _controller,
                        itemCount: videoRepository.cards.length + 1,
                        itemBuilder: (context, index) {
                          if (index < videoRepository.cards.length) {
                            return VideoCard(
                              video: videoRepository.cards[index],
                            );
                          } else {
                            return Column(
                              children: const [
                                Loader(
                                  width: 40,
                                  height: 40,
                                  strokeWidth: 4,
                                ),
                                SizedBox(
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
                    )
                  ],
                ),
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
        videoRepository.paginate();
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
}
