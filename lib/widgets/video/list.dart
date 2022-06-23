// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "package:provider/provider.dart";

import '/utils/utils.dart';
import "/data/export.dart";
import "/widgets/export.dart";
import "/constants/export.dart";
import 'card.dart';

class HomeVideoList<T extends HomeVideoGeneric> extends StatefulWidget {
  const HomeVideoList({Key? key}) : super(key: key);

  @override
  State<HomeVideoList> createState() => _HomeVideoListState<T>();
}

class _HomeVideoListState<T extends HomeVideoGeneric>
    extends State<HomeVideoList<T>> {
  @override
  void initState() {
    context.read<T>().initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    T repository = context.watch<T>();
    bool hasTags = repository.tags.isNotEmpty;

    return repository.isLoading
        ? loader
        : Stack(
            children: [
              Column(
                children: [
                  if (hasTags)
                    const SizedBox(
                      height: CHIPBAR_HEIGHT,
                    ),
                  repository.cardLoading
                      ? loader
                      : Expanded(child: GenericCardList<T>())
                ],
              ),
              if (hasTags) ChipBar<T>(tags: repository.tags),
            ],
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

class GenericCardList<T extends CRUDManager> extends StatefulWidget {
  GenericCardList(
      {Key? key,
      this.scrollableType = ScrollableType.list,
      CardConfig? cardConfig})
      : super(key: key) {
    this.cardConfig = cardConfig ?? CardConfig();
  }

  final ScrollableType scrollableType;
  late CardConfig cardConfig;

  @override
  State<GenericCardList> createState() => _GenericCardListState<T>();
}

class _GenericCardListState<T extends CRUDManager>
    extends State<GenericCardList> {
  late T repository;
  late ScrollController _controller;
  late bool _showUpButton;

  @override
  void initState() {
    _showUpButton = false;
    _controller = ScrollController();
    _controller.addListener(scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    repository = context.watch<T>();
    return Stack(
      children: [
        widget.scrollableType == ScrollableType.list
            ? VideoCardList<T>(
                controller: _controller,
                config: widget.cardConfig,
              )
            : VideoCardGrid<T>(
                controller: _controller,
                config: widget.cardConfig,
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

class CardConfig {
  CardConfig(
      {this.count = 3,
      this.active,
      this.paginate,
      this.onPageEnd,
      String? endText,
      String? emptyListText}) {
    this.emptyListText = emptyListText ?? "nothingFound".tr();
    this.endText = endText ?? "paginationEdge".tr();
  }

  final bool? active;
  final int count;

  final bool? paginate;
  final Function()? onPageEnd;
  late String endText;
  late String emptyListText;

  bool get activityAssert {
    if (active != null) return count > 0;
    return true;
  }

  bool get paginateAssert {
    if (paginate != null) {
      if (paginate == false) return onPageEnd != null;
    }
    return true;
  }
}

class NotFound extends StatelessWidget {
  NotFound({Key? key, this.text}) : super(key: key);

  String? text;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/404.jpg'),
                      fit: BoxFit.fitHeight))),
          if (text != null)
            Text(
              text!,
              style: theme.textTheme.headline4,
              textAlign: TextAlign.center,
            )
        ],
      ),
    );
  }
}

class VideoCardList<T extends CRUDManager> extends StatelessWidget {
  VideoCardList(
      {Key? key,
      this.primary,
      this.physics,
      this.shrinkWrap = false,
      this.controller,
      CardConfig? config})
      : super(key: key) {
    this.config = config ?? CardConfig();
    assert(this.config.activityAssert,
        "If you provide active - count must be > 0");
    assert(this.config.paginateAssert,
        "onPageEnd callback must be provided if paginate=false");
  }

  final bool? primary;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  late CardConfig config;

  @override
  Widget build(BuildContext context) {
    T repository = context.watch<T>();
    ThemeData theme = Theme.of(context);

    if (config.active != null && !config.active!)
      return ListView.separated(
          primary: primary,
          shrinkWrap: shrinkWrap,
          physics: physics,
          controller: controller,
          itemCount: config.count,
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          itemBuilder: (context, index) => const LoadingVideoCard());
    if (repository.cards.isEmpty)
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: NotFound(text: config.emptyListText));
    return ListView.separated(
      primary: primary,
      shrinkWrap: shrinkWrap,
      physics: physics,
      controller: controller,
      itemCount: repository.cards.length + 1,
      itemBuilder: (context, index) {
        if (index < repository.cards.length) {
          return VideoCard(
            video: repository.cards[index],
          );
        } else {
          return Column(
            children: [
              paginateContent(
                  context, repository.hasNext && repository.cards.isNotEmpty),
              const SizedBox(
                height: 25,
              )
            ],
          );
        }
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
    );
  }

  Widget paginateContent(BuildContext context, bool hasNext) {
    ThemeData theme = Theme.of(context);
    if (hasNext) {
      if (config.paginate ?? true)
        return const Loader(
          width: 40,
          height: 40,
          strokeWidth: 4,
        );
      else
        return GestureDetector(
          onTap: config.onPageEnd,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 237, 100, 255), Colors.white]),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.primaryColor, width: 1.2)),
            child: Text(
              "Show more",
              style: theme.textTheme.bodyText1,
            ),
          ),
        );
    } else
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          config.endText,
          style: theme.textTheme.bodyText1,
        ),
      );
  }
}

