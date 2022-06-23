import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:oyboy/data/export.dart';
import 'package:oyboy/data/managers/create.dart';
import 'package:oyboy/utils/utils.dart';
import "/constants/export.dart";
import "/widgets/export.dart";
import "package:provider/provider.dart";
import 'package:google_fonts/google_fonts.dart';
import "package:image_picker/image_picker.dart";

class CreatePage {
  static MaterialPage videoCreate() {
    return MaterialPage(
        name: OyBoyPages.videoCreatePath,
        key: const ValueKey(OyBoyPages.videoCreatePath),
        child: ChangeNotifierProvider<CreateManager>(
            create: (context) => CreateManager(),
            child: const VideoCreatePage()));
  }

  static MaterialPage streamCreate() {
    return MaterialPage(
        name: OyBoyPages.streamCreatePath,
        key: const ValueKey(OyBoyPages.streamCreatePath),
        child: ChangeNotifierProvider<CreateManager>(
            create: (context) => CreateManager(),
            child: const StreamCreatePage()));
  }

  static MaterialPage shortCreate() {
    return MaterialPage(
        name: OyBoyPages.shortCreatePath,
        key: const ValueKey(OyBoyPages.shortCreatePath),
        child: ChangeNotifierProvider<CreateManager>(
            create: (context) => CreateManager(),
            child: const ShortCreatePage()));
  }
}

class VideoCreatePage extends StatelessWidget {
  const VideoCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.read<VideoManager>().goToPage(),
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          "createVideo".tr(),
          style: theme.textTheme.headline4,
        ),
      ),
      body: const BaseCreatePage(createType: VideoType.video),
    );
  }
}

class StreamCreatePage extends StatelessWidget {
  const StreamCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => context.read<StreamManager>().goToPage(),
            child: const Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: Text(
            "Start live",
            style: theme.textTheme.headline4,
          ),
        ),
        body: const BaseCreatePage(createType: VideoType.stream));
  }
}

class ShortCreatePage extends StatelessWidget {
  const ShortCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.read<ShortManager>().goToPage(),
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          "createShort".tr(),
          style: theme.textTheme.headline4,
        ),
      ),
      body: const BaseCreatePage(createType: VideoType.short),
    );
  }
}

class BaseCreatePage extends StatefulWidget {
  const BaseCreatePage({Key? key, required this.createType}) : super(key: key);
  final VideoType createType;

  @override
  State<BaseCreatePage> createState() => _BaseCreatePageState();
}

class _BaseCreatePageState extends State<BaseCreatePage> {
  final _formKey = GlobalKey<FormState>();
  late CreateManager manager;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    manager = context.read<CreateManager>();

    final banner = context.select((CreateManager m) => m.banner);
    final video = context.select((CreateManager m) => m.video);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || _nameController.text.isEmpty)
                        return 'notEmptyField'.tr();
                      return null;
                    },
                    onTap: () => manager.tagInputSelected = false,
                    style: theme.textTheme.bodyText1,
                    maxLength: 126,
                    cursorColor: theme.primaryColor,
                    decoration: InputDecoration(
                        label: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100)),
                            child: Text("videoName".tr()))),
                    buildCounter: (_,
                        {required currentLength,
                        maxLength,
                        required isFocused}) {
                      if (isFocused) {
                        return Container(
                            alignment: Alignment.topRight,
                            child: Text(currentLength.toString() +
                                "/" +
                                maxLength.toString()));
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    style: theme.textTheme.bodyText1,
                    cursorColor: theme.primaryColor,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        label: Text("description".tr()),
                        contentPadding:
                            const EdgeInsets.fromLTRB(14, 10, 14, 6)),
                    maxLines: 7,
                    minLines: 7,
                    onTap: () => manager.tagInputSelected = false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const InputTag(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.createType != VideoType.stream) ...[
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          showMediaModal(MediaType.video),
                                      child: chooseButtonText(),
                                    )),
                                if (video != null)
                                  Text(
                                    video.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.0,
                                        color: theme.primaryColor),
                                  )
                              ],
                            )),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        showMediaModal(MediaType.image),
                                    child: Text(
                                      "chooseBanner".tr(),
                                      style: theme.textTheme.button,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              if (banner != null)
                                Text(
                                  banner.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12.0,
                                      color: theme.primaryColor),
                                )
                            ],
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;
                              showDialog(context: context, builder: (_) => const AbsorbLoading());
                              bool success = await manager.publish(
                                  name: _nameController.text,
                                  type: widget.createType.value,
                                  description: _descriptionController.text);
                              Navigator.of(context).pop();
                              if (!success) return showSnackbar(context, "errorOcurs".tr(), color: Colors.red);
                              showSnackbar(context, "videoAdded".tr(), color: theme.primaryColor);
                              Navigator.of(context).pop();
                            },
                            child: widget.createType == VideoType.stream
                                ? Text(
                                    "startLive".tr(),
                                    style: theme.textTheme.button,
                                  )
                                : Text("publish".tr(),
                                    style: theme.textTheme.button)),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showMediaModal(MediaType type) {
    Duration? maxDuration;
    if (widget.createType == VideoType.short && type != MediaType.image)
      maxDuration = const Duration(seconds: 30);
    showFileModalBottomSheet(
        context: context,
        type: type,
        builder: (context) => PickMedia(type: type, maxDuration: maxDuration),
        then: (value) {
          if (value == null) return;
          type == MediaType.image
              ? manager.banner = value
              : manager.video = value;
          manager.refresh();
        });
  }

  Widget chooseButtonText() {
    TextStyle? style = Theme.of(context).textTheme.button;
    return widget.createType == VideoType.video
        ? Text(
            "chooseVideo".tr(),
            style: style,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "chooseVideo".tr(),
                style: style,
              ),
              Text(
                "(${'upSeconds'.tr()})",
                style: style,
              )
            ],
          );
  }
}

