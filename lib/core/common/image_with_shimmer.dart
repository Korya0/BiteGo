import 'package:bite_go/core/utils/context_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Network image with a shimmer loading placeholder and an error fallback.
///
/// Use this everywhere an image is loaded from the network in the home
/// feature (banners, food cards, food details).
class ImageWithShimmer extends StatelessWidget {
  const ImageWithShimmer({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => Shimmer.fromColors(
        baseColor: context.color.shimmerBase,
        highlightColor: context.color.shimmerHighlight,
        child: Container(
          width: width,
          height: height,
          color: context.color.shimmerBase,
        ),
      ),
      errorWidget: (_, _, _) => ColoredBox(
        color: context.color.backgroundSecondary,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: context.color.iconSecondary,
          ),
        ),
      ),
    );
  }
}
