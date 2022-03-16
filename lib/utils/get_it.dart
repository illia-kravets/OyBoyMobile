import 'package:get_it/get_it.dart';
import "/data/export.dart";

void startGet() {
  GetIt.I.registerSingleton<AuthRepository>(AuthRepository());
  GetIt.I.registerSingleton<TagRepository>(TagRepository());
  GetIt.I.registerSingleton<VideoRepository>(VideoRepository());
  GetIt.I.registerSingleton<StreamRepository>(StreamRepository());
}

void registerModels() {
  GetIt.I.registerFactoryParam<Channel, Map, List>((data, _) => Channel.fromJson(data));
  GetIt.I.registerFactoryParam<Video, Map, List>((data, _) => Video.fromJson(data));
  GetIt.I.registerFactoryParam<Tag, Map, List>((data, _) => Tag.fromJson(data));
}