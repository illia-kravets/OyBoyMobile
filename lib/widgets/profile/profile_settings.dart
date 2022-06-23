import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oyboy/data/export.dart';
import 'package:oyboy/utils/utils.dart';
import 'package:oyboy/widgets/default/filepicker.dart';
import 'package:oyboy/widgets/export.dart';
import 'package:oyboy/widgets/profile/profile_avatar.dart';
import 'package:oyboy/widgets/video/card.dart';
import 'package:provider/provider.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late ProfileManager manager;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  XFile? _photo;

  @override
  void initState() {
    manager = context.read<ProfileManager>();
    _usernameController = TextEditingController(text: manager.profile.username);
    _nameController = TextEditingController(text: manager.profile.fullName);
    _descriptionController =
        TextEditingController(text: manager.profile.description);
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
    if (value == null || controller.text.isEmpty) return 'notEmptyField'.tr();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "settings".tr(),
          style: theme.textTheme.headline4,
        ),
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
                        setState(() => _photo = file);
                      }),
                  child: Stack(
                    children: [
                      NetworkCircularAvatar(
                        url: (_photo == null ? manager.profile.avatar : _photo!.path) ?? "",
                        radius: 60,
                        local: _photo != null
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Colors.grey[50],
                          ),
                          child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: Colors.grey[100],
                                  border: Border.all(
                                      color: theme.primaryColor, width: 1.2)),
                              child: Icon(
                                Icons.create_outlined,
                                color: theme.primaryColor,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: theme.primaryColor,
                          style: theme.textTheme.bodyText1,
                          validator: (s) =>
                              emptyValidator(s, _usernameController),
                          decoration:
                              InputDecoration(label: Text("username".tr())),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _nameController,
                          cursorColor: theme.primaryColor,
                          style: theme.textTheme.bodyText1,
                          validator: (s) => emptyValidator(s, _nameController),
                          decoration: InputDecoration(label: Text("name".tr())),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: theme.primaryColor,
                          style: theme.textTheme.bodyText1,
                          keyboardType: TextInputType.multiline,
                          minLines: 7,
                          maxLines: 7,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              label: Text("description".tr()),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(14, 10, 14, 6)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 150,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;
                                showDialog(context: context, builder: (_) => const AbsorbLoading());
                                bool success = await manager.updateProfile(
                                    username: _usernameController.text,
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    photo: _photo);
                                Navigator.of(context).pop();
                                if (!success) return showSnackbar(context, "errorOcurs".tr(), color: Colors.red);
                                showSnackbar(context, "profileUpdated".tr(),
                                    color: theme.primaryColor);
                                manager.goToPage();
                              },
                              child: Text(
                                "saveChanges".tr(),
                                style: theme.textTheme.button,
                              ))
                        ),
                        const SizedBox(height: 6,),
                        ElevatedButton(
                          onPressed: () async {
                            clearPages(context);
                            context.read<UserManager>().logout();
                          },
                          style: ElevatedButton.styleFrom(side: const BorderSide(color: Colors.red, width: 2)),
                          child: Text(
                            "logout".tr(),
                            style: theme.textTheme.button!.copyWith(color: Colors.red),
                          )
                        ),
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}
