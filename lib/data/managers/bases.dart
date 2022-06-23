import "package:flutter/material.dart";
import '/data/export.dart';
import "/constants/export.dart";
import "package:get_it/get_it.dart";

abstract class BaseManager extends ChangeNotifier {
  AppError error = AppError();
  PageType? page;
  bool isLoading = false;
  bool cardsLoading = false;
  String? selectedId;
  static Type? parent;

  bool get hasError => error.msg == null ? false : true;

  void initialize();
  void refresh() => notifyListeners();

  void goToPage({PageType? page}) {
    this.page = page;
    notifyListeners();
  }

  void clearRoute() {
    page = null;
    selectedId = null;
    refresh();
  }

  void selectId(dynamic id) {
    selectedId = id;
    refresh();
  }

  bool get idSetted => selectedId != null && selectedId!.isNotEmpty;
}

abstract class BaseCRUDManager<T extends CRUDGeneric> extends BaseManager {
  List<dynamic> cards = [];
  T repository = GetIt.I.get<T>();
  dynamic selectedCard;

  @override
  void goToPage({PageType? page}) {
    this.page = page;
    notifyListeners();
    repository.request.flush();
  }

  @override
  void clearRoute() {
    selectedCard = null;
    super.clearRoute();
  }

  void selectCard(dynamic card) {
    selectedCard = card;
    refresh();
  }

  bool get cardSetted => selectedCard != null;

}

mixin PaginationMixin<T extends CRUDGeneric> on BaseCRUDManager<T> {
  bool paginationLoad = false;

  Future paginate() async {
    if (!repository.hasNext) return;
    paginationLoad = true;
    refresh();
    await Future.delayed(Duration(milliseconds: 200));
    cards.addAll(await repository.next());
    paginationLoad = false;
    refresh();
  }

  bool get hasNext => repository.hasNext;
}

mixin OrderingMixin<T extends CRUDGeneric> on BaseCRUDManager<T> {
  void orderBy(String key, {bool ascending = true}) async {
    isLoading = true;
    refresh();
    repository.ordering(key, ascending: ascending);
    cards = await repository.list();
    isLoading = false;
    refresh();
  }
}

mixin FilterMixin<T extends CRUDGeneric> on BaseCRUDManager<T> {
  List<FilterAction> selectedFilters = [];
  List<FilterAction> appliedFilters = [];

  void addFilter(FilterAction? filter) {
    if (filter == null) return;
    selectedFilters
        .removeWhere((e) => e.type == filter.type && e.type != FilterType.tag);
    if (!filter.head) selectedFilters.add(filter);
    refresh();
  }

  void popSelectedFilter(FilterAction filter, {bool useRefresh = true}) {
    selectedFilters
        .removeWhere((e) => e.type == filter.type && e.title == filter.title);
    if (useRefresh) refresh();
  }

  Future popFilter(FilterAction filter) async {
    popSelectedFilter(filter, useRefresh: false);
    applyFilter();
  }

  Future applyFilter() async {
    cardsLoading = true;
    appliedFilters = [...selectedFilters];
    refresh();
    List tagTitles = [];
    for (var e in appliedFilters) {
      if (e.type != FilterType.tag)
        repository.query(e.query);
      else
        tagTitles.add(e.title);
    }
    repository.query({"tags": tagTitles.join(",")});
    cards = await repository.list();
    cardsLoading = false;
    refresh();
  }

  List<FilterAction> get filters {
    return repository.filters.map((e) {
      for (var item in selectedFilters) {
        if (item.type == e.type && item.value == e.value)
          return e.copyWith(selected: true);
      }
      return e;
    }).toList();
  }

  List<FilterAction> get filterSource =>
      throw UnimplementedError("filterSource filters must be provided");
}

abstract class CRUDManager<T extends CRUDGeneric> extends BaseCRUDManager<T>
    with OrderingMixin, PaginationMixin {}

abstract class FilterCRUDManager<T extends CRUDGeneric> extends CRUDManager<T>
    with FilterMixin {}
