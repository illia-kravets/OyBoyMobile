import 'dart:async';
import 'package:get_it/get_it.dart';

import '/constants/export.dart';
import '/data/export.dart';
import "bases.dart";

abstract class BaseVideoManager extends BaseManager
    with BasePagination, BaseCard<Video>, BaseHome {}


abstract class BaseVideoSearch extends BaseManager
    with BasePagination, BaseCard, BaseSearch {}


class GenericVideoManager<T extends BaseVideoRepository>
    extends BaseVideoManager {
  final T videoRepository = GetIt.I.get<T>();

  List<Tag> getFilterTags() {
    return [
      Tag(
          marker: TagMarker.recomendations,
          name: "Reccomendations",
          scope: TagScope.local),
      Tag(
          marker: TagMarker.subscriptions,
          name: "Subscribtions",
          scope: TagScope.local),
      ...videoRepository.getFilterTags()
    ];
  }

  List<Video> getVideo() {
    return videoRepository.fetch();
  }

  @override
  void initialize() {
    Timer(
      const Duration(milliseconds: 500),
      () {
        tags = getFilterTags();
        selectedTag = tags[0];
        cards = getVideo();
        isLoading = false;
        refresh();
      },
    );
  }

  @override
  void paginate() {
    paginationLoad = true;
    refresh();
    Timer(
      const Duration(milliseconds: 500),
      () {
        cards.addAll(videoRepository.fetch());
        paginationLoad = false;

        refresh();
      },
    );
  }

  @override
  void filterCardList(Tag tag) {
    selectedTag = tag;
    refresh();
    switch (tag.scope) {
      case TagScope.external:
        videoRepository.filterListByTag(tag);
        break;

      case TagScope.local:
        videoRepository.filterListByQuery();
        break;
    }
  }
}

class VideoManager extends GenericVideoManager<VideoRepository> {}

class StreamManager extends GenericVideoManager<StreamRepository> {}
