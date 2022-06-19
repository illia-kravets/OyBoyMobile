

// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:oyboy/constants/export.dart';
import 'package:oyboy/data/export.dart';
import 'package:oyboy/data/models/video.dart';
import 'package:oyboy/data/repositories/profile.dart';
import 'package:oyboy/data/repositories/video.dart';

import '../../utils/utils.dart';

class ReportDialog extends StatefulWidget {
  ReportDialog({ Key? key, required this.video }) : super(key: key);
  final Video video;

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _reportController = TextEditingController();
  ReportType reportType = ReportType.channel;

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 330,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[50]),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("report".tr(), style: theme.textTheme.headline3, textAlign: TextAlign.center,),
                    const SizedBox(height: 4,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _getRadioButton(theme, ReportType.channel), 
                        _getRadioButton(theme, ReportType.video)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _reportController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: theme.primaryColor,
                      style: theme.textTheme.bodyText1,
                      minLines: 5,
                      maxLines: 5,
                      validator: (s) =>
                          _emptyValidator(s, _reportController),
                      decoration:
                          InputDecoration(
                            hintText: "detailReportPlaceholder".tr(),
                        ),
                      
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              String text = _reportController.text;
                              if (reportType == ReportType.channel)
                                GetIt.I.get<ProfileRepository>().sendReport(
                                  widget.video.channelId.toString(), text);
                              else GetIt.I.get<VideoRepository>().sendReport(
                                widget.video.id.toString(), text);
                              
                              Navigator.of(context).pop();
                              showSnackbar(context, "reportSent".tr(),
                                  color: theme.primaryColor);
                            }
                          },
                          child: Text(
                            "sendReport".tr(),
                            style: theme.textTheme.button,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  String? _emptyValidator(String? value, TextEditingController controller) {
    if (value == null || controller.text.isEmpty) return 'notEmptyField'.tr();
    return null;
  }

  Widget _getRadioButton(ThemeData theme, ReportType type) {
    return GestureDetector(
      onTap: () => setState(() => reportType = type),
      child: Row(children: [
        SizedBox(
          width: 20,
          child: Radio<ReportType>( 
            activeColor: theme.primaryColor,
            focusColor: theme.primaryColor,
            value: type,
            groupValue: reportType,
            onChanged: (value) {},
          ),
        ),
        const SizedBox(width: 10,),
        Text(type.title, style: theme.textTheme.bodyText1,), 
      ],),
    );
  }
}