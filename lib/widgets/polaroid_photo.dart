import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scarpbook/blocs/scrap_bloc.dart/scrap_bloc.dart';
import 'package:scarpbook/models/scarph_photos_model.dart';
import 'package:scarpbook/screens/update_post.dart';
import 'package:scarpbook/widgets/image_widget.dart';

class PolaroidPhotoCard extends StatelessWidget {
  final ScrapBookPhoto scarpBookPhoto;
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
        GestureDetector(
          onDoubleTap: () async {
            bool? res = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Do you want to delete this ?"),
                actions: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("yes"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("No"),
                    ),
                  ),
                ],
              ),
            );
            if (res == true) {
              if (context.mounted) {
                context
                    .read<ScrapBookBloc>()
                    .add(DeleteScarpPhoto(scarpBookPhoto: scarpBookPhoto));
              }
            }
          },
          onLongPress: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    UpdateScrapPost(scrapBookPhoto: scarpBookPhoto)));
          },
          child: PolaroidPhoto(
            url: scarpBookPhoto.imageLink,
            isEven: isEven,
            polaroidTitle: scarpBookPhoto.polaroidTitle,
          ),
        ),
        if (isEven) ...[const Spacer(), getTextWidget(context)],
      ],
    );
  }

  Widget getTextWidget(BuildContext context) {
    return Expanded(
      flex: 3,
      child: SelectableText(
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

  getWebSizes(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    if (widthSize < 600) {
      return 50;
    } else if (widthSize > 600 && widthSize < 1500) {
      return 80;
    } else {
      return 100;
    }
  }

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
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.4,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ImageWidget.getImageWidget(
                          url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: getWebSizes(context),
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
