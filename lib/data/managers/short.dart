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
}
