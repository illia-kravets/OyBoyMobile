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
}


abstract class BasePagination {
  bool paginationLoad = false;
  void paginate();
}

abstract class BaseOrdering {
  void orderBy(String key);
}


abstract class BaseSearch {
  
  void search();
}

class CRUDManager<M extends BaseModel, T extends CRUDGeneric<M>> extends BaseManager with BasePagination, BaseOrdering {
  List<M> cards = [];
  T repository = GetIt.I.get<T>();
  bool get hasNext => repository.hasNext;

  @override
  void initialize() {
    // TODO: implement initialize
  }

  @override
  void orderBy(String key, {bool ascending = true}) async {
    isLoading = true;
    refresh();
    repository.ordering(key, ascending: ascending);
    cards = await repository.list();
    isLoading = false;
    refresh();
  }

  @override
  Future<void> paginate() async {
    if (!repository.hasNext) return;
    paginationLoad = true;
    refresh();
    cards.addAll(await repository.next());
    paginationLoad = false;
    refresh();
  }

}