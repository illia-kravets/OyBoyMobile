import 'package:oyboy/constants/export.dart';
import "package:get_it/get_it.dart";

import "/data/export.dart";

class ProfileManager extends FilterCRUDManager<ProfileRepository> {
  late VideoType selectedVideoType;
  
  bool tabLoading = false;

  late Profile profile;
  Profile editProfile = Profile();
  late AuthRepository authRepo;

  @override
  void goToPage({PageType? page, VideoType? videoType}) {
    this.page = page;
    if (videoType == null) return refresh();
    selectedVideoType = videoType;
    refresh();
  }

  @override
  void initialize() async {
    isLoading = true;
    authRepo = GetIt.I.get<AuthRepository>();
    profile = authRepo.profile;
    editProfile = profile;
    isLoading = false;
    refresh();
  }

  void updateProfile({String? username, String? name, String? description, String? photo, bool save = true}) async {
    isLoading = true;
    // refresh();
    profile = editProfile.copyWith(username: username, fullName: name, description: description);
    await repository.update(profile.id, profile);
    editProfile = Profile();
    await authRepo.fetchProfile();
    refresh();
    // if (save) repository.update(1, editProfile);
  }
}

class BaseDetailProfileManager<T extends CRUDGeneric> extends FilterCRUDManager<T> {
  @override
  void initialize() async {
    isLoading = true;
    await Future.delayed(const Duration(seconds: 1));
    cards = await repository.list();
    isLoading = false;
    refresh();
  }

  void clear() async {
    repository.request.flush();
    cards = await repository.list();
    refresh();
  }

}

class ShortDetailManager extends BaseDetailProfileManager<ShortRepository> {}
class FavouriteDetailManager extends BaseDetailProfileManager<VideoRepository> {}
class VideoDetailManager extends BaseDetailProfileManager<VideoRepository> {}