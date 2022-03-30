import "package:flutter/material.dart";
import "/constants/export.dart";
import "/widgets/export.dart";
import "/utils/utils.dart";
import "/data/export.dart";
import "package:provider/provider.dart";

class ProfilePageSelector {
  static MaterialPage profile() {
    return const MaterialPage(
      name: OyBoyPages.profilePath,
      key: ValueKey(OyBoyPages.profilePath),
      arguments: {"test", "new"},
      child: ProfilePage()
    );
  }

  static MaterialPage profileSettings() {
    return const MaterialPage(
      name: OyBoyPages.profileSettingsPath,
      key: ValueKey(OyBoyPages.profileSettingsPath),
      child: ProfileSettingsPage()
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileManager manager;

  @override
  void initState() {
    manager = context.read<ProfileManager>();
    manager.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool loading = context.select((ProfileManager m) => m.isLoading);
    return DefaultPage(
      body: SafeArea(
        child: loading
          ? const Loader(
              strokeWidth: 4,
              height: 35,
              width: 35,
            )
          : Column(
            children: const [
              ProfileInfo()
            
            ],
          ),
        ),
    );
  }
}


class ProfileInfo extends StatelessWidget {
  const ProfileInfo({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileManager manager = context.read<ProfileManager>();
    Profile profile = context.select((ProfileManager m) => m.profile);
    ThemeData theme = Theme.of(context);
    final data = ModalRoute.of(context)!.settings.arguments;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(profile.photo ?? ""),
                ),
                const SizedBox(height: 10,),
                Text(profile.username ?? "", style: theme.textTheme.headline4),
                const SizedBox(height: 4,),
                Text(profile.fullName ?? "", style: theme.textTheme.headline4),
                const SizedBox(height: 10,),
                Text(profile.description ?? "", style: theme.textTheme.bodyText2, textAlign: TextAlign.center),
                const SizedBox(height: 10,),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                        child: Column(
                          children: [
                            Text(profile.subscriptions.toString(), style: theme.textTheme.bodyText1,),
                            Text("Subscriptions", style: theme.textTheme.headline6),
                          ]
                        ),
                      ),
                      const VerticalDivider(width: 1, color: Colors.grey),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                        child: Column(
                          children: [
                            Text(profile.subscribers.toString(), style: theme.textTheme.bodyText1,),
                            Text("Subscribers", style: theme.textTheme.headline6),
                          ]
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0, 
            right: -5,
            child: IconButton(
              icon: Icon(Icons.settings_outlined, color: theme.primaryColor,), 
              onPressed: () => manager.goToPage(page: PageType.settings)
            )
          )
        ],
      ),
    );
  }
}


class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({ Key? key }) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late ProfileManager manager;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  
  @override
  void initState() {
    manager = context.read<ProfileManager>();
    _usernameController = TextEditingController(text: manager.profile.username);
    _nameController = TextEditingController(text: manager.profile.fullName);
    _descriptionController = TextEditingController(text: manager.profile.description);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? emptyValidator(String? value, TextEditingController controller) {
    if (value == null || controller.text.isEmpty) return 'This field must not me empty';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return DefaultPage(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings", style: theme.textTheme.headline4,),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), 
          onPressed: () => manager.goToPage(), 
          color: theme.primaryColor,
        ),
        elevation: 0,
        backgroundColor: Colors.grey[50],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => showFileModalBottomSheet(
                  context: context,
                  then: (file) {
                    if (file == null) return;
                    // TODO: show xfile photo
                    // manager.editProfile = manager.editProfile.copyWith(photo: file.path);
                    manager.updateProfile(save: false);
                  }
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(manager.profile.photo ?? ""),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey[50],
                        ),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            color: Colors.grey[100],
                            border: Border.all(color: theme.primaryColor, width: 1.2)
                          ),
                          child: Icon(Icons.create_outlined, color: theme.primaryColor,)
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: theme.primaryColor,
                      style: theme.textTheme.bodyText1,
                      validator: (s) => emptyValidator(s, _usernameController),
                      decoration: const InputDecoration(
                        label: Text("Username")
                      ),
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: _nameController,
                      cursorColor: theme.primaryColor,
                      style: theme.textTheme.bodyText1,
                      validator: (s) => emptyValidator(s, _nameController),
                      decoration: const InputDecoration(
                        label: Text("Full Name")
                      ),
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: _descriptionController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: theme.primaryColor,
                      style: theme.textTheme.bodyText1,
                      keyboardType: TextInputType.multiline,
                      minLines: 7,
                      maxLines: 7,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        label: Text("Desctiption"),
                        contentPadding: EdgeInsets.fromLTRB(14, 10, 14, 6)
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            manager.updateProfile(
                              username: _usernameController.text,
                              name: _nameController.text,
                              description: _descriptionController.text
                            );
                            manager.goToPage();
                            showSnackbar(context, "Profile was updated", color: theme.primaryColor);
                          }
                        }, 
                        child: Text("Save Changes", style: theme.textTheme.button,)
                      ),
                    ),
                  ],
                )
              )
            ],
          )
        ),
      ),
    );
  }

  
}