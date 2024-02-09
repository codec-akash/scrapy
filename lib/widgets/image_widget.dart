import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class ImageWidget {
  static Widget getImageWidget(String imageUrl,
      {double? height, double? width, Color? color, BoxFit? fit}) {
    if (imageUrl.isEmpty) {
      return Container();
    }
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      if (imageUrl.toLowerCase().contains('.svg')) {
        return SvgPicture.network(
          imageUrl,
          height: height,
          width: width,
          color: color,
          placeholderBuilder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(30.0),
            child: const CircularProgressIndicator(),
          ),
        );
      }
      return _getNetworkImage(imageUrl, height: height, width: width, fit: fit);
    } else if (imageUrl.toLowerCase().endsWith('.svg')) {
      return _svgPictureAsset(imageUrl,
          height: height, width: width, color: color);
    } else {
      return _getImageAsset(imageUrl, height: height);
    }
  }

  static SvgPicture _svgPictureAsset(String fileName,
      {Color? color, double? height, double? width}) {
    return SvgPicture.asset(
      fileName,
      height: height,
      width: width,
      color: color,
    );
  }

  static Image _getImageAsset(String path, {double? height}) {
    return Image.asset(
      path,
      height: height,
    );
  }

  static Image _getNetworkImage(String path,
      {double? height, double? width, BoxFit? fit}) {
    return Image.network(
      path,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Colors.grey.withOpacity(0.1),
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container();
      },
    );
  }
}
