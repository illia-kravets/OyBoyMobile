import 'package:get_it/get_it.dart';
import 'package:oyboy/data/export.dart';

class DetailVideoManager extends CRUDManager<VideoRepository> {
  DetailVideoManager({required this.video});

  Video video;
  List authorCards = [];

  @override
  void initialize() async {
    isLoading = true;

    repository.query({"profile_id": video.channelId.toString()});
    authorCards = await repository.list();
    repository.request.flush();
    
    isLoading = false;
    refresh();
  }

  void like() async {
    video = video.copyWith(liked: !video.liked);
    refresh();
  }

  void favourite() async {
    video = video.copyWith(favourite: !video.favourite);
    refresh();
  }

  void view() async {}
}