class InputTag extends StatefulWidget {
  const InputTag({Key? key}) : super(key: key);

  @override
  State<InputTag> createState() => _InputTagState();
}

class _InputTagState extends State<InputTag> {
  late CreateManager manager;
  late TextEditingController _tagController;
  late FocusNode _tagFocus;

  void onTagChange() {
    manager.updateTag(_tagController.text);
    if (manager.tagStr != _tagController.text) {
      _tagController.value = TextEditingValue(
          text: manager.tagStr,
          selection: TextSelection.collapsed(offset: manager.tagStr.length));
    }
  }

  @override
  void initState() {
    manager = context.read<CreateManager>();
    _tagController = TextEditingController();
    _tagFocus = FocusNode();
    super.initState();
    _tagController.addListener(onTagChange);
  }

  @override
  void dispose() {
    _tagController.removeListener(onTagChange);
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    CreateManager manager = context.watch<CreateManager>();

    return GestureDetector(
      onTap: () {
        _tagFocus.requestFocus();
        setState(() => manager.tagInputSelected = true);
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
                border: Border.all(
                    color: manager.tagInputSelected
                        ? theme.primaryColor
                        : Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            child: Wrap(
              spacing: 6,
              children: [
                ...List.generate(
                  manager.tags.length,
                  (i) => Chip(
                      shadowColor: theme.primaryColor,
                      label: Text(
                        manager.tags[i].name,
                        style: theme.textTheme.bodyText2,
                      ),
                      deleteIcon: Icon(
                        Icons.close,
                        color: theme.primaryColor,
                      ),
                      onDeleted: () => manager.popTag(manager.tags[i])),
                ),
                SizedBox(
                  width: _tagController.text.isEmpty
                      ? 10
                      : manager.tagStr.length * 12,
                  child: TextFormField(
                      focusNode: _tagFocus,
                      controller: _tagController,
                      style: theme.textTheme.bodyText1,
                      cursorColor: theme.primaryColor,
                      onTap: () => manager.tagInputSelected = true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      )),
                ),
              ],
            ),
          ),
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 200),
          //   top: manager.hasTagContent ? -12 : 11,
          //   left: 12,
          //   child: Text(
          //       "Tags", style: manager.hasTagContent
          //         ? GoogleFonts.poppins(fontSize: 15.0, color: theme.primaryColor, fontWeight: FontWeight.w500)
          //         : GoogleFonts.poppins(fontSize: 17.0, color: Colors.grey),
          //     ),
          // ),
          Transform.translate(
            offset: manager.hasTagContent
                ? const Offset(12, -12)
                : const Offset(12, 11),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              color: Colors.grey[50],
              child: Text(
                "tags".tr(),
                style: manager.hasTagContent
                    ? GoogleFonts.poppins(
                        fontSize: 15.0,
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500)
                    : GoogleFonts.poppins(fontSize: 17.0, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
