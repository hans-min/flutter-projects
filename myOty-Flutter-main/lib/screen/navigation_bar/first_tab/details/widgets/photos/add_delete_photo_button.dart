import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoButton extends StatelessWidget {
  const AddPhotoButton({
    required this.onImageAdded,
    super.key,
  });

  final void Function(File) onImageAdded;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => buildImagePicker(context),
      icon: const Icon(Icons.add_a_photo),
      label: const Text("Add photo"),
    );
    // InkWell(
    //   onTap: () => buildImagePicker(context),
    //   child: const RichTextSpan(
    //     text: "Add photo",
    //     leading: Icon(Icons.add_a_photo),
    //   ),
    // );
  }

  void buildImagePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              onPressed: () => getImage(ImageSource.camera),
              label: const Text("From Camera"),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              onPressed: () => getImage(ImageSource.gallery),
              label: const Text("From Gallery"),
            ),
          ],
        );
      },
    );
  }

  Future<File?> getImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) return null;
      final imageTemp = File(pickedFile.path);
      onImageAdded(imageTemp);
      return imageTemp;
    } catch (err) {
      return Future.error("Error adding image: $err");
    }
  }
}

class DeletePhotoButton extends StatelessWidget {
  const DeletePhotoButton({
    required this.deleteImage,
    super.key,
  });

  final VoidCallback deleteImage;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => showAlertDeletePhoto(context),
      icon: const Icon(Icons.delete, color: Colors.red),
      label: const Text(
        "Delete current photo",
        style: TextStyle(color: Colors.red),
      ),
    );
    // InkWell(
    //   onTap: deleteImage,
    //   child: const RichTextSpan(
    //     text: "Delete current photo",
    //     leading: Icon(Icons.delete),
    //   ),
    // );
  }

  Future<void> showAlertDeletePhoto(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          "Are you sure you want to delete the current image ?",
        ),
        actions: [
          TextButton(
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
            onPressed: () {
              deleteImage();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
