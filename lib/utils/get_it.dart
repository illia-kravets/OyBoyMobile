import 'package:get_it/get_it.dart';
import "/data/export.dart";

void startGet() {
  GetIt.I.registerSingleton<AuthRepository>(AuthRepository());
  GetIt.I.registerSingleton<TagRepository>(TagRepository());
  GetIt.I.registerSingleton<SuggestionRepository>(SuggestionRepository());
  GetIt.I.registerSingleton<VideoRepository>(VideoRepository());
  GetIt.I.registerSingleton<StreamRepository>(StreamRepository());
  GetIt.I.registerSingleton<ShortRepository>(ShortRepository());
  GetIt.I.registerSingleton<ProfileRepository>(ProfileRepository());
}

void registerModels() {
  GetIt.I.registerFactoryParam<Profile, Map, void>(
      (data, _) => Profile.fromJson(data));
  GetIt.I.registerFactoryParam<Video, Map, void>(
      (data, _) => Video.fromJson(data));
  GetIt.I.registerFactoryParam<Tag, Map, void>((data, _) => Tag.fromJson(data));
  GetIt.I.registerFactoryParam<Suggestion, Map, void>(
      (data, _) => Suggestion.fromJson(data));
}
