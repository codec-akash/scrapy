import 'package:flutter/material.dart';
import 'package:scarpbook/models/scarph_photos_model.dart';
import 'package:scarpbook/utils/extension_fucntion.dart';
import 'package:scarpbook/widgets/image_widget.dart';

import 'dart:math' as math;

class PolaroidPhotoCard extends StatelessWidget {
  final ScarpBookPhoto scarpBookPhoto;
  final bool isEven;
  const PolaroidPhotoCard({
    super.key,
    required this.scarpBookPhoto,
    required this.isEven,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isEven) ...[
          getTextWidget(context),
          const Spacer(),
        ],
        PolaroidPhoto(
          url: scarpBookPhoto.imageLink,
          isEven: isEven,
          polaroidTitle: scarpBookPhoto.polaroidTitle,
        ),
        if (isEven) ...[const Spacer(), getTextWidget(context)],
      ],
    );
  }

  Widget getTextWidget(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Text(
        scarpBookPhoto.title ?? " ",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class PolaroidPhoto extends StatelessWidget {
  final String url;
  final bool isEven;
  final String? polaroidTitle;
  const PolaroidPhoto({
    super.key,
    required this.url,
    required this.isEven,
    this.polaroidTitle,
  });

  double get rotatedAngle => (math.pi / 24) * (isEven ? 1 : -1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Positioned(
            child: Transform.rotate(
              angle: rotatedAngle,
              child: IntrinsicWidth(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 10,
                        // bottom: 55,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ImageWidget.getImageWidget(
                        url,
                        height: context.getWidthAspectValue(500),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        polaroidTitle ?? "",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 60,
                width: 60,
                color: Color(0xff00FF00).withOpacity(0.50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
