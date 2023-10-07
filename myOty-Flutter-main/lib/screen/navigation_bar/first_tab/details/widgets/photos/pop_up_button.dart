import 'package:flutter/material.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/widgets/photos/add_delete_photo_button.dart';

class AddDeletePhotoMenu extends StatelessWidget {
  const AddDeletePhotoMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PhotoMenuEnum>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case PhotoMenuEnum.add:
          //widget.onSubmitted(textController.text);
          case PhotoMenuEnum.delete:
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: PhotoMenuEnum.add,
          child: AddPhotoButton(
            onImageAdded: (file) {},
          ),
        ),
        PopupMenuItem(
          value: PhotoMenuEnum.delete,
          child: DeletePhotoButton(deleteImage: () {}),
        ),
      ],
    );
  }

  // Future<void> onImageAdded(File image) async {
  //   final eqId = widget.equipment.id;
  //   final id = await ImageAPI.postImage(image, eqId);
  //   setState(() {
  //     images[id] = Image.file(image);
  //   });

  //   controller.jumpToPage(images.length - 1);
  // }

  //   void deleteImage() {
  //   log(controller.page!.round().toString());
  //   final id = images.keys.elementAt(controller.page!.round());
  //   ImageAPI.deleteImage(id);
  //   images.remove(id);
  //   setState(() {});
  //   log(controller.page!.round().toString());
  // }
}

enum PhotoMenuEnum { add, delete }
