import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import "/constants/export.dart";
import "/widgets/export.dart";


void showFileModalBottomSheet ({
  required BuildContext context,
  MediaType type=MediaType.image, 
  Widget Function(BuildContext context)? builder,
  ValueChanged? then,
}) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15))),
    context: context,
    builder: (context) => builder == null ? PickMedia(type: type) : builder(context) 
  ).then((value) {
    if (then == null) return;
    then(value);
  });
}

class PickMedia extends StatelessWidget {
  const PickMedia({ Key? key, required this.type, this.maxDuration }) : super(key: key);
  final MediaType type;
  final Duration? maxDuration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
          children: [
            ModalRow(
              icon: Icons.browse_gallery, 
              text: "Choose from gallery", 
              onTap: () async {
                XFile? file = await filePicker(ImageSource.gallery);
                if (file == null) return;
                Navigator.of(context).pop(file);
              },
            ),
            ModalRow(
              icon: Icons.camera_enhance, 
              text: "Create ${type.name}", 
              onTap: () async {
                XFile? file = await filePicker(ImageSource.camera);
                if (file == null) return;
                Navigator.of(context).pop(file);
              },
            ),
          ],
      ),
    );
  }

  Future<XFile?> filePicker(ImageSource source) async {
    if (type == MediaType.image) {
      return ImagePicker().pickImage(source: source);
    } else {
      return ImagePicker().pickVideo(source: source, maxDuration: maxDuration);
    }
  }
}