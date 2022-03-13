import 'dart:async';
import 'package:get_it/get_it.dart';

import '/constants/export.dart';
import '/data/export.dart';

abstract class BaseVideoManager extends BaseManager {
  bool isLoading = true;
  bool paginationLoad = false;
  bool focusSearch = false;
  late Tag selectedTag;
  List<Video> videos = [];
  List<Tag> tags = [];

  void initialize();
  void paginate();
  void filterVideoList(Tag tag);
  void search() {
    focusSearch = true;
    goToPage(page: PageType.search);
  }
}

class VideoManager extends BaseVideoManager {
  final VideoRepository videoRepository = GetIt.I.get<VideoRepository>();

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
        videos = getVideo();
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
        videos.addAll(videoRepository.fetch());
        paginationLoad = false;

        refresh();
      },
    );
  }

  @override
  void filterVideoList(Tag tag) {
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

class StreamManager extends BaseVideoManager {
  final StreamRepository streamRepository = GetIt.I.get<StreamRepository>();

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
      ...streamRepository.getFilterTags()
    ];
  }

  List<Video> getVideo() {
    return streamRepository.fetch();
  }

  @override
  void initialize() {
    Timer(
      const Duration(milliseconds: 500),
      () {
        tags = getFilterTags();
        selectedTag = tags[0];
        videos = getVideo();
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
        videos.addAll(streamRepository.fetch());
        paginationLoad = false;

        refresh();
      },
    );
  }

  @override
  void filterVideoList(Tag tag) {
    selectedTag = tag;

    refresh();

    switch (tag.scope) {
      case TagScope.external:
        streamRepository.filterListByTag(tag);
        break;

      case TagScope.local:
        streamRepository.filterListByQuery();
        break;
    }
  }
}
