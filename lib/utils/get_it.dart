import 'package:get_it/get_it.dart';
import "/data/export.dart";

void startGet() {
  GetIt.I.registerSingleton<AuthRepository>(AuthRepository());
  GetIt.I.registerFactory<TagRepository>(() => TagRepository());
  GetIt.I.registerFactory<SuggestionRepository>(() => SuggestionRepository());
  GetIt.I.registerFactory<VideoRepository>(() => VideoRepository());
  GetIt.I.registerFactory<StreamRepository>(() => StreamRepository());
  GetIt.I.registerFactory<ShortRepository>(() => ShortRepository());
  GetIt.I.registerFactory<ProfileRepository>(() => ProfileRepository());
  GetIt.I.registerFactory<CommentRepository>(() => CommentRepository());
}

void registerModels() {
  GetIt.I.registerFactoryParam<Profile, Map, void>(
      (data, _) => Profile.fromJson(data));
  GetIt.I.registerFactoryParam<Video, Map, void>(
      (data, _) => Video.fromJson(data));
  GetIt.I.registerFactoryParam<Tag, Map, void>((data, _) => Tag.fromJson(data));
  GetIt.I.registerFactoryParam<Suggestion, Map, void>(
      (data, _) => Suggestion.fromJson(data));
  GetIt.I.registerFactoryParam<Comment, Map, void>((data, _) => Comment.fromJson(data));
}
