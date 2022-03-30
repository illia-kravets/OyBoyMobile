import "package:flutter/material.dart";
import '/data/export.dart';
import "/constants/export.dart";
import "package:get_it/get_it.dart";

abstract class BaseManager extends ChangeNotifier {
  AppError error = AppError();
  PageType? page;
  bool isLoading = false;
  static Type? parent;

  bool get hasError => error.msg == null ? false : true;

  void initialize();
  void refresh() => notifyListeners();

  void goToPage({PageType? page}) {
    this.page = page;
    notifyListeners();
  }

  List get cards;
}


abstract class FilterManagerBase extends BaseManager {
  List<FilterAction> selectedFilters = [];
  List<FilterAction> appliedFilters = [];

  void addFilter(FilterAction? filter);
  void popSelectedFilter(FilterAction filter, {bool useRefresh = true});
  Future<void> popFilter(FilterAction filter);
  Future<void> applyFilter();
  List<FilterAction> get filters;
  List<FilterAction> get filterSource;
}

abstract class OrderingManagerBase extends BaseManager {
  void orderBy(String key, {bool ascending = true});
}

abstract class PaginationManagerBase extends BaseManager {
  bool paginationLoad = false;
  Future paginate();
  bool get hasNext;
}


abstract class CRUDManager<M extends BaseModel, T extends CRUDGeneric<M>> 
  extends BaseManager with OrderingManagerBase, PaginationManagerBase {
  
  List<M> _cards = [];
  T repository = GetIt.I.get<T>();

  @override
  List<M> get cards => _cards;

  set cards(List<M> c) => _cards = c;
}

abstract class FilterCRUDManager<M extends BaseModel, T extends CRUDGeneric<M>> 
  extends CRUDManager<M, T> with FilterManagerBase {}

mixin PaginationMixin<M extends BaseModel, D extends CRUDGeneric<M>> 
  on CRUDManager<M, D>, PaginationManagerBase {
  
  @override
  Future paginate() async {
    if (!repository.hasNext) return;
    paginationLoad = true;
    refresh();
    cards.addAll(await repository.next());
    paginationLoad = false;
    refresh();
  }

  @override
  bool get hasNext => repository.hasNext;
}

mixin OrderingMixin<M extends BaseModel, D extends CRUDGeneric<M>> 
  on CRUDManager<M, D>, OrderingManagerBase {

  @override
  void orderBy(String key, {bool ascending = true}) async {
    isLoading = true;
    refresh();
    repository.ordering(key, ascending: ascending);
    _cards = await repository.list();
    isLoading = false;
    refresh();
  }
}

mixin FilterMixin<M extends BaseModel, D extends CRUDGeneric<M>> 
  on CRUDManager<M, D>, FilterManagerBase {

  @override
  void addFilter(FilterAction? filter) {
    if (filter == null) return;
    selectedFilters.removeWhere((e) => e.type == filter.type && e.type != FilterType.tag);
    if (!filter.head) selectedFilters.add(filter);
    refresh();
  }

  @override
  void popSelectedFilter(FilterAction filter, {bool useRefresh = true}) {
    selectedFilters.removeWhere((e) => e.type == filter.type && e.value == filter.value);
    if (useRefresh) refresh();
  }

  @override
  Future<void> popFilter(FilterAction filter) async {
    popSelectedFilter(filter, useRefresh: false);
    applyFilter();
  }

  @override
  Future<void> applyFilter() async {
    isLoading = true;
    appliedFilters = [...selectedFilters];
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

  @override
  List<FilterAction> get filters {
    return filterSource.map((e) {
      for (var item in selectedFilters) {
        if (item.type == e.type && item.value == e.value) 
          return e.copyWith(selected: true);
      }
      return e;
    }).toList();
  }

  @override
  List<FilterAction> get filterSource => throw UnimplementedError("filterSource filters must be provided");
}


class FilterManager<T extends BaseModel, S extends CRUDGeneric<T>> extends FilterCRUDManager<T, S> with FilterMixin {}
class OrderingManager<T extends BaseModel, S extends CRUDGeneric<T>> extends CRUDManager<T, S> with OrderingMixin {}
class PaginationManager<T extends BaseModel, S extends CRUDGeneric<T>> extends CRUDManager<T, S> with PaginationMixin {}

class FullCRUD<T extends BaseModel, S extends CRUDGeneric<T>> 
  extends CRUDManager<T, S> with OrderingMixin, PaginationMixin {}

class FilterCRUD<T extends BaseModel, S extends CRUDGeneric<T>> 
  extends FilterCRUDManager<T, S> with FilterMixin, OrderingMixin, PaginationMixin {}

