import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/image_with_shimmer.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({required this.banners, super.key});

  final List<BannerModel> banners;

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              viewportFraction: 1,
              enlargeCenterPage: false,
              enableInfiniteScroll: widget.banners.length > 1,
              autoPlay: widget.banners.length > 1,
              autoPlayInterval: const Duration(seconds: 4),
              onPageChanged: (index, _) {
                setState(() => _currentIndex = index);
              },
            ),
            items: widget.banners.map((banner) {
              return _BannerCard(banner: banner);
            }).toList(),
          ),
          // Page indicator overlaid on the images, bottom-right.
          if (widget.banners.length > 1)
            Positioned(
              right: context.space.md,
              bottom: context.space.md,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.banners.length, (index) {
                  final isActive = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(context.radius.xxl),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner});

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ImageWithShimmer(imageUrl: banner.imageUrl),
        // Gradient overlay for text legibility.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0, 0.32),
              end: const Alignment(1, 0.68),
              colors: [
                Colors.black.withValues(alpha: 0.72),
                Colors.black.withValues(alpha: 0.15),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (banner.badge.isNotEmpty) ...[
                _BannerBadge(text: banner.badge),
                AppGap.h(context.space.sm),
              ],
              if (banner.title.isNotEmpty)
                Text(
                  banner.title,
                  style: context.textStyle.title.copyWith(
                    fontSize: context.space.fontSizeXl,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
              if (banner.subtitle.isNotEmpty) ...[
                AppGap.h(context.space.xs),
                Text(
                  banner.subtitle,
                  style: context.textStyle.body.copyWith(
                    fontSize: context.space.fontSizeXs,
                    color: Colors.white.withValues(alpha: 0.75),
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BannerBadge extends StatelessWidget {
  const _BannerBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.primary,
        borderRadius: BorderRadius.circular(context.radius.xxl),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.space.sm + 2,
          vertical: context.space.xs,
        ),
        child: Text(
          text,
          style: context.textStyle.title.copyWith(
            fontSize: 11,
            color: context.color.textOnPrimary,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