class VideoCardGrid<T extends CRUDManager> extends StatelessWidget {
  VideoCardGrid(
      {Key? key,
      this.primary,
      this.physics,
      this.shrinkWrap = false,
      this.controller,
      CardConfig? config})
      : super(key: key) {
    this.config = config ?? CardConfig();
    assert(this.config.activityAssert,
        "If you provide active - count must be > 0");
    assert(this.config.paginateAssert,
        "onPageEnd callback must be provided if paginate=false");
  }

  final bool? primary;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  late CardConfig config;
  late T repository;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    repository = context.watch<T>();

    return repository.cards.isEmpty
        ? NotFound(text: config.emptyListText)
        : Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, theme.primaryColor, Colors.white])),
            child: Container(
                height: 900,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white,
                        theme.primaryColor.withOpacity(0),
                        Colors.white
                      ]),
                ),
                child: config.active != null && !config.active!
                    ? GridView.builder(
                        physics: physics,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 380,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3,
                                childAspectRatio: 2.2 / 3),
                        itemCount: repository.cards.length,
                        itemBuilder: (_, i) =>
                            const LoadingShortVideoCard() // ShortVideoCard(video: repository.cards[i])
                        )
                    : GridView.builder(
                        physics: physics,
                        controller: controller,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 380,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3,
                                childAspectRatio: 2.2 / 3),
                        itemCount: gridCount,
                        itemBuilder: (c, i) {
                          if (i < repository.cards.length)
                            return ShortVideoCard(
                              video: repository.cards[i],
                            );
                          else
                            return gridEdgeContent(c, i);
                        })),
          );
  }

  bool get usePagination => repository.hasNext && (config.paginate ?? true);

  int get gridCount {
    int count = repository.cards.length;
    if (!usePagination) count += 1;
    if (count % 2 != 0) count += 1;
    return count;
  }

  Widget gridEdgeContent(BuildContext context, int index) {
    ThemeData theme = Theme.of(context);
    if (index == repository.cards.length && !usePagination)
      return Container(
          padding: const EdgeInsets.all(5),
          color: Colors.grey[50],
          child: Container(
            decoration: const BoxDecoration(
                gradient: RadialGradient(
                    colors: [Colors.white, Color.fromARGB(255, 237, 100, 255)],
                    radius: 2),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ElevatedButton(
              onPressed: config.onPageEnd,
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, shadowColor: Colors.transparent),
              child: Text("Show more", style: theme.textTheme.bodyText1),
            ),
          ));
    if (usePagination)
      return Container(
        color: Colors.white,
        child: const Loader(
          width: 40,
          height: 40,
          strokeWidth: 4,
        ),
      );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        config.endText,
        style: theme.textTheme.bodyText1,
      ),
    );
  }
}
