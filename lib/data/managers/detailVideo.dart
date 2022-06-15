import 'package:get_it/get_it.dart';
import 'package:oyboy/data/export.dart';

class DetailVideoManager extends CRUDManager<VideoRepository> {
  DetailVideoManager({required this.video});

  final Video video;

  @override 
  void initialize() async {
    isLoading = false;
  }

  void like(String text) async {
  }

  void favourite(String text) async {

  }

  void view(String text) async {

  }
}