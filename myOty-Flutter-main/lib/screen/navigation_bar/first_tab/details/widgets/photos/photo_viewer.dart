import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myoty/model/equipment/equipment.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/widgets/photos/add_delete_photo_button.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/widgets/photos/photo_page_view.dart';
import 'package:myoty/services/http.dart';

class PhotoViewer extends StatefulWidget {
  const PhotoViewer({required this.equipment, super.key});
  final Equipment equipment;

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  Map<int, Image> images = {};
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    fetchAllImages();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildImagesOrJustTitle(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AddPhotoButton(onImageAdded: onImageAdded),
            if (images.isNotEmpty) DeletePhotoButton(deleteImage: deleteImage),
          ],
        ),
      ],
    );
  }

  Widget buildImagesOrJustTitle() {
    final name = widget.equipment.libelle;
    if (images.isNotEmpty) {
      return SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width - 20,
        child: PhotoPageView(
          controller: controller,
          images: images.values.toList(),
          equipmentName: name,
        ),
      );
    } else {
      return Text(
        name,
        style: Theme.of(context).textTheme.titleLarge,
      );
    }
  }

  Future<void> fetchAllImages() async {
    final media = widget.equipment.images;
    if (media != null) {
      try {
        for (final medium in media) {
          final image = await ImageAPI.fetchImageFromMediaID(id: medium.id);
          if (image == null) return;
          images[medium.id] = image;
        }
        if (mounted) {
          setState(() {});
        }
      } catch (err) {
        log(err.toString());
      }
    }
    log("fetch equipment details image");
  }

  Future<void> onImageAdded(File image) async {
    final eqId = widget.equipment.id;
    final id = await ImageAPI.postImage(image, eqId);
    setState(() {
      images[id] = Image.file(image);
    });
    if (images.length > 1) {
      controller.jumpToPage(images.length - 1);
    }
  }

  void deleteImage() {
    log(controller.page!.round().toString());
    final id = images.keys.elementAt(controller.page!.round());
    ImageAPI.deleteImage(id);
    images.remove(id);
    setState(() {});
    log(controller.page!.round().toString());
  }
}
