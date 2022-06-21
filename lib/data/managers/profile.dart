import 'package:image_picker/image_picker.dart';
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
    authRepo = GetIt.I.get<AuthRepository>();
    profile = await repository.retrieve(profileId);
    editProfile = profile;
    isLoading = false;
    refresh();
  }

  void subscribe () {
    profile = profile.copyWith(
      subscribed: !profile.subscribed,
      subscribers: profile.subscribed ? profile.subscribers - 1 : profile.subscribers + 1
    );
    repository.subscribe(profile.id.toString());
    refresh();
  }

  Future<bool> updateProfile(
      {String? username,
      String? name,
      String? description,
      XFile? photo,
      bool save = true}) async {
    profile = editProfile.copyWith(
        username: username, fullName: name, description: description);
    
    bool success = await repository.createWithFiles(
      url: "${profile.id}/",
      data: profile.toMap(), 
      files: {"avatar": photo}, 
      method: 'PATCH'
    );
    if (!success) return success;

    editProfile = Profile();
    await authRepo.fetchProfile();
    profile = authRepo.profile;
    return success;
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

  Map get defaultFilters => {"show_own": "true", "show_banned": "true"};
}

class ShortDetailManager extends BaseDetailProfileManager<ShortRepository> {
  ShortDetailManager({required String profileId}) : super(profileId: profileId);

  @override
  Map get defaultFilters => {"profiles": profileId, ...super.defaultFilters};
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
  Map get defaultFilters => {"profiles": profileId, ...super.defaultFilters};
}
