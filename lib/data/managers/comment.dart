import 'package:get_it/get_it.dart';
import 'package:oyboy/data/export.dart';

class CommentManager extends CRUDManager<CommentRepository> {
  CommentManager({required this.videoId});

  final int videoId;
  late int? count;

  @override 
  void initialize() async {
    isLoading = true;
    repository.query({"video_id": videoId.toString()});
    cards = await repository.list();
    count = repository.response.count ?? 0;
    isLoading = false;
    refresh();
  }

  void addComment(String text) async {
    Profile profile = GetIt.I.get<AuthRepository>().profile;
    Comment comment = Comment(profile: profile, profileId: profile.id, videoId: videoId.toString(), name: text);
    cards = [comment, ...cards];
    refresh();
    await repository.create(comment);
  }
}