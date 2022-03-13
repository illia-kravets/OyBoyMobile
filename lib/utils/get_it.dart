import 'package:get_it/get_it.dart';
import "/data/export.dart";

void startGet() {
  GetIt.I.registerSingleton<AuthRepository>(AuthRepository());
  GetIt.I.registerSingleton<VideoRepository>(VideoRepository());
  GetIt.I.registerSingleton<StreamRepository>(StreamRepository());
}
