import 'package:get_it/get_it.dart';
import 'package:oyboy/data/export.dart';

class CommentManager extends CRUDManager<CommentRepository> {
  CommentManager({required this.video});

  Video video;
  int? count;

  @override 
  void initialize() async {
    isLoading = true;
    repository.query({"video_id": video.id.toString()});
    cards = await repository.list();
    count = repository.response.count ?? 0;
    isLoading = false;
    refresh();
  }

  void addComment(String text) async {
    Profile profile = GetIt.I.get<AuthRepository>().profile;
    Comment comment = Comment(profile: profile, profileId: profile.id, videoId: video.toString(), name: text);
    cards = [comment, ...cards];
    video = video.copyWith(commentCount: video.commentCount + 1);
    refresh();
    await repository.create(comment);
  }
}