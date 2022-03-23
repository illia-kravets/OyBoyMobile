// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'package:get_it/get_it.dart';

import '/constants/export.dart';
import '/data/export.dart';

class VideoGeneric<T extends BaseVideoRepository>
    extends CRUDManager<Video, T> {}

class HomeVideoGeneric<T extends BaseVideoRepository> extends VideoGeneric<T> {
  List<Tag> tags = [];
  Tag? selectedTag;

  Future<List<Tag>> getFilterTags() async {
    return [
      Tag(
          marker: TagMarker.recomendations,
          name: "Reccomendations",
          scope: TagScope.local),
      Tag(
          marker: TagMarker.subscriptions,
          name: "Subscribtions",
          scope: TagScope.local),
      ...await repository.getTags()
    ];
  }

  @override
  Future<void> initialize() async {
    isLoading = true;
    tags = await getFilterTags();
    selectedTag = tags[0];
    cards = await repository.list();
    isLoading = false;
    refresh();
  }

  Future<void> filterCardList(Tag tag) async {
    selectedTag = tag;
    refresh();
    if (tag.scope == TagScope.external)
      repository.query({"tag_id": tag.id});
    else
      repository.query({"q": tag.marker});
    cards = await repository.list();
  }
}


abstract class SearchVideoGeneric<T extends BaseVideoRepository>
    extends VideoGeneric<T> {
  
  SuggestionRepository suggestionRepository =
      GetIt.I.get<SuggestionRepository>();

  bool isFocused = true;
  String? searchText;

  List<Tag> _tags = [];
  List<FilterAction> _selectedFilters = [];
  List<Suggestion> suggestions = [];
  List<FilterAction> appliedFilters = [];

  @override
  void initialize() async {
    super.initialize();
    filterSuggesions();
    suggestions = await suggestionRepository.list();
    refresh();
    _tags = await GetIt.I.get<TagRepository>().list();
  }

  void filterSuggesions() =>
      suggestionRepository.ordering("searched", ascending: false);

  void updateSuggesions([String text = ""]) async {
    if (text.length < 3) return;
    suggestionRepository.request.flush();
    filterSuggesions();
    suggestionRepository.query({"text": text});
    suggestions = await suggestionRepository.list();
    refresh();
  }

  Future<void> search({String? text}) async {
    if (text == null || text.isEmpty) return;
    isLoading = true;
    isFocused = false;
    searchText = text;
    appliedFilters = [];
    refresh();
    repository.request.flush();
    repository.query({"q": text});
    await suggestionRepository.create(Suggestion(text: text, type: "video"));
    cards = await repository.list();
    isLoading = false;
    refresh();
  }

  Future<void> applyFilter() async {
    isLoading = true;
    appliedFilters = [..._selectedFilters];
    refresh();
    List tagIds = [];
    for (var e in appliedFilters) {
      if (e.type != FilterType.tag) repository.query(e.query);
      else tagIds.add(e.value);
    }
    if (tagIds.isNotEmpty) repository.query({"tags": tagIds.join(",")});
    cards = await repository.list();
    isLoading = false;
    refresh();
  }

  void addFilter(FilterAction? filter) {
    if (filter == null) return;
    _selectedFilters.removeWhere((e) => e.type == filter.type && e.type != FilterType.tag);
    if (!filter.head) _selectedFilters.add(filter);
    refresh();
  }

  void popSelectedFilter(FilterAction filter, {bool useRefresh = true}) {
    _selectedFilters.removeWhere((e) => e.type == filter.type && e.value == filter.value);
    if (useRefresh) refresh();
  }

  Future<void> popFilter(FilterAction filter) async {
    popSelectedFilter(filter, useRefresh: false);
    applyFilter();
  }

  List<FilterAction> get filters {
    return [
      ...Filters.video.map((e) {
        for (var item in _selectedFilters) {
          if (item.type == e.type && item.value == e.value) 
            return e.copyWith(selected: true);
        }
        return e;
      }).toList(),
      ..._filterTags.map((e) {
        for (var item in _selectedFilters) {
          if (item.type == e.type && item.value == e.value) 
            return e.copyWith(selected: true);
        }
        return e;
      }).toList(),
    ];
  }

  List<FilterAction> get _filterTags {
    return List.generate(
      _tags.length, (i) => FilterAction(
        type: FilterType.tag, 
        value: _tags[i].id.toString(), 
        title: _tags[i].name
      )
    );
  }
}

class VideoManager extends HomeVideoGeneric<VideoRepository> {}

class StreamManager extends HomeVideoGeneric<StreamRepository> {}

class VideoSearchManager extends SearchVideoGeneric<VideoRepository> {
  static Type? parent = VideoManager;

  @override
  void filterSuggesions() {
    super.filterSuggesions();
    suggestionRepository.query({"type": "video"});
  }
}

class StreamSearchManager extends SearchVideoGeneric<StreamRepository> {
  static Type? parent = StreamManager;

  @override
  void filterSuggesions() {
    super.filterSuggesions();
    suggestionRepository.query({"type": "stram"});
  }
}

