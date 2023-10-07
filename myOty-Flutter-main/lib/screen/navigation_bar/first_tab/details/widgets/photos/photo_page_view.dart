import 'package:flutter/material.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

class PhotoPageView extends StatelessWidget {
  const PhotoPageView({
    required this.images,
    required this.equipmentName,
    required this.controller,
    super.key,
    this.borderRadius = 15,
  });

  final List<Image> images;
  final String equipmentName;
  final double borderRadius;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: GestureDetector(
            onTap: () => SwipeImageGallery(
              context: context,
              itemBuilder: (context, index) {
                return images[index];
              },
              initialIndex: index,
              itemCount: images.length,
            ).show(),
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                image: DecorationImage(
                  image: images[index].image,
                  fit: BoxFit.cover,
                ),
              ),
              child: buildEqNameWrap(),
            ),
          ),
        );
      },
    );
  }

  Wrap buildEqNameWrap() => Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(borderRadius)),
              color: Colors.black.withOpacity(0.4),
            ),
            child: Text(
              equipmentName,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
}
