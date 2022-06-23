import 'dart:async';
import 'package:get_it/get_it.dart';

import '/constants/export.dart';
import '/data/export.dart';

class ShortManager extends CRUDManager<ShortRepository> {
  Video? activeShort;

  @override
  void initialize() async {
    isLoading = true;

    cards = await repository.list();

    if (cards.isNotEmpty) activeShort = cards[0];
    isLoading = false;
    refresh();
  }

  void setActiveShort(Video short) {
    if (activeShort == short) return;
    activeShort = short;
    refresh();
  }

  void clear() {
    activeShort = null;
  }

  void like() async {
    activeShort = activeShort!.copyWith(
      liked: !activeShort!.liked, 
      likeCount: activeShort!.liked ? activeShort!.likeCount - 1 : activeShort!.likeCount + 1);
    cards = cards.map((e) {
      if (e!.id == activeShort!.id) return activeShort;
      return e;
    }).toList();
    repository.like(activeShort!.id.toString());
    refresh();
  }

  void view() async {
    repository.view(activeShort!.id.toString());
  }
}
