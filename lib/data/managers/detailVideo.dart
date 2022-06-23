import 'package:get_it/get_it.dart';
import 'package:oyboy/data/export.dart';

class DetailVideoManager extends CRUDManager<VideoRepository> {
  DetailVideoManager({required this.videoId});

  String videoId;
  Video video = Video();
  List authorCards = [];

  @override
  void initialize() async {
    isLoading = true;

    repository.query({"show_banned": "true", "show_own": "true"});
    video = await repository.retrieve(videoId);
    repository.query({
      "profile_id": video.channelId.toString(),
      "exclude": video.id.toString()
    });
    authorCards = await repository.list();
    repository.request.flush();
    view();
    isLoading = false;
    refresh();
  }

  void like() async {
    video = video.copyWith(
        liked: !video.liked,
        likeCount: video.liked ? video.likeCount - 1 : video.likeCount + 1);
    repository.like(video.id.toString());
    refresh();
  }

  void favourite() async {
    video = video.copyWith(favourite: !video.favourite);
    repository.favourite(video.id.toString());
    refresh();
  }

  void view() async {
    repository.view(video.id.toString());
  }
}
