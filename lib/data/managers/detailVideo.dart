import 'package:get_it/get_it.dart';
import 'package:oyboy/data/export.dart';

class DetailVideoManager extends CRUDManager<VideoRepository> {
  DetailVideoManager({required this.video});

  final Video video;
  List<Video> authorCards = [];

  @override
  void initialize() async {
    isLoading = false;
    authorCards.add(video);
  }

  void like() async {}

  void favourite() async {}

  void view() async {}
}
