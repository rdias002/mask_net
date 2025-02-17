import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ImageViewerScreen extends StatelessWidget {
  final String image;

  const ImageViewerScreen({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () {
                context.router.maybePop();
              },
              icon: const Icon(Icons.close)),
        ),
        Expanded(
            child: InteractiveViewer(
          child: Image.file(
            File(image),
          ),
        )),
      ]),
    );
  }
}
