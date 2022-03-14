import "package:flutter/material.dart";
import '/data/export.dart';
import "/constants/export.dart";

abstract class BaseManager extends ChangeNotifier {
  AppError error = AppError();
  PageType? page;
  bool isLoading = true;

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

abstract class BaseCard<T> {
  List<T> cards = [];
  void filterCardList(Tag tag);
}

abstract class BaseHome {
  late Tag selectedTag;
  List<Tag> tags = [];
}

abstract class BaseSearch {
  void search();
}
