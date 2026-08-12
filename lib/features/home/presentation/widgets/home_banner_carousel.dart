import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bite_go/core/utils/context_extension.dart';

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
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 160,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            autoPlay: widget.banners.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, _) {
              setState(() => _currentIndex = index);
            },
          ),
          items: widget.banners.map((banner) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(context.radius.lg),
              child: Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: context.color.backgroundSecondary,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: context.color.iconSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.banners.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.banners.length, (index) {
              final isActive = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? context.color.primary
                      : context.color.textSecondary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(context.radius.xxl),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
