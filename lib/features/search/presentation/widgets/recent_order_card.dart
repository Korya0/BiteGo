import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/image_with_shimmer.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/search/data/models/order_model.dart';
import 'package:flutter/material.dart';

class RecentOrderCard extends StatelessWidget {
  const RecentOrderCard({required this.order, super.key});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.radius.md),
          child: SizedBox(
            width: 68,
            height: 68,
            child: ImageWithShimmer(imageUrl: order.imageUrl),
          ),
        ),
        AppGap.w(context.space.smMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.title.copyWith(
                  fontSize: context.fontSize.sm,
                  color: context.color.textPrimaryStrong,
                ),
              ),
              AppGap.h(context.space.xxs),
              Text(
                order.restaurantName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.body.copyWith(
                  fontSize: context.fontSize.xs,
                  color: context.color.textTertiary,
                ),
              ),
              AppGap.h(context.space.xs),
              Row(
                children: [
                  _OrderMeta(
                    icon: Icons.star_rounded,
                    iconColor: context.color.starYellow,
                    textColor: context.color.textMuted,
                    text: order.rating.toStringAsFixed(1),
                  ),
                  AppGap.w(context.space.smMd),
                  _OrderMeta(
                    icon: Icons.location_on_outlined,
                    iconColor: context.color.textTertiary,
                    textColor: context.color.textTertiary,
                    text: order.distanceLabel,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderMeta extends StatelessWidget {
  const _OrderMeta({
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: context.iconSize.xxs, color: iconColor),
        AppGap.w(context.space.xs),
        Text(
          text,
          style: context.textStyle.subtitle.copyWith(
            fontSize: context.fontSize.xxs,
            color: textColor,
          ),
        ),
      ],
    );
  }
}