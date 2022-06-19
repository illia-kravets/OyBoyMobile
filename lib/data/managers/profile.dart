import 'package:oyboy/constants/export.dart';
import "package:get_it/get_it.dart";

import "/data/export.dart";

class ProfileManager extends FilterCRUDManager<ProfileRepository> {
  late VideoType selectedVideoType;

  bool tabLoading = false;

  Profile profile = Profile();
  int? profileId;
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
    authRepo = GetIt.I.get<AuthRepository>();
    profile = authRepo.profile;
    editProfile = profile;
  }

  void initializeProfile(String? profileId) async {
    isLoading = true;
    profile = await repository.retrieve(profileId);
    editProfile = profile;
    isLoading = false;
    refresh();
  }

  void subscribe () {
    profile = profile.copyWith(subscribed: !profile.subscribed);
    repository.subscribe(profile.id.toString());
    refresh();
  }

  void updateProfile(
      {String? username,
      String? name,
      String? description,
      String? photo,
      bool save = true}) async {
    isLoading = true;
    // refresh();
    profile = editProfile.copyWith(
        username: username, fullName: name, description: description);
    await repository.update(profile.id, profile);
    editProfile = Profile();
    await authRepo.fetchProfile();
    profile = authRepo.profile;
    isLoading = false;
    refresh();
  }
}

class BaseDetailProfileManager<T extends CRUDGeneric>
    extends FilterCRUDManager<T> {
  BaseDetailProfileManager({required this.profileId});
  String profileId;

  @override
  void initialize() async {
    isLoading = true;
    repository.request.flush();
    repository.query(defaultFilters);
    cards = await repository.list();
    isLoading = false;
    refresh();
  }

  void initializeProfile(Profile profile) async {}

  void clear() async {
    repository.request.flush();
    cards = await repository.list();
    refresh();
  }

  Map get defaultFilters => {};
}

class ShortDetailManager extends BaseDetailProfileManager<ShortRepository> {
  ShortDetailManager({required String profileId}) : super(profileId: profileId);

  @override
  Map get defaultFilters => {"profiles": profileId};
}

class FavouriteDetailManager extends BaseDetailProfileManager<VideoRepository> {
  FavouriteDetailManager({required String profileId})
      : super(profileId: profileId);

  @override
  Map get defaultFilters => {"favourite_profiles": profileId};
}

class VideoDetailManager extends BaseDetailProfileManager<VideoRepository> {
  VideoDetailManager({required String profileId}) : super(profileId: profileId);

  @override
  Map get defaultFilters => {"profiles": profileId};
}
