import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/image_with_shimmer.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeBannerSection extends StatefulWidget {
  const HomeBannerSection({required this.banners, super.key});

  final List<BannerModel> banners;

  @override
  State<HomeBannerSection> createState() => _HomeBannerSectionState();
}

class _HomeBannerSectionState extends State<HomeBannerSection> {
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
              return _BannerData(banner: banner);
            }).toList(),
          ),
          if (widget.banners.length > 1)
            Positioned(
              right: context.space.md,
              bottom: context.space.md,
              child: _BannerDots(
                count: widget.banners.length,
                activeIndex: _currentIndex,
              ),
            ),
        ],
      ),
    );
  }
}

class _BannerData extends StatelessWidget {
  const _BannerData({required this.banner});

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ImageWithShimmer(imageUrl: banner.imageUrl),
        const _BannerBackground(),
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
                    fontSize: context.fontSize.xl,
                    color: context.color.textOnPrimary,
                  ),
                ),
              if (banner.subtitle.isNotEmpty) ...[
                AppGap.h(context.space.xs),
                Text(
                  banner.subtitle,
                  style: context.textStyle.body.copyWith(
                    fontSize: context.fontSize.xs,
                    color: context.color.textOnPrimary.withValues(
                      alpha: context.opacity.medium,
                    ),
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

class _BannerBackground extends StatelessWidget {
  const _BannerBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0, 0.32),
          end: const Alignment(1, 0.68),
          colors: [
            context.color.iconBlack.withValues(alpha: context.opacity.medium),
            context.color.iconBlack.withValues(alpha: context.opacity.low),
          ],
        ),
      ),
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
        padding: context.space.symmetric(
          horizontal: context.space.smXs,
          vertical: context.space.xs,
        ),
        child: Text(
          text,
          style: context.textStyle.title.copyWith(
            fontSize: context.fontSize.xxs,
            color: context.color.textOnPrimary,
          ),
        ),
      ),
    );
  }
}

class _BannerDots extends StatelessWidget {
  const _BannerDots({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: context.space.xs),
          width: isActive ? context.space.md : context.space.xsSm,
          height: context.space.xsSm,
          decoration: BoxDecoration(
            color: isActive
                ? context.color.textOnPrimary
                : context.color.textOnPrimary.withValues(
                    alpha: context.opacity.disabled,
                  ),
            borderRadius: BorderRadius.circular(context.radius.xxl),
          ),
        );
      }),
    );
  }
}
