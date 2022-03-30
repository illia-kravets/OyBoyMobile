import "/data/export.dart";

class ProfileManager extends CRUDManager<Profile, ProfileRepository> {
  late Profile profile;
  Profile editProfile = Profile();

  @override
  void initialize() async {
    isLoading = true;
    profile = await repository.retrieve(1);
    editProfile = profile;
    isLoading = false;
    refresh();
  }

  void updateProfile({String? username, String? name, String? description, String? photo, bool save = true}) {
    profile = editProfile.copyWith(username: username, fullName: name, description: description, photo: photo);
    editProfile = Profile();
    // if (save) repository.update(1, editProfile);
  }
}